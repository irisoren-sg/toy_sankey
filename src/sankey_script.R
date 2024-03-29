library(readxl)
library(tidyverse)
library(networkD3)


dat_filename <- "./data/toy_data.xlsx"
font_size <- 12

dat <- read_excel(dat_filename)

# assign zero-indexed ids to nodes
nodes <- tibble(node = unique(c(dat$Source,
                                      dat$Target))
                      ) %>% 
  mutate(id = row_number() -1 )


# replace node names with id
dat <- dat %>% 
  left_join(nodes %>% 
              rename(Source = node, 
                     source_id = id), 
            by = "Source") %>% 
  left_join(nodes %>% 
              rename(Target = node, 
                     target_id = id), 
            by = "Target") %>% 
  mutate(Stream = as.factor(Stream))



colours_to_use <- 'd3.scaleOrdinal() .domain(["UK production emissions attributable to Scottish final consumption", ""Emissions embedded in imports direct to final demand", "my_unique_group"]) .range(["#69b3a2", "steelblue", "grey"])'
                      
sn <- networkD3::sankeyNetwork(Links = dat, 
                         Nodes = nodes, 
                         Source = "source_id", 
                         Target = "target_id", 
                         Value = "Value",
                         NodeID = "node", 
                         LinkGroup = "Stream", 
                         fontSize = font_size,
                         #colourScale = colours_to_use
                         )

sn


# I was unable to save the html as an image using the command line on SCOTS
# https://stackoverflow.com/questions/65158327/how-can-i-save-a-networkd3sankeynetwork-into-a-static-image-automatically-vi
# 
# However, you can save it using the Export button in the viewer
# 
