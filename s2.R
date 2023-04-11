rm(list = ls())
rm(taxon)

# installation des packages

install.packages("tidyverse")
install.packages("readr")
install.packages("sf")
library(tidyverse)
library(readr)
library(sf)

# lecture des données ----

oison_taxon <- data.table::fread(file = "oison/oison_taxon.csv")
taxon_ref <- data.table::fread(file = "oison/referentiel_taxons_INPN_oison.csv")
oison_geom <- sf::read_sf(dsn = "oison/oison_geometry.gpkg")

# mise en forme des données ----

## traitements de champs ----

oison_taxon %>%
dplyr::select(nom_vernaculaire, nom_scientifique, date, nom)

### sélection de tous les champs sans certains

oison_taxon %>%
  dplyr::select(!(c(nom_vernaculaire, nom_scientifique, date, nom)))

### sélection des champs selon leur début/fin (<> ^/debut, $/fin)

oison_taxon %>%
  dplyr::select(starts_with("nom"))

oison_taxon %>%
  dplyr::select(ends_with("id"))

### sélection des champs selon la présence d'une valeur (ou d'une autre)

oison_taxon %>%
  dplyr::select(contains("barrage") | contains("Barrage"))

### réorganiser les champs (commencer par ceux démarrant pr id puis les autres champs)

oison_taxon %>%
  dplyr::select(start_with("id"), everything())

### créer de nouveaux champs

test2 <- oison_taxon %>% 
  dplyr::select(observation_id, nom:email) %>% 
  mutate(nom_complet_observateur = paste(nom, prenom, sep = '_'),
         addition = 1 + 10,
         racine_carree = sqrt(observation_id))

## traitement observations

### selection d'observation

oison_taxon %>% 
  dplyr::filter(nom_scientifique == 'Canis lupus') %>% 
  dplyr::select(observtion_id:nom_vernaculaire)

### selection d'observation bis

oison_taxon %>% 
  dplyr::filter(email %in% c('camille.riviere@ofb.gouv.fr', 'didier.pujot@ofb.gouv.fr')) %>% 
  dplyr::select(observation_id::presence)

test <- oison_taxon %>% 
  dplyr::filter(presence == 'Absent' & !is.na(nombre_individu))

# export des données ----

save(table, file = x.Rdata)
write.table()
write.csv()
openxlsx::write.xlsx()
sf::write_sf()