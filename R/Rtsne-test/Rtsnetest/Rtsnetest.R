
library(data.table)
library(Rtsne)
library(ggplot2)
#tSNE analysis eCLIP
eCLIP_data<-fread("eCLIP_peak_counts.txt")
colnames(eCLIP_data)[1]<-"gene_id"
meta <- fread("v28_genelist.txt")
m1<-merge(eCLIP_data,meta)


df<-data.frame(m1[,c(80,2:79)])
row.names(df) <- m1$gene_id
df <- df[apply(df[2:79],1,sum) > 100,] #select abundant target genes
tSNE <- Rtsne(as.matrix(df[,-1]), 
              check_duplicates = FALSE, verbose=TRUE)

df$tSNE_1<-tSNE$Y[,1]
df$tSNE_2<-tSNE$Y[,2]
df$gene_type <- as.factor(df$gene_type)
g <- ggplot(df,aes(x=df$tSNE_1,y=df$tSNE_2,color = df$gene_type))+
  geom_point()
ggsave(filename = "eCLIP_tSNE.png",g,width = 15, height = 10)
