

# Test new fleet relation against old fleet relation

path_old <- "Q:/50-radgivning/02-mynd/kibi/reference_tables/fleet/"
path_new <- "Q:/50-radgivning/02-mynd/SAS Library/fleet/"

new <- readRDS(paste0(path_new, "fleet_old_metiers.rds"))
old <- readRDS(paste0(path_old, "fleet.rds"))

names(new)
names(old)

new_1 <- subset(new, fdfmark != "FDF")
new_1$mixfish_fleet <- gsub("_all", "", new_1$mixfish_fleet)

new_2 <- distinct(new_1, fao_area, metier_level6_ret, mixfish_fleet)

old$metier_level6_ret <- old$metier_level6

old$mixfish_fleet_old <- old$mixfish_fleet

old_2 <- distinct(old, fao_area, metier_level6_ret, mixfish_fleet_old)

comb <- full_join(new_2, old_2)

comb <- subset(comb, mixfish_fleet != mixfish_fleet_old)
