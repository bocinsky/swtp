library(tidyverse)
library(magrittr)

swtp_20190212 <- readxl::read_excel("./paper/data/raw_data/tdar-integration-SWTP_20190212.xlsx") %>%
  dplyr::mutate(`count column` = as.numeric(`count column`)) %>%
  dplyr::group_by(`Dataset/Table Name`) %>%
  # dplyr::select_at(vars(starts_with("mapped"))) %>%
  dplyr::select_at(vars(-starts_with("type"),
                        -starts_with("sort"))) %>%
  dplyr::distinct()# %>%
  # magrittr::set_names(.,
  #                     names(.) %>%
  #                       stringr::str_remove("mapped-")
  # )

swtp_20190228 <- readxl::read_excel("./paper/data/raw_data/tdar-integration-SWTP_20190228.xlsx") %>%
  dplyr::mutate(`count column` = as.numeric(`count column`)) %>%
  dplyr::group_by(`Dataset/Table Name`) %>%
  # dplyr::select_at(vars(starts_with("mapped"))) %>%
  dplyr::select_at(vars(-starts_with("type"),
                        -starts_with("sort"))) %>%
  dplyr::distinct()# %>%
  # magrittr::set_names(.,
  #                     names(.) %>%
  #                       stringr::str_remove("mapped-")
  # )

swtp_20190212 %>%
  anti_join(swtp_20190228) %>%
  bind_rows(swtp_20190228 %>%
              anti_join(swtp_20190212)) %>%
  dplyr::arrange(`Dataset/Table Name`,
                 # DATE,
                 `Fauna Taxon - Southwest US(376382)`,
                 `Fauna Element(6029)`,
                 `Fauna Proximal-Distal/Portion(3035)`,
                 `Fauna Burning Intensity(3443)`,
                 `Fauna Butchering(3989)`,
                 `Fauna Completeness(376370)`,
                 `Fauna Gnawing(3033)`,
                 `Fauna Weathering(3032)`) %>%
  dplyr::left_join(swtp_20190212 %>%
                     dplyr::mutate(`Integration Date` = lubridate::as_date("20190212"))) %>%
  dplyr::mutate(`Integration Date` = lubridate::as_date(ifelse(is.na(`Integration Date`),
                              lubridate::as_date("20190228"),
                              `Integration Date`))) %>%
  dplyr::select(`Integration Date`, everything()) %T>%
  writexl::write_xlsx("~/Desktop/swtp_comparison.xlsx")



swtp_20190212 %>%
  bind_rows(swtp_20190228) %>%
  dplyr::anti_join(.,distinct(.))


dplyr::all_equal(swtp_20190212,
                         swtp_20190228)


str(test)

test <-
  readxl::read_excel("./paper/data/raw_data/tdar-integration-SWTP_20190212.xlsx") %>%
  dplyr::bind_rows(readxl::read_excel("./paper/data/raw_data/tdar-integration-SWTP_20190228.xlsx")) %>%
  dplyr::mutate(`count column` = as.numeric(`count column`)) %>%
  dplyr::group_by(`Dataset/Table Name`) %>%
  dplyr::select_at(vars(starts_with("mapped"))) %>%
  # dplyr::select_at(vars(-starts_with("type"),
  #                       -starts_with("sort"))) %>%
  dplyr::distinct() %>%
  magrittr::set_names(.,
                      names(.) %>%
                        stringr::str_remove("mapped-")
  ) %>%
  # dplyr::select(DATE, dplyr::everything()) %>%
  dplyr::arrange(`Dataset/Table Name`,
                 # DATE,
                 `Fauna Taxon - Southwest US(376382)`,
                 `Fauna Element(6029)`,
                 `Fauna Proximal-Distal/Portion(3035)`,
                 `Fauna Burning Intensity(3443)`,
                 `Fauna Butchering(3989)`,
                 `Fauna Completeness(376370)`,
                 `Fauna Gnawing(3033)`,
                 `Fauna Weathering(3032)`) %T>%
  writexl::write_xlsx("~/Desktop/swtp_test.xlsx")

