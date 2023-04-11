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

### sélection de tous les champs sans certains ----

oison_taxon %>%
  dplyr::select(!(c(nom_vernaculaire, nom_scientifique, date, nom)))

### sélection des champs selon leur début/fin (<> ^/debut, $/fin) ----

oison_taxon %>%
  dplyr::select(starts_with("nom"))

oison_taxon %>%
  dplyr::select(ends_with("id"))

### sélection des champs selon la présence d'une valeur (ou d'une autre) ----

oison_taxon %>%
  dplyr::select(contains("barrage") | contains("Barrage"))

### réorganiser les champs (commencer par ceux démarrant pr id puis les autres champs) ----

oison_taxon %>%
  dplyr::select(start_with("id"), everything())

### renommer un champ ----

oison_taxon %>% 
  dplyr::select(observation_id, nom_vernaculaire) %>% 
  rename(nom_commun = nom_vernaculaire) %>% 
  head()

### basculer minuscule/majuscule ----

rename_with(toupper) | rename_with(tilower)

### créer de nouveaux champs ----

test2 <- oison_taxon %>% 
  dplyr::select(observation_id, nom:email) %>% 
  mutate(nom_complet_observateur = paste(nom, prenom, sep = '_'),
         addition = 1 + 10,
         racine_carree = sqrt(observation_id))

### opération sur colonnes multiples : across (fin de vie)

penguins %>% 
  group_by(species) %>% 
  summarise(across(ends_with("mm"), mean, na.rm = TRUE)) %>% 
  head()

## traitement observations ----

### selection d'observation ----

oison_taxon %>% 
  dplyr::filter(nom_scientifique == 'Canis lupus') %>% 
  dplyr::select(observtion_id:nom_vernaculaire)

### selection d'observation bis ----

oison_taxon %>% 
  dplyr::filter(email %in% c('camille.riviere@ofb.gouv.fr', 'didier.pujot@ofb.gouv.fr')) %>% 
  dplyr::select(observation_id::presence)

test <- oison_taxon %>% 
  dplyr::filter(presence == 'Absent' & !is.na(nombre_individu))

### un résumé statistique ----

test3 <- oison_taxon %>% 
  dplyr::select(nom_scientifique, nombre_individu) %>% 
  dplyr::filter(nom_scientifique == 'Bufo bufo' | nom_scientifique == 'Elona quimperiana') %>% 
  group_by(nom_scientifique) %>% 
  summarise(nb_total_oison = sum(nombre_individu, na.rm = T),
            nb_max_oison = max(nombre_individu, na.rm = T))

### trier un tableur ----

test4 <- oison_taxon %>%
  mutate(nom_complet_observateur = paste(nom, prenom)) %>%
  dplyr::select(observation_id,
                date,
                nom_vernaculaire,
                nom_complet_observateur) %>%
  mutate(date = as.Date(date)) %>%
  arrange(date)

### extraire des valeurs (pull) ----

corine_chouette <- oison_taxon %>% 
  dplyr::select(observation_id, date, nom_vernaculaire, corine_label) %>% 
  filter(nom_vernaculaire == 'Chouette hulotte') %>% 
  pull(corine_label) %>% 
  unique()

  corine_chouette %>% 
    .[!is.na(corine_chouette)]

### unique duplicate ? ----
  
corine_chouette[duplicated(corine_chouette)] %>% 
unique()

### compter

set.seed(89)
  
taxon_alea <- oison_taxon %>% 
  pull(nom_vernaculaire) %>% 
  unique() %>% 
  sample(5)

test5 <- oison_taxon %>% 
  select(starts_with('nom_')) %>% 
  filter(nom_vernaculaire %in% taxon_alea) %>% 
  group_by(nom_vernaculaire) %>% 
  count()

especes_communes <- oison_taxon %>% 
  select(starts_with('nom_')) %>% 
  group_by(nom_vernaculaire) %>% 
  count() %>% 
  filter(n>100) %>% 
  arrange(desc(n))

### conditionnalité

refonte_nom_verna <- oison_taxon %>% 
  select(starts_with('nom_')) %>% 
  filter(nom_vernaculaire == 'Linotte mélodieuse') %>% 
  distinct() %>% 
  mutate(nom_vernaculaire2 = case_when(nom_scientifique == 'Carduelis cannabina'~'Linaria cannabina',
                                       TRUE ~ nom_scientifique))
### conditionnalité bis

incoherence_nb_ind <- oison_taxon %>% 
  dplyr::filter(presence == 'Absent' & !is.na(nombre_individu)) %>% 
  select(observation_id, date, nom_scientifique, presence, nombre_individu) %>% 
  filter(nombre_individu > 0) %>% 
  mutate(nb_ind_new = if_else(nom_scientifique == 'Faxonius limosus' & presence == 'Absent',
                              "zero", 
                              "à changer + tard"))

# export des données ----

save(table, file = x.Rdata)
write.table()
write.csv()
openxlsx::write.xlsx()
sf::write_sf()