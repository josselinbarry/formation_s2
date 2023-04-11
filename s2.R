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

## sélection de champs ----

oison_taxon %>%
dplyr::select(nom_vernaculaire, nom_scientifique, date, nom)

## sélection de tous les champs sans certains

oison_taxon %>%
  dplyr::select(!(c(nom_vernaculaire, nom_scientifique, date, nom)))

# export des données ----

save(table, file = x.Rdata)
write.table()
write.csv()
openxlsx::write.xlsx()
sf::write_sf()