library(rgdal)
library(rgeos)
library(RColorBrewer)
library(rasterVis)
library(ggplot2)
library(raster)
library(abind)
library(ncdf)
library(ncdf4) 
#le package ncdf4 donne beaucoup plus de détails sur les métadonnées et 
# fonctionne mieux avec le package raster que que le package ncdf

setwd("C:/Users/ghalouan/Desktop/dossier_calib/calib11bis3_01_09_2015/OsmoseEmibios2/RUN/i0/output")

#les palette de couleurs
pal2<-rev(brewer.pal(11, "Spectral"))
pal3<-c("white", "#5E4FA2", "#3288BD", "#66C2A5", "#ABDDA4",
        "#E6F598", "#FFFFBF", "#FEE08B", "#FDAE61", "#F46D43",
        "#D53E4F", "#9E0142")
pal4<-rev(brewer.pal(9, "YlGnBu"))

pal5<-c("white", "#FFFFD9", "#EDF8B1", "#C7E9B4", "#7FCDBB", "#41B6C4", "#1D91C0", 
        "#225EA8","#253494", "#081D58")
#colorRampPalette(brewer.pal(9,"Blues"))(100) #c'est pour construire 100 nuances de couleur à partir des 9 nuances de bleus de RColorBrewer

#une fonction pour extraire les nom de couleurs de RColorBrewer
#f <- function(pal) brewer.pal(brewer.pal.info[pal, "maxcolors"], pal)
#(cols <- f("YlGnBu"))
#fin fonction extratction des couleurs


#résultats avec le package ncdf4 (le package utilisé dans ce script)
nc2<-nc_open("gog_osm_spatialized_Simu0.nc")
nc2

species<-c("Octopus Vulgaris", "Melicertus Kerathurus", "Metapenaeus Monoceros",
           "Trachurus Trachurus", "Sardina Pilchardus", "Sardinella Aurita", 
           "Engraulis Encrasicolus", "Diplodus Annularis", "Mustelus Mustelus",
           "Merluccius Merluccius", "Pagellus Erythrinus")



# SOO_Function, une fonction pour plotter les sorties du .nc 

SOO_Function = function (x,y,z) {  
n=x #species number (n=osmose id+1)
var<-raster("gog_osm_spatialized_Simu0.nc", band=y, level=n, varname=z)

#extraction des coordonnées
lat<-ncvar_get(nc2, varid = "latitude")
lon<-ncvar_get(nc2, varid = "longitude")

#mise en forme de coordonnées (un tableau avec deux colonnes lon-lat)
latv<-as.vector(lat) #latitudes format vecteur
latv<-rev(latv)
lonv<-as.vector(lon) #longitudes format vecteur
lonv<-rev(lonv)
lonlatv<-cbind(lonv, latv)
#fin mise en forme

#début de construction d'un raster REGULIER

var[is.na(var[])] <- 0 # replacing NA's by zero

coordraster<-rasterToPoints(var) # la partie qui va varier
coordrasterlonlat<-abind(lonlatv, coordraster)
coordrasterlonlat<-coordrasterlonlat[,-c(3,4)]

s100<-coordrasterlonlat
s100<-as.matrix(s100)
colnames(s100) <- c('X', 'Y', 'Z')
rownames(s100) <- NULL


# set up an 'empty' raster, here via an extent object derived from your data
e <- extent(s100[,1:2])
e <- e + 0 # add this as all y's are the same
r <- raster(e, ncol=40, nrow=26) #cette option est aussi valable
# or r <- raster(xmn=, xmx=,  ...
#r<-raster( ncol=35, nrow=35, xmn=10, xmx=13, ymn=33, ymx=35.5)
# you need to provide a function 'fun' for when there are multiple points per cell
x <- rasterize(s100[,1:2], r, s100[,3], fun=mean)
#plot(x, colNA="white", zlim=c(0,13)) # image(x, col=pal2, zlim=c(0.5,13)) #zlim pour définir la limite des pixel à dessier
#fin de construction d'un raster REGULIER


tunisie<-"I:/Work/Thèse/Base de données/GIS/Cartes/Tunisia MAP/Tunisie/Carte Tunisie polygone/TUN_outline.shp" #layer: TUN_outline
PolyTn<- readOGR(dsn=tunisie, layer="TUN_outline")
names(PolyTn)
PolyTn_f <- fortify(PolyTn) #transforms data from shapefiles into a dataframe that ggplot can understand
# fin préparation des shapefiles


map<-gplot(x)+ geom_tile(aes(fill = value)) +
  #facet_wrap(~ variable) +
  ggtitle(species[n])+
  #scale_fill_gradient(low = 'white', high = 'navyblue') +
  xlab("")+
  ylab("")+
  theme_bw()+
  theme(panel.grid.major = element_line(colour = "white"),
        panel.grid.minor = element_line(colour = "white"))+
  scale_fill_gradientn(colours = pal5, name=z)+
  geom_polygon(data=PolyTn_f, aes(long,lat, group=group), fill="grey50") + #Good ajouter des polygone sur un raster
  coord_equal(xlim = c(9.5, 13.5),ylim = c(33, 35.5))  #Good ajouter des polygone sur un raster
#coord_equal()
map
return(map)
}

SOO_Function(6,500, "biomass")
#a<-SOO_Function(1,500)


#for (i in 1:11) {
#a<-SOO_Function(i,500)  
#print(a)  
#print(i)  
#}



