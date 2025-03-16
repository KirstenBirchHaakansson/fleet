

#Finding metiers used by the Danish fleet

options(scipen = 999)

library(haven)
library(dplyr)
library(lubridate)
library(beepr)

years <- c(2015:2024)

metiers <- c()


for (i in years) {
  dfad_0 <-
    readRDS(paste(
      "Q:/dfad/data/Data/udvidet_data/dfad_udvidet",
      i,
      ".rds",
      sep = ""
    ))
  dfad_0 <- mutate(dfad_0, year = year(ldato))
  
  metiers_0 <-
    summarise(
      group_by(
        dfad_0,
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
  
  metiers <- bind_rows(metiers, ungroup(metiers_0))
}

beep(sound = 8)

unique(metiers$fao_area)

metiers <- mutate(ungroup(metiers),
                  fao_area = ifelse(
                    dfadfvd_ret == "3D281",
                    "27.3.d.28.1",
                    ifelse(
                      dfadfvd_ret %in% c("3D28", "3D282", "3D28_"),
                      "27.3.d.28.2",
                      fao_area
                    )
                  ))

saveRDS(metiers, "Q:/mynd/SAS Library/fleet/data/metiers_exist.rds")
