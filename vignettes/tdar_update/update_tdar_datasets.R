# This is a script used to update the Mesa Verde and Salinas datasets
# to spread their modification columns over several columns.
# We will modify the Mesa Verde datasets first (they all have the same structure),
# then the Salinas data.

library(tdar)
library(magrittr)
library(tidyverse)

dir.create("./dataset_updates/data_derived",
           recursive = TRUE,
           showWarnings = FALSE)



tdar::tdar_login()

# Mesa Verde / CCAC
list("Albert Porter Pueblo" = 6151,
     "Castle Rock Pueblo" = 6152,
     "Sand Canyon Locality" = 6157,
     "Sand Canyon Pueblo" = 6153,
     "Shields Pueblo" = 6154,
     "Woods Canyon Pueblo" = 6156,
     "Yellow Jacket Pueblo" = 6126) %>%
  purrr::map(tdar::tdar_download_resource,
             out_dir = "./dataset_updates/data_raw",
             overwrite = FALSE) %>%
  magrittr::set_names(.,tools::file_path_sans_ext(.)) %>%
  purrr::map(readxl::read_excel,
             col_types = "text") %>%
  purrr::map(function(x){
    x %>%
      tidyr::unite(col = "Burning",
                   Modification1, Modification2, Modification3,
                   sep = " ",
                   remove = FALSE) %>%
      dplyr::mutate(Burning = Burning %>%
                      stringr::str_remove_all("NA") %>%
                      stringr::str_remove_all("[^BWL]"),
                    Burning = ifelse(Burning == "",NA,Burning),
                    Burning = ifelse(Burning %>%
                                       stringr::str_detect("[BW]"),
                                     Burning %>%
                                       stringr::str_remove_all("[^BW]") %>%
                                       stringr::str_sub(1,1),
                                     Burning)) %>%
      tidyr::unite(col = "Gnawing",
                   Modification1, Modification2, Modification3,
                   sep = " ",
                   remove = FALSE) %>%
      dplyr::mutate(Gnawing = Gnawing %>%
                      stringr::str_remove_all("NA") %>%
                      stringr::str_remove_all("[^CR]"),
                    Gnawing = ifelse(Gnawing == "",NA,Gnawing),
                    Gnawing = ifelse(Gnawing %>%
                                       stringr::str_detect("[CR]"),
                                     Gnawing %>%
                                       stringr::str_sub(1,1),
                                     Gnawing)) %>%
      tidyr::unite(col = "Butchering",
                   Modification1, Modification2, Modification3,
                   sep = " ",
                   remove = FALSE) %>%
      dplyr::mutate(Butchering = Butchering %>%
                      stringr::str_remove_all("NA") %>%
                      stringr::str_remove_all("[^K]"),
                    Butchering = ifelse(Butchering == "",NA,Butchering),
                    Butchering = ifelse(Butchering %>%
                                          stringr::str_detect("[K]"),
                                        Butchering %>%
                                          stringr::str_sub(1,1),
                                        Butchering))
  }) %>%
  purrr::iwalk(~ readr::write_csv(.x, stringr::str_c("./dataset_updates/data_derived/",basename(.y),".csv") %>%
                                    stringr::str_replace_all("may2011","march2018")
  ))

# Salinas
Salinas <- list("Gran Quivira" = 2414,
                "Pueblo Blanco" = 2419,
                "Pueblo Colorado" = 2455,
                "Quarai Pueblo" = 2472) %>%
  purrr::map(tdar::tdar_download_resource,
             out_dir = "./dataset_updates/data_raw",
             overwrite = FALSE) %>%
  magrittr::set_names(.,tools::file_path_sans_ext(.)) %>%
  purrr::map(readxl::read_excel,
             col_types = "text") %>%
  purrr::map(function(x){
    x %>%
      tidyr::unite(col = "Weathering",
                   dplyr::one_of(c("Mod","MOD","Modification")),
                   sep = " ",
                   remove = FALSE) %>%
      dplyr::mutate(Weathering = Weathering %>%
                      stringr::str_remove_all("NA") %>%
                      stringr::str_remove_all("[^6789]"),
                    Weathering = ifelse(Weathering == "",7,Weathering)) %>%
      tidyr::unite(col = "Gnawing",
                   dplyr::one_of(c("Mod","MOD","Modification")),
                   sep = " ",
                   remove = FALSE) %>%
      dplyr::mutate(Gnawing = Gnawing %>%
                      stringr::str_remove_all("NA") %>%
                      stringr::str_remove_all("[^235789]"),
                    Gnawing = ifelse(Gnawing == "",7,Gnawing))
  }) %>%
  purrr::iwalk(~ readr::write_csv(.x, stringr::str_c("./dataset_updates/data_derived/",basename(.y),"-march2018.csv")))

tdar::tdar_logout()


