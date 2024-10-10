

#Finding metiers used by the Danish fleet

options(scipen = 999)

library(haven)
library(dplyr)
library(lubridate)
library(beepr)

years <- c(1987:2024)

dfad <- c()


for (i in years) {
  
  dfad_0 <-
    readRDS(paste(
      "Q:/dfad/data/Data/udvidet_data/dfad_udvidet",
      i,
      ".rds",
      sep = ""
    ))
  
  dfad_0 <- mutate(dfad_0, year = year(ldato))
  
  dfad_7d <- subset(dfad_0, dfadfvd_ret == "7D")
  
  dfad_sub <- subset(dfad_0, match_alle %in% dfad_7d$match_alle)
  
  dfad_sum <-
    summarise(
      group_by(
        dfad_sub,
        fid,
        match,
        match_alle,
        haul_id,
        year,
        dfadfvd_ret,
        fao_area,
        redskb,
        maske,
        species_group,
        metier_level6,
        metier_level6_ret,
        metier_ret_mrk,
        merged_metier_level6,
        metier_level_6_new,
        metier_level_6_new_mrk,
        fdfmark,
        art,
        ltilst,
        anvend
      ),
      kg = sum(hel, na.rm = T),
      trips = length(unique(match_alle))
    )
  
  dfad <- bind_rows(dfad, dfad_sum)
}

beep(sound = 8)

saveRDS(ungroup(dfad), "Q:/mynd/SAS Library/fleet/analyses/area_7d/data_area_7d.rds")
