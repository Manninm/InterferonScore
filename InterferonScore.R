##### You will need singscore installed use: if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("singscore")

##### You will need Genome wide annotation of Human installed use: if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("org.Hs.eg.db")

##### You will need openxlsx installed use: install.packages('openxlsx')

##### Pvalues requires BiocParallel use: if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("BiocParallel")

library('singscore')
library("org.Hs.eg.db")
library('openxlsx')
##### Input expression matrix file path, expression matrix should be a .xlsx file with gene identifiers in column 1
Exp<-"Jess.xlsx"

#### What sheet is the expression matrix on?
Sheet=1

##### Input gene list file path. Should be a text file with 1 gene per column, no header
GeneList<-"/home/manninm/GitProjects/InterferonScore/M1.2_genes.txt"

##### Out file name, will be created in current working directory unless full path is given, please include the '.xlsx' ending
OutFile<-'Cats.xlsx'

##### Do you have a symbols column? TRUE or FALSE in your expression matrix?
GeneSymbols=FALSE

##### Do you want P-values? May take longer to run. TRUE or FALSE
Pvalues=FALSE

#### Number of Bootstraps for Permutated pvalues
Boots=500

Exp<-read.xlsx(Exp,sheet=Sheet,rowNames=TRUE)
Genes<-as.data.frame(read.table(GeneList,stringsAsFactors=FALSE))
Map<-unique(as.character(mapIds(org.Hs.eg.db,Genes$V1,'ENTREZID','SYMBOL')))

if(isTRUE(GeneSymbols)){
	Exp<-Exp[,-c(1)]
} else {
}
Rank<-rankGenes(Exp)
Scored<-simpleScore(Rank,upSet=Map)
if (isTRUE(Pvalues)){
	ncores <- parallel::detectCores() - 2
	permuteResult <- generateNull(upSet=Map, rankData = Rank[,1:ncol(Rank)], centerScore=TRUE, knownDirection=TRUE, B=Boots, ncores=ncores, seed=109327051,useBPPARAM=NULL)
	pvals=getPvals(permuteResult,Scored[1:ncol(Scored)])
	Scored<-cbind(Scored,pvals)
	write.xlsx(Scored,OutFile,row.names=TRUE)
} else {
	write.xlsx(Scored,OutFile,row.names=TRUE)
}