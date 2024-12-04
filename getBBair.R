library(jsonlite)
library(dplyr)
library(httr)
library(DBI)
library(RMariaDB)

# connect til db
con <- dbConnect(MariaDB(),
                 db="bboxair",
                 user="root",
                 password=Sys.getenv("pwdbair")
                 )

#hente fly fra bbox
#11.730979,55.365030,13.565696,55.966080
getUrl <- function(lamin,lomin,lamax,lomax) {
  bboxurl=sprintf('https://opensky-network.org/api/states/all?lamin=%f&lomin=%f&lamax=%f&lomax=%f',lamin,lomin,lamax,lomax)
  return(bboxurl)
}
newurl=getUrl(55.365030,11.730979,55.966080,13.565696)
newurl

resraw=GET(url=newurl,authenticate(user = "thorwulf",password=Sys.getenv("pwos")))
resraw$status_code
rescontent=content(resraw, as="text")
reslist=fromJSON(rescontent)
resdf=as.data.frame(reslist$states)
cn=c("icao24","callsign","origin_country","time_position","last_contact","longitude","latitude","baro_altitude","on_ground","velocity", "true_track","vertical_rate","sensors","geo_altitude","squawk", "spi", "category" )
colnames(resdf)=cn

