#######################
##...................##
##...Data analysis...##
##...................##
#######################

##...Libraries

library(ade4)
library(shape)

##...Data

Dia_size_plot<-read.csv("data/Dia_size_plot.csv")
Dia_size_cons<-read.csv("data/Dia_size_cons.csv")
Plot_loc<-read.csv("data/Plot_loc.csv")
Cons_obs<-read.csv("data/Cons_obs.csv")
Birds<-read.csv("data/Birds.csv")

##...Frequency of dispersal syndromes

#...Species

N_sp<-dim(Dia_size_plot)[1] # 460 species

Endozoochory<-sum(Dia_size_plot$Syndrome=="endozoochory")
Anemochory<-sum(Dia_size_plot$Syndrome=="anemochory")
Other<-sum(Dia_size_plot$Syndrome!="endozoochory" & Dia_size_plot$Syndrome!="anemochory")

N_sp_synd<-c(Endozoochory,Anemochory,Other)
names(N_sp_synd)<-c("Endozoochory","Anemochory","Other")

tiff("figures/N_sp_synd.tiff",units="in",width=4,height=4,res=300)
pie(N_sp_synd,col=c(rgb(0.2,0.2,0.8,0.25),"lightgrey","darkgrey"))
dev.off()

Perc_sp_synd<-round((N_sp_synd/N_sp)*100,1)

#...Trees

N_trees_sp<-apply(Dia_size_plot[,13:33],1,sum)

N_trees<-sum(N_trees_sp,na.rm=T) # 20462 trees

Endozoochory<-sum(N_trees_sp[Dia_size_plot$Syndrome=="endozoochory"],na.rm=T)
Anemochory<-sum(N_trees_sp[Dia_size_plot$Syndrome=="anemochory"])
Other<-sum(N_trees_sp[Dia_size_plot$Syndrome!="endozoochory" & Dia_size_plot$Syndrome!="anemochory"])

N_trees_synd<-c(Endozoochory,Anemochory,Other)
names(N_trees_synd)<-c("Endozoochory","Anemochory","Other")

tiff("figures/N_trees_synd.tiff",units="in",width=4,height=4,res=300)
pie(N_trees_synd,labels=NA,col=c(rgb(0.2,0.2,0.8,0.25),"lightgrey","darkgrey"))
dev.off()

Perc_trees_synd<-round((N_trees_synd/N_trees)*100,1)

##...Diaspore size for endozoochorous species

#...Removing non-endozoochorous species

Dia_size_plot_endo<-Dia_size_plot[which(Dia_size_plot$Syndrome=="endozoochory"),]
N_trees_sp_endo<-N_trees_sp[which(Dia_size_plot$Syndrome=="endozoochory")]

#...Compiling limiting diaspore diemension

Dim_1<-numeric()
Dim_2<-numeric()
Dim_3<-numeric()
Dim_lim_sp<-numeric()

for (i in 1:dim(Dia_size_plot_endo)[1]){
  Dim_1[i]<-mean(c(Dia_size_plot_endo$Dia_d1_min[i],Dia_size_plot_endo$Dia_d1_max[i]),na.rm=T)
  Dim_2[i]<-mean(c(Dia_size_plot_endo$Dia_d2_min[i],Dia_size_plot_endo$Dia_d2_max[i]),na.rm=T)
  Dim_3[i]<-mean(c(Dia_size_plot_endo$Dia_d3_min[i],Dia_size_plot_endo$Dia_d3_max[i]),na.rm=T)
  temp<-sort(c(Dim_1[i],Dim_2[i],Dim_3[i]))
  if (sum(is.na(temp)==F)==1) Dim_lim_sp[i]<-temp[1]
  if (sum(is.na(temp)==F)==2) Dim_lim_sp[i]<-temp[1]
  if (sum(is.na(temp)==F)==3) Dim_lim_sp[i]<-temp[2]
} 

Dia_size_plot_endo<-cbind(Dia_size_plot_endo,Dim_lim_sp)

Dim_1<-numeric()
Dim_2<-numeric()
Dim_3<-numeric()
Dim_lim_sp<-numeric()

for (i in 1:dim(Dia_size_cons)[1]){
  Dim_1[i]<-mean(c(Dia_size_cons$Dia_d1_min[i],Dia_size_cons$Dia_d1_max[i]),na.rm=T)
  Dim_2[i]<-mean(c(Dia_size_cons$Dia_d2_min[i],Dia_size_cons$Dia_d2_max[i]),na.rm=T)
  Dim_3[i]<-mean(c(Dia_size_cons$Dia_d3_min[i],Dia_size_cons$Dia_d3_max[i]),na.rm=T)
  temp<-sort(c(Dim_1[i],Dim_2[i],Dim_3[i]))
  if (sum(is.na(temp)==F)==1) Dim_lim_sp[i]<-temp[1]
  if (sum(is.na(temp)==F)==2) Dim_lim_sp[i]<-temp[1]
  if (sum(is.na(temp)==F)==3) Dim_lim_sp[i]<-temp[2]
} 

Dia_size_cons<-cbind(Dia_size_cons,Dim_lim_sp)

Dim_lim_trees<-numeric()
for (i in 1:length(Dim_lim_sp)){
  if (is.na(N_trees_sp_endo[i])==F) Dim_lim_trees<-c(Dim_lim_trees,
                                                  rep(Dim_lim_sp[i],
                                                  N_trees_sp_endo[i]))
} 

tiff("figures/Hist_dim_lim_trees.tiff",units="in",width=4,height=4,res=300)
hist(Dim_lim_trees,breaks=seq(0,50,2.5),ylim=c(0,3000),main="",
     border=NA,col=rgb(0.2,0.2,0.8,0.25))
dev.off()


tiff("figures/Hist_dim_lim_sp.tiff",units="in",width=4,height=4,res=300)
hist(Dia_size_plot_endo$Dim_lim_sp,breaks=seq(0,60,2.5),ylim=c(0,80),main="",
     border=NA,col=rgb(0.2,0.2,0.8,0.25))
dev.off()

##...Birds vs. diaspore limiting size

Cons_bird_plant<-merge(x=Cons_obs,y=Birds,by.x="Bird_name",by.y="Name",all.x=T)

Dia_size<-rbind(Dia_size_plot_endo[,c(1:12,34)],Dia_size_cons)
Dia_size<-Dia_size[,c(2,13)]

Cons_bird_plant<-merge(x=Cons_bird_plant,y=Dia_size,by.x="Plant_name",by.y="Name",all.x=T)

Cons_bird_plant<-Cons_bird_plant[order(Cons_bird_plant$Order,
                                       Cons_bird_plant$Family,
                                       Cons_bird_plant$Bird_name,decreasing=T),]

Cons_bird_plant$Bird_name[Cons_bird_plant$Bird_name=="Zosterops xanthochroa"]<-"Zosterops spp."

Cons_bird_plant<-rbind(Cons_bird_plant[Cons_bird_plant$Bird_name!="Ducula goliath",],
                       Cons_bird_plant[Cons_bird_plant$Bird_name=="Ducula goliath",])


tiff("figures/Size_cons.tiff",units="in",width=5,height=6,res=300)
par(mar=c(4,14,2,2))
plot(0,0,xlim=c(0,60),ylim=c(0,10),type="n",axes=F,xlab="",ylab="")
axis(1,seq(0,60,10),seq(0,60,10))
axis(2,seq(1,10,1),unique(Cons_bird_plant$Bird_name),las=1,font=3)
x1<-max(Cons_bird_plant$Dim_lim_sp[Cons_bird_plant$Bird_name!="Ducula goliath" & Cons_bird_plant$Bird_name!="Zosterops spp."],na.rm=T)
x2<-33
x3<-max(Cons_bird_plant$Dim_lim_sp[Cons_bird_plant$Bird_name=="Ducula goliath"],na.rm=T)
y1<-0.5
y2<-11
polygon(x=c(x1,x1,x2,x2),
        y=c(y1,y2,y2,y1),
        border=NA,
        col=rgb(0.2,0.2,0.8,0.25))
polygon(x=c(x2,x2,x3,x3),
        y=c(y1,y2,y2,y1),
        border=NA,
        col=rgb(0.2,0.2,0.8,0.15))
abline(h=seq(1,10,1),lty=3,col="grey")
for (i in 1:length(unique(Cons_bird_plant$Bird_name))){
 order<-Cons_bird_plant$Order[Cons_bird_plant$Bird_name==unique(Cons_bird_plant$Bird_name)[i]][1]
 temp<-Cons_bird_plant$Dim_lim_sp[Cons_bird_plant$Bird_name==unique(Cons_bird_plant$Bird_name)[i]]
 if (order=="Passeriformes") points(temp,rep(i,length(temp)),pch=21,cex=2,col=NA,bg=rgb(0.8,0.2,0.2,0.5))
 if (order=="Psittaciformes") points(temp,rep(i,length(temp)),pch=21,cex=2,col=NA,bg=rgb(0.2,0.8,0.2,0.5))
 if (order=="Columbiformes") points(temp,rep(i,length(temp)),pch=21,cex=2,col=NA,bg=rgb(0.2,0.2,0.8,0.5))
}
for (i in 1:length(unique(Cons_bird_plant$Bird_name))){
  temp<-unique(Cons_bird_plant$Beak_width[Cons_bird_plant$Bird_name==unique(Cons_bird_plant$Bird_name)[i]])
  points(temp,i,pch=25,cex=2,col=NA,bg="orange")
}
abline(v=33,lty=3,lwd=2)
segments(x0=10.5,x1=10.5,y0=1.5,y1=2.5,lty=3,lwd=2,rgb(0.8,0.2,0.2,1))
dev.off()

tiff("figures/dens_plot_dg.tiff",units="in",width=3.5,height=2,res=300)
par(mar=c(2,2,2,2))
temp1<-Cons_bird_plant[Cons_bird_plant$Bird_name!="Ducula goliath",]
temp2<-temp1$Dim_lim_sp[-which(temp1$Bird_name=="Zosterops spp." & temp1$Dim_lim_sp>10.5)]
do<-density(temp2,cut=0,na.rm=T)
d<-density(Cons_bird_plant$Dim_lim_sp[Cons_bird_plant$Bird_name=="Ducula goliath"],cut=0,na.rm=T)
plot(d,main="",col=rgb(0.2,0.2,0.8,0.5),type="n",bty="n",xlim=c(0,60))
#polygon(x=c(0,do$x,max(do$x),0),
#        y=c(0,do$y,0,0),
#        col=rgb(0.2,0.2,0.2,0.5),border=NA)
polygon(x=c(0,d$x,max(d$x),0),
        y=c(0,d$y,0,0),
        col=rgb(0.2,0.2,0.8,0.5),border=NA)
abline(v=median(Cons_bird_plant$Dim_lim_sp[Cons_bird_plant$Bird_name=="Ducula goliath"],na.rm=T),
       col=rgb(0.2,0.2,0.8,1))
abline(v=quantile(Cons_bird_plant$Dim_lim_sp[Cons_bird_plant$Bird_name=="Ducula goliath"],na.rm=T,prob=0.95),
       col=rgb(0.2,0.2,0.8,1),lty=3)
abline(v=33,lty=3,lwd=2)
dev.off()

Max_DS<-aggregate(Cons_bird_plant$Dim_lim_sp,by=list(Cons_bird_plant$Bird_name),max,na.rm=TRUE)
colnames(Max_DS)<-c("Bird_name","Max_DS")

Max_DS<-merge(x=Max_DS,y=Birds,by.x="Bird_name",by.y="Name",all.x=T)


##...Frequency of species and trees only dispersed by Notou

#...Species

N_sp_endo<-dim(Dia_size_plot_endo)[1] # 377 species

LT<-16 #19
HT<-33

Smaller<-sum(Dia_size_plot_endo$Dim_lim_sp<=LT,na.rm=T)
Notou<-sum(Dia_size_plot_endo$Dim_lim_sp>LT & Dia_size_plot_endo$Dim_lim_sp<=HT,na.rm=T)
Larger<-sum(Dia_size_plot_endo$Dim_lim_sp>HT,na.rm=T)
Unknow<-sum(is.na(Dia_size_plot_endo$Dim_lim_sp))

N_sp_size<-c(Smaller,Notou,Larger,Unknow)
names(N_sp_size)<-c("Notou and other birds","Only Notou","No birds","Unknown size")

tiff("figures/N_sp_size.tiff",units="in",width=4,height=4,res=300)
pie(N_sp_size,labels=NA,
    col=c("white",rgb(0.2,0.2,0.8,0.25),"lightgrey","darkgrey"))
dev.off()

Perc_sp_size<-round((N_sp_size/N_sp_endo)*100,1)

#...Trees

N_trees_sp_endo<-N_trees_sp[Dia_size_plot$Syndrome=="endozoochory"]
N_trees_endo<-sum(N_trees_sp_endo,na.rm=T) # 15766 trees

Smaller<-sum(N_trees_sp_endo[Dia_size_plot_endo$Dim_lim_sp<=LT],na.rm=T)
Notou<-sum(N_trees_sp_endo[Dia_size_plot_endo$Dim_lim_sp>LT & Dia_size_plot_endo$Dim_lim_sp<=HT],na.rm=T)
Larger<-sum(N_trees_sp_endo[Dia_size_plot_endo$Dim_lim_sp>HT],na.rm=T)
Unknow<-sum(N_trees_sp_endo[which(is.na(Dia_size_plot_endo$Dim_lim_sp))],na.rm=T)

N_trees_size<-c(Smaller,Notou,Larger,Unknow)
names(N_trees_size)<-c("Notou and other birds","Only Notou","No birds","Unknown size")

tiff("figures/N_trees_size.tiff",units="in",width=4,height=4,res=300)
pie(N_trees_size,labels=NA)
dev.off()

Perc_trees_size<-round((N_trees_size/N_trees_endo)*100,1)

##...Frequency of species dispersed by Notou in most diverse plant families

N_sp_fam<-table(Dia_size_plot_endo$Family)
N_sp_fam_10<-N_sp_fam[N_sp_fam>=10]
N_sp_fam_10<-N_sp_fam_10[order(N_sp_fam_10)]

Smaller_fam<-numeric()
Notou_fam<-numeric()
Larger_fam<-numeric()
Unknow_fam<-numeric()

for (i in 1:length(N_sp_fam_10)){
  Smaller_fam[i]<-sum(Dia_size_plot_endo$Family==names(N_sp_fam_10)[i] & Dia_size_plot_endo$Dim_lim_sp<=LT,na.rm=T)
  Notou_fam[i]<-sum(Dia_size_plot_endo$Family==names(N_sp_fam_10)[i] & Dia_size_plot_endo$Dim_lim_sp>LT & Dia_size_plot_endo$Dim_lim_sp<=HT,na.rm=T)
  Larger_fam[i]<-sum(Dia_size_plot_endo$Family==names(N_sp_fam_10)[i] & Dia_size_plot_endo$Dim_lim_sp>HT,na.rm=T)
  Unknow_fam[i]<-sum(Dia_size_plot_endo$Family==names(N_sp_fam_10)[i] & is.na(Dia_size_plot_endo$Dim_lim_sp))
}

N_sp_size_fam<-cbind(Smaller_fam,Notou_fam,Larger_fam,Unknow_fam)
rownames(N_sp_size_fam)<-names(N_sp_fam_10)

tiff("figures/N_sp_size_fam.tiff",units="in",width=3.5,height=5,res=300)
par(mar=c(4,7,2,1))
barplot(t(N_sp_size_fam),horiz=T,xlim=c(0,40),las=1,
        col=c("white",rgb(0.2,0.2,0.8,0.25),"lightgrey","darkgrey"))
dev.off()

##...Birds

Nat_birds_pres<-Birds[which(Birds$Origin!="Introduced" & 
                              Birds$Status!="EX" & 
                              Birds$Status!="LEX"),]


foo<-Nat_birds_pres[,14:24]

Nat_birds_pres_traits<-Nat_birds_pres[,c(14,16,17,22,24)]
colnames(Nat_birds_pres_traits)[1]<-"Beak_length"
rownames(Nat_birds_pres_traits)<-Nat_birds_pres$Name

Birds_pca<-dudi.pca(Nat_birds_pres_traits,scannf=FALSE,nf=2)


tiff("figures/Birds_ACP.tiff",units="in",width=3.5,height=3.5,res=300)
par(mar=c(2,2,2,2))
plot(Birds_pca$l1,type="n",xlim=c(-3,3),ylim=c(-3,3),
     xlab="PC1 (64.9%)",ylab="PC2 (24.3%)")
abline(h=0,lty=3,col="lightgrey")
abline(v=0,lty=3,col="lightgrey")
Arrows(x0=0,y0=0,x1=Birds_pca$co[,1]*2,y1=Birds_pca$co[,2]*2,arr.type="triangle")
points(Birds_pca$l1[Nat_birds_pres$Order=="Passeriformes",],pch=23,col=NA,cex=2,
       bg=rgb(0.8,0.2,0.2,0.5))
points(Birds_pca$l1[Nat_birds_pres$Order=="Psittaciformes",],pch=23,col=NA,cex=2,
       bg=rgb(0.2,0.8,0.2,0.5))
points(Birds_pca$l1[Nat_birds_pres$Order=="Columbiformes",],pch=23,col=NA,cex=2,
       bg=rgb(0.2,0.2,0.8,0.5))
points(Birds_pca$l1[Nat_birds_pres$Name=="Ducula goliath",],pch=23,col="black",cex=2,
       bg=rgb(0.2,0.2,0.8,0))

text(Birds_pca$co[,1]*2.1,Birds_pca$co[,2]*2.1,
     c("BL","BW","BD","HWI","BM"),
     col="red",
     cex=0.8,
     pos=2)

legend("topright",bty="n",pch=23,cex=0.8,col=NA,
       pt.bg=c(rgb(0.2,0.2,0.8,0.5),
       rgb(0.8,0.2,0.2,0.5),
       rgb(0.2,0.8,0.2,0.5)),
       legend=c("Columbiformes","Passeriformes","Psittaciformes"))
dev.off()



tiff("figures/Hist_BL_birds.tiff",units="in",width=4,height=4,res=300)
hist(Nat_birds_pres_traits$Beak_width,breaks=seq(0,50,2.5),ylim=c(0,10),main="",
     border=NA,col=rgb(1,0.6470588,0,0.25))
dev.off()




tiff("figures/Hist_dl_bw_sp.tiff",units="in",width=4,height=4,res=300)
hist(rep(Nat_birds_pres_traits$Beak_width,8),breaks=seq(0,60,2.5),ylim=c(0,80),main="",
     border=NA,col=rgb(1,0.6470588,0,0.25))
hist(Dia_size_plot_endo$Dim_lim_sp,breaks=seq(0,60,2.5),
     border=NA,col=rgb(0.2,0.2,0.8,0.25),add=TRUE)
axis(4,seq(0,10,2)*8,seq(0,10,2))
abline(v=max(Nat_birds_pres_traits$Beak_width),lty=3,col=rgb(1,0.6470588,0,1))
dev.off()

