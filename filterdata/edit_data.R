library(tidyverse)
library(reshape2)
setwd("/home/naoya/Desktop/Wind_PF")
out1 <- read.csv("filterdata/out1.csv",header = F)
out2 <- read.csv("filterdata/out2.csv",header = F)
wt <- read.csv("filterdata/weight.csv",header = F)

out1R <- read.csv("R_data/out1.csv")[,-1]
out2R <- read.csv("R_data/out2.csv")[,-1]
wtR <- read.csv("R_data/wt.csv")[,-1]


Rno1 <- rowSums(out1R*wtR)
out <- rowSums(out1*wt)

particle1 <- cbind(x=c(1:100),out1[-1,]) %>% melt(id="x")
wt1 <- cbind(x=c(1:100),wt[-1,]) %>% melt("x")
data1 <- cbind(particle1,wt1)
data1 <- data1[,c(1,3,6)]

write.csv(cbind(data1,data1[,3]*10),"filterdata/particle_plot/out_particle1.csv")

particle1 <- cbind(x=c(1:100),out1R[-1,]) %>% melt(id="x")
wt1 <- cbind(x=c(1:100),wtR[-1,]) %>% melt("x")
data1 <- cbind(particle1,wt1)
data1 <- data1[,c(1,3,6)]
write.csv(cbind(data1,data1[,3]*10),"filterdata/particle_plot/out_R_particle1.csv")

write.csv(cbind(c(1:100),out[-1]),"filterdata/particle_plot/out1_mean.csv")
write.csv(cbind(c(1:100),Rno1[-1]),"filterdata/particle_plot/outR1_mean.csv")


