
library(dplyr)

years <- c(2021:2024)
dfad <- c()

for (i in years) {
  
  dfad_0 <- readRDS(paste("Q:/dfad/data/Data/udvidet_data/dfad_udvidet", i, ".rds", sep = ""))
  names(dfad_0) <- tolower(names(dfad_0))
  dfad_0$hel[is.na(dfad_0$hel)] <- 0
  
  dfad_0 <- select(dfad_0, -aktiv, -passiv)
  
  dfad_3as <- subset(dfad_0, dfadfvd_ret == "3AS") 
  
  dfad <- bind_rows(dfad, dfad_3as)
  
}

rm(dfad_0, dfad_3as)

dfad$year <- lubridate::year(dfad$ldato)

tor <- subset(dfad, art ==  "TOR")



tor_sum <- summarise(group_by(tor, year, redskb, fdfmark), ton = sum(hel/1000, na.rm = T))

otb <- subset(dfad, redskb %in% c("OTB", "TBN", "OTT"))

otb_sum <- summarise(group_by(otb, year),
                     vrd = sum(vrd, na.rm = T),
                     ton = sum(hel/1000, na.rm = T),
                     no_vsl = length(unique(fid)))

otb_sum <- arrange(otb_sum, match_alle, -vrd)              

otb_vrd <- slice(group_by(otb_sum, match_alle), 1)

otb_vrd_sum <- summarise(group_by(otb_vrd, year, art), no_trips = length(unique(match_alle)))


otb_vrd_sum <- summarise(group_by(otb_vrd, art), no_trips = length(unique(match_alle)))
