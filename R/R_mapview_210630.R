## Load packages
library(magrittr)
library(mapview)
library(NipponMap)
library(rvest)
library(sf)
library(sp)
library(stringr)
library(tidyverse)
prj = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"



## Saitei chingin
master_page = read_html("http://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/roudoukijun/minimumichiran/")
m_table = master_page  %>%
  html_table(header = TRUE)   %>%
  extract2(1)
m_table[48,] = NA
m_table = na.omit(m_table)
names(m_table) = c("prefecture", "salary", "salary2", "when")
m_table = m_table   %>%
  tbl_df  %>%
  select(1:2) %>%
  mutate(prefecture = str_replace_all(prefecture, "[[:space:]]", "")) ## remove all spaces
## --------------------------------------------------
## Expected life
life_page = read_html("http://www.mhlw.go.jp/toukei/saikin/hw/life/tdfk05/02.html")
life_table = life_page  %>%
  html_table(fill = TRUE, header = TRUE)  %>%
  extract2(1) %>%
  unique
names(life_table) = c("rank_male", "prefecture_male", "life_male", "rank_female", "prefecture_female", "life_female")
life_table[1:3,] = NA
life_table = life_table %>%
  na.omit()   %>%
  tbl_df  %>%
  mutate_at(
    vars(contains("prefecture")),
    funs(str_replace_all(., "[[:space:]]", ""))
  )
male_life = life_table  %>% select(1:3)
female_life = life_table  %>% select(4:6)
## --------------------------------------------------
## Combine the tables
tbl_cmbd = m_table  %>%
  left_join(
    male_life,
    by = c("prefecture" = "prefecture_male")
  )   %>%
  left_join(
    female_life,
    by = c("prefecture" = "prefecture_female")
  )
tbl_cmbd

## Japan shapefile
jpn_poly = st_read(system.file("shapes/jpn.shp", package = "NipponMap")[1])


st_crs(jpn_poly) = prj

## Combine
jpn_poly = jpn_poly %>%
  bind_cols(tbl_cmbd) %>%
  select(-prefecture)

## Map it!
mapview(jpn_poly)
