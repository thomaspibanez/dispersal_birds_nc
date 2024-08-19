##########################
##......................##
##...Data preparation...##
##......................##
##########################

##...Libraries
library("stringr")

##...Data
FS_plot<-read.csv("data_raw/Fruits_size_plot_NC.csv")
FS_cons<-read.csv("data_raw/Fruits_size_cons_NC.csv")
NC_PIPPN<-read.csv("data_raw/NC_PIPPN_2022_02_01_1HA.csv")
Birds<-read.csv("data_raw/Birds_NC.csv")
Cons_obs<-read.csv("data_raw/Cons_obs_NC.csv")

##...Remove useless fields in FS_plot

FS_plot<-FS_plot[,c("Family","Name_in_data_base","Statut","Diaspore","Syndrome",
                    "Fruit_d1_min","Fruit_d1_max",
                    "Fruit_d2_min","Fruit_d2_max",
                    "Fruit_d3_min","Fruit_d3_max",
                    "Fruit_dim_unit",
                    "Seed_d1_min","Seed_d1_max",
                    "Seed_d2_min","Seed_d2_max",
                    "Seed_d3_min","Seed_d3_max",
                    "Seed_dim_unit")]

colnames(FS_plot)[2]<-"Name"
colnames(FS_plot)[3]<-"Status"

FS_plot[FS_plot$Diaspore=="seed",6:12]<-FS_plot[FS_plot$Diaspore=="seed",13:19]
FS_plot<-FS_plot[,-c(13:19)]

colnames(FS_plot)[6:12]<-c("Dia_d1_min","Dia_d1_max",
                           "Dia_d2_min","Dia_d2_max",
                           "Dia_d3_min","Dia_d3_max",
                           "Dia_dim_unit")

FS_plot$Diaspore[FS_plot$Diaspore=="fruit "]<-"fruit"

FS_plot[FS_plot$Dia_dim_unit=="cm",6:11]<-FS_plot[FS_plot$Dia_dim_unit=="cm",6:11]*10

FS_plot<-FS_plot[,-12]

##...Remove useless fields in FS_cons

FS_cons<-FS_cons[,c("Family","Name","Status","Diaspore","Syndrome",
                    "Fruit_d1_min","Fruit_d1_max",
                    "Fruit_d2_min","Fruit_d2_max",
                    "Fruit_d3_min","Fruit_d3_max",
                    "Fruit_dim_unit",
                    "Seed_d1_min","Seed_d1_max",
                    "Seed_d2_min","Seed_d2_max",
                    "Seed_d3_min","Seed_d3_max",
                    "Seed_dim_unit")]

FS_cons[FS_cons$Diaspore=="seed",6:12]<-FS_cons[FS_cons$Diaspore=="seed",13:19]
FS_cons<-FS_cons[,-c(13:19)]

colnames(FS_cons)[6:12]<-c("Dia_d1_min","Dia_d1_max",
                           "Dia_d2_min","Dia_d2_max",
                           "Dia_d3_min","Dia_d3_max",
                           "Dia_dim_unit")

FS_cons[FS_cons$Dia_dim_unit=="cm",6:11]<-FS_cons[FS_cons$Dia_dim_unit=="cm",6:11]*10

FS_cons<-FS_cons[,-12]

write.csv(FS_cons,"data/Dia_Size_cons.csv")

##...NC_PIPPN locality table

Plot_loc<-unique(NC_PIPPN[,c(1:3)])
write.csv(Plot_loc,"data/Plot_loc.csv")

##...Number of trees per species per plot

NC_PIPPN<-NC_PIPPN[NC_PIPPN$DBH>=10,] # remove trees < 10 cm DBH

temp<-str_split(NC_PIPPN$Name, " ")
temp1<-character()

for (i in 1:length(temp)){
  if (length(temp[[i]])==1) temp1[i]<-temp[[i]][1]
  if (length(temp[[i]])>=2) temp1[i]<-paste(temp[[i]][1],temp[[i]][2],sep=" ")
}

NC_PIPPN$Name<-temp1

Sp_tab<-as.data.frame(matrix(nrow=length(unique(NC_PIPPN$Name)),
               ncol=length(unique(NC_PIPPN$Locality))+1))

colnames(Sp_tab)<-c("Name",unique(NC_PIPPN$Locality))
Sp_tab[,1]<-unique(NC_PIPPN$Name)

for (i in 1:dim(Sp_tab)[1]){
  for (j in 2:dim(Sp_tab)[2]){
    Sp_tab[i,j]<-length(NC_PIPPN$Name[NC_PIPPN$Name==Sp_tab$Name[i] &
                                      NC_PIPPN$Locality==colnames(Sp_tab)[j]])
  }
}

Sp_tab$Name[Sp_tab$Name=="Dysoxylum bijugum"]<-"Didymocheton bijugum"
Sp_tab$Name[Sp_tab$Name=="Dysoxylum canalense"]<-"Didymocheton canalense"
Sp_tab$Name[Sp_tab$Name=="Dysoxylum kouiriense"]<-"Didymocheton kouiriense"           
Sp_tab$Name[Sp_tab$Name=="Dysoxylum macranthum"]<-"Didymocheton macranthum"
Sp_tab$Name[Sp_tab$Name=="Dysoxylum macrostachyum"]<-"Didymocheton macrostachyum"
Sp_tab$Name[Sp_tab$Name=="Dysoxylum minutiflorum"]<-"Didymocheton minutiflorum"         
Sp_tab$Name[Sp_tab$Name=="Dysoxylum pachypodum"]<-"Didymocheton pachypodum"
Sp_tab$Name[Sp_tab$Name=="Dysoxylum roseum"]<-"Didymocheton roseus"
Sp_tab$Name[Sp_tab$Name=="Dysoxylum rufescens"]<-"Didymocheton rufescens"

Sp_tab$Name[Sp_tab$Name=="Meryta {pedunculata}"]<-"Meryta pedunculata"

FS_plot$Name[FS_plot$Name=="Metrosideros operculata     "]<-"Metrosideros operculata"
FS_plot$Name[FS_plot$Name=="Sloanea lepisda"]<-"Sloanea lepida"

FS_plot<-merge(x=FS_plot,y=Sp_tab,by.x="Name",by.y="Name",all.x=T)

FS_plot$Name[apply(FS_plot[,11:32],1,sum,na.rm=T)==0]

write.csv(FS_plot,"data/Dia_Size_plot.csv")


##...Change column names in Birds_NC

colnames(Birds)[1]<-"Name"
colnames(Birds)[23]<-"Body_mass"
write.csv(Birds,"data/Birds.csv")

##...Remove useless fields and rows in Cons_obs_nc

Cons_obs<-unique(Cons_obs[,c(1,2)])
Cons_obs<-Cons_obs[Cons_obs$Plant_name!="",]
write.csv(Cons_obs,"data/Cons_obs.csv")




