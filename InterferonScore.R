##### You will need singscore installed use: if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("singscore")

##### You will need Genome wide annotation of Human installed use: if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("org.Hs.eg.db")

##### You will need openxlsx installed use: install.packages('openxlsx')

##### Pvalues requires BiocParallel use: if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("BiocParallel")

##### Input expression matrix file path, expression matrix should be a .xlsx file with gene identifiers in column 1
Exp<-''

#### What sheet is the expression matrix on?
Sheet=

##### Input gene list file path. Should be a text file with 1 gene per column, no header
GeneList<-''

##### Do you have a symbols column? 'TRUE'/'FALSE' in your expression matrix?
GeneSymbols=

##### Do you want P-values? May take longer to run. 'True/False'
Pvalues=

#### Number of Bootstraps for Permutated pvalues
Boots=

library('singscore')
library("org.Hs.eg.db")
library('openxlsx')

Exp<-read.xlsx(Exp,rowNames=TRUE,sheet=Sheet)
Genes<-as.data.frame(read.table(Genelist,header=TRUE,stringsAsFactors=FALSE))
Map<-unique(as.character(mapIds(org.Hs.eg.db,Symbols$V1,'ENTREZID','SYMBOL')))

if(isTrue(GeneSymbols)){
	Exp<-Exp[,-c(1)]
	}
Rank<-rankGenes(Exp)
Scored<-simpleScore(Rank,upSet=Genes$V1)

if (isTrue(Pvalues)){
	ncores <- parallel::detectCores() - 2
	permuteResult <- generateNull(upSet=Genes$V1, rankData = Rank[,1:ncol(Rank)], centerScore=TRUE, knownDirection=TRUE, B=Boots, ncores=ncores, seed=109327051,useBPPARAM=NULL)
	pvals=getPvals(permuteResult,Scored[1:nrow(Scored),drop=FALSE])
	}