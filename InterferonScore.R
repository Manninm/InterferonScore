##### You will need singscore installed use: if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("singscore")

##### You will need Genome wide annotation of Human installed use: if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("org.Hs.eg.db")

##### You will need openxlsx installed use: install.packages('openxlsx')

##### Input expression matrix file path, expression matrix should be a .xlsx file with gene identifiers in column 1
Exp<-''

#### What sheet is the expression matrix on?
Sheet=

##### Input gene list file path. Should be a text file with 1 gene per column, no header
GeneList<-''


##### Do you have a symbols column? 'TRUE'/'FALSE'
GeneSymbols=

##### Do you want P-values? May take longer to run. 'Yes' or 'No'
P-values=


library('singscore')
library("org.Hs.eg.db")

Exp<-read.xlsx(Exp,rowNames=TRUE,sheet=Sheet



Map<-unique(as.character(mapIds(org.Hs.eg.db,Symbols$V1,'ENTREZID','SYMBOL')))