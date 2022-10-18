### Creating an argument parser
library("optparse")

option_list = list(
  make_option(c("-p","--popA"), type="character",default=NULL,help="path to unzipped mafs file for pop 1",metavar="character"),
  make_option(c("-q","--popB"), type="character",default=NULL,help="path to unzipped mafs file for pop 2",metavar="character"),
  make_option(c("-t","--totLen"), type="numeric",default=NULL,help="total sequence length for global per site Dxy estimate [optional]",metavar="numeric")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

### Troubleshooting input
if(is.null(opt$popA) | is.null(opt$popB)){
  print_help(opt_parser)
  stop("One or more of the mafs paths are missing", call.=FALSE)
}

if(grepl('.gz$',opt$popA) | grepl('.gz$',opt$popB)){
  print_help(opt_parser)
  stop("One or more of the mafs is gzipped.", call.=FALSE)
}

if(is.null(opt$totLen)){
  print("Total length not supplied. The output will not be a per site estimate.")
}

### Reading data in
allfreqA <- read.table(opt$popA,sep='\t',row.names=NULL, header=T)
allfreqB <- read.table(opt$popB,sep='\t',row.names=NULL, header=T)

### Manipulating the table and print dxy table
allfreq <- merge(allfreqA, allfreqB, by=c("chromo","position"))
allfreq <- allfreq[order(allfreq$chromo, allfreq$position),]
# -> Actual dxy calculation
allfreq <- transform(allfreq, dxy=(knownEM.x*(1-knownEM.y))+(knownEM.y*(1-knownEM.x)))
write.table(allfreq[,c("chromo","position","dxy")], file="Dxy_persite.txt",quote=FALSE, row.names=FALSE, sep='\t')
print('Created Dxy_persite.txt')

### Print global dxy
print(paste0('Global dxy is: ',sum(allfreq$dxy)))
if(!is.null(opt$totLen)){
  print(paste0('Global per site Dxy is: ',sum(allfreq$dxy)/opt$totLen))
}
