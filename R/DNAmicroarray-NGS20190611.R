#マイクロアレイ論文検索の結果csv
inf_1<-"/Users/yomiyama/Desktop/github-HP/NGS-microarraycomparison/pubmedmicroArray.csv"
#NGS論文検索結果csv
inf_2<-"/Users/yomiyama/Desktop/github-HP/NGS-microarraycomparison/pubmedNGS.csv"
#出力ファイル
out_1<-"Comparison2.png"
#ワーキングディレクトリ指定
wd<-"/Users/yomiyama/Desktop/github-HP/NGS-microarraycomparison/"
#画像サイズ
dpi<-300

#年範囲min
n1<-2000

#年範囲max
n2<-2018

setwd(wd)
x1<-read.csv(inf_1,header=FALSE)
x2<-read.csv(inf_2,header=FALSE)

library(readxl)
library(tidyverse)
library(dplyr)
library(ggplot2)

###データ整形

micro<-x1[,2]
micro<-micro[c(-1,-2)]
micro<-as.numeric(as.character(micro))
year1<-x1[,1]
year1<-year1[c(-1,-2)]
year1<-as.numeric(as.character(year1))

NGS<-x2[,2]
NGS<-NGS[c(-1,-2)]
NGS<-as.numeric(as.character(NGS))
year2<-x2[,1]
year2<-year2[c(-1,-2)]
year2<-as.numeric(as.character(year2))


DNAmicro<-data.frame(year1,micro)
NGS<-data.frame(year2,NGS)

########データ範囲指定

D2<-DNAmicro %>% dplyr::filter(year1 >= n1) %>% dplyr::filter(year1<n2)
N2<-NGS %>% dplyr::filter(year2 >= n1) %>% dplyr::filter(year2<n2)
n<-nrow(D2)
species <- rep(c("DNAmicroarray","NGS"),each=n)
tech1<-cbind(t(D2[,2]),t(N2[,2]))
tech1<-t(tech1)
year<-D2[,1]
tech2<-data.frame(year,tech1,species)

##ggplot2による描画

g1<-ggplot(tech2)+geom_line(size=5,mapping=aes(x=year,y=tech1,color=species))+
  labs(title="Comparison of Technology",x="Year",y="Count")
g2<-g1 + theme(plot.subtitle = element_text(vjust = 1), 
    plot.caption = element_text(vjust = 1), 
    axis.title = element_text(size = 20, 
        face = "bold"), axis.text = element_text(size = 15, 
        face = "bold", colour = "black"), 
    plot.title = element_text(size = 25, 
        face = "bold", hjust = 0.5), legend.text = element_text(size = 15, 
        face = "bold"), legend.title = element_text(size = 15, 
        face = "bold"), plot.background = element_rect(size = 0.6)) 
plot(g2)
ggsave(out_1,g2,dpi=dpi)

