
# Informations ------------------------------------------------------------

### title: Density of life forms ###
### author: Yuri (yuri.eco2013@gmail.com)
### data: 29/10/2019
### Description: This script creates a data table containing the density of each life form by subplots and plots. It also create an errorbar graphic to density of each life form by time. 




# Load packages and set directory -------------------------------------

rm(list = ls())

if(!require("tidyverse")) install.packages("tidyverse", dependencies = TRUE)
if(!require("textclean")) install.packages("textclean", dependencies = TRUE)

path <- "C:/Users/Yuri/Google Drive/Yuri/Mestrado/parcelas_biota/projeto/PPG/tese/analises/01_dados/padrao"
setwd(path)




# load data table ----------------------------------------------------------

data_biota <- read_csv("life_form_yuri_2019v2.csv", locale = locale(encoding = "ASCII"))
glimpse(data_biota)

data_biota$Individual <- str_remove_all(data_biota$Individual, "[1234567890]")

data.biota.den <- data_biota %>%
  dplyr::select(-c(1,23:26,28)) %>%   # remove unused columns
  gather(key = "Month", value = "value", 5:21) %>% 
  rename(life_form = `Life Form`) %>% # convert the information from columns 4 to 20 in the columns "time" (month data) and column "value", that contains the record of each individual 
  mutate(time = Month %>% stringr::str_replace("p", "")) %>% 
  mutate(Individual = Individual %>% str_remove_all("[1234567890]")) %>% 
  textclean::drop_row("life_form", c("indeterminate")) %>%
  #dplyr::group_by(Site, Plot, Treatment, Individual, Month, life_form) %>% 
  #summarise(abundances = sum(value)) %>% 
  dplyr::group_by(Site, Plot, Treatment, Month, time, life_form) %>% 
  summarise(abundances = sum(value)/3^2)

data.biota.den




# A-Trees -------------------------------------------------------------------


arvores <- data.biota.den %>% 
  filter(life_form == "tree")
arvores


tree <- ggplot(arvores, aes(time, abundances, color = Treatment)) +
  scale_color_brewer(palette = "Dark2", name = "Treatment", labels = c("Closed", "Open")) + theme_classic() +
  #stat_summary(fun.data = mean_cl_boot,
  #             geom = "errorbar",
  #             width = 0.2,
  #             aes(group = Treatment),
  #             color = "black",
  #             fun.args = list(conf.int = .95, B = 2000)) +
  stat_summary(fun.data = mean_cl_boot,
               geom = "ribbon",
               aes(group = Treatment),
               color = "0.12",
               alpha = 0.12,
               fun.args = list(conf.int = .95, B = 2000)) +
  stat_summary(fun.y = mean,
               geom = "point",
               size = 3,
               aes(shape = Treatment),
               show.legend = FALSE) +
  stat_summary(fun.y = mean, 
               geom = "line",
               aes(group = Treatment),
               size = 1) +
  labs(x = "Sampled period (months)", y = "Trees density (m²)") +
  theme(axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        legend.position = c(0.15, .85),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14)) +
  #annotate("text", label = "2009", size = 2.5, x = 1, y = 2.29) +
  #annotate("text", label = "2010", size = 2.5, x = 3, y = 2.399) +
  #annotate("text", label = "2011", size = 2.5, x = 5, y = 2.4) +
  #annotate("text", label = "2012", size = 2.5, x = 7, y = 2.47) +
  #annotate("text", label = "2013", size = 2.5, x = 9, y = 2.435) +
  #annotate("text", label = "2014", size = 2.5, x = 11, y = 2.389) +
  #annotate("text", label = "2015", size = 2.5, x = 13, y = 2.477) +
  #annotate("text", label = "2016", size = 2.5, x = 15, y = 2.53) +
  #annotate("text", label = "2017", size = 2.5, x = 17, y = 2.49) +
  annotate("text", label = 'atop(bold("A"))', parse= TRUE, size = 7, x = 1, y = 2.4) +
  expand_limits(y=2.5)
#scale_x_discrete(labels = c("0","06","12","18","24","30","36","42","48","54","60","66","72","78","84","90","96"))
tree

ggsave("C:/Users/Yuri/Google Drive/Yuri/Mestrado/parcelas_biota/projeto/PPG/tese/analises/02_figuras/densidade/ribbon_line_trees_density_month.png", w = 20, h = 10, units = "cm", dpi = 300)





# B-Palms -------------------------------------------------------------------


palmeiras <- data.biota.den %>% 
  filter(`life_form` == "palm")
palmeiras

palm <- ggplot(palmeiras, aes(time, abundances, color = Treatment)) +
  scale_color_brewer(palette = "Dark2", name = "Treatment", labels = c("Closed", "Open")) + theme_classic() +
  stat_summary(fun.data = mean_cl_boot,
               geom = "ribbon",
               aes(group = Treatment),
               color = "0.12",
               alpha = 0.12,
               fun.args = list(conf.int = .95, B = 2000)) +
  stat_summary(fun.y = mean,
               geom = "point",
               size = 3,
               aes(shape = Treatment),
               show.legend = FALSE) +
  stat_summary(fun.y = mean, 
               geom = "line",
               aes(group = Treatment),
               size = 1) +
  theme(axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        legend.position = "none") +
  labs(x = "", y = "Palms density  (m²)") +
  annotate("text", label = 'atop(bold("B"))', parse= TRUE, size = 7, x = 17.3, y = 1.39) +
  #    annotate("text", label = "2009", size = 3, x = 1, y = 1.866) +
  #   annotate("text", label = "2010", size = 3, x = 3, y = 1.71) +
  #  annotate("text", label = "2011", size = 3, x = 5, y = 1.789) +
  # annotate("text", label = "2012", size = 3, x = 7, y = 1.97) +
  #     annotate("text", label = "2013", size = 3, x = 9, y = 1.68) +
  #    annotate("text", label = "2014", size = 3, x = 11, y = 1.71) +
  #   annotate("text", label = "2015", size = 3, x = 13, y = 1.81) +
  #  annotate("text", label = "2016", size = 3, x = 15, y = 1.71) +
  # annotate("text", label = "2017", size = 3, x = 17, y = 1.735) +
  #scale_x_discrete(labels = c("0","06","12","18","24","30","36","42","48","54","60","66","72","78","84","90","96")) +
  expand_limits(y=1.4)
palm

ggsave("C:/Users/Yuri/Google Drive/Yuri/Mestrado/parcelas_biota/projeto/PPG/tese/analises/02_figuras/densidade/ribbon_line_palm_density_month.png", w = 20, h = 10, units = "cm", dpi = 300)






# C-Lianas -------------------------------------------------------------------


lianas <- data.biota.den %>% 
  filter(`life_form` == "liana")
lianas

liana <- ggplot(lianas, aes(time, abundances, color = Treatment)) +
  scale_color_brewer(palette = "Dark2", name = "Treatment", labels = c("Closed", "Open")) + theme_classic() +
  stat_summary(fun.data = mean_cl_boot,
               geom = "ribbon",
               aes(group = Treatment),
               color = "0.12",
               alpha = 0.12,
               fun.args = list(conf.int = .95, B = 2000)) +
  stat_summary(fun.y = mean,
               geom = "point",
               size = 3,
               aes(shape = Treatment),
               show.legend = FALSE) +
  stat_summary(fun.y = mean, 
               geom = "line",
               aes(group = Treatment),
               size = 1) +
  theme(axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        legend.position = "none") +
  labs(x = "", y = "Lianas density  (m²)") +
  annotate("text", label = 'atop(bold("C"))', parse= TRUE, size = 7, x = 1, y = 1.14) +
  #    annotate("text", label = "2009", size = 3, x = 1, y = 1.866) +
  #   annotate("text", label = "2010", size = 3, x = 3, y = 1.71) +
  #  annotate("text", label = "2011", size = 3, x = 5, y = 1.789) +
  # annotate("text", label = "2012", size = 3, x = 7, y = 1.97) +
  #     annotate("text", label = "2013", size = 3, x = 9, y = 1.68) +
  #    annotate("text", label = "2014", size = 3, x = 11, y = 1.71) +
  #   annotate("text", label = "2015", size = 3, x = 13, y = 1.81) +
  #  annotate("text", label = "2016", size = 3, x = 15, y = 1.71) +
  # annotate("text", label = "2017", size = 3, x = 17, y = 1.735) +
  #scale_x_discrete(labels = c("0","06","12","18","24","30","36","42","48","54","60","66","72","78","84","90","96")) +
  expand_limits(y=1.2)
liana

ggsave("C:/Users/Yuri/Google Drive/Yuri/Mestrado/parcelas_biota/projeto/PPG/tese/analises/02_figuras/densidade/ribbon_line_lianas_density_month.png", w = 20, h = 10, units = "cm", dpi = 300)






# D-Shrubs -------------------------------------------------------------------

arbusto <- data.biota.den %>% 
  filter(`life_form` == "shrub")
arbusto

shrub <- ggplot(arbusto, aes(time, abundances, color = Treatment)) +
  scale_color_brewer(palette = "Dark2", name = "Treatment", labels = c("Closed", "Open")) + theme_classic() +
  stat_summary(fun.data = mean_cl_boot,
               geom = "ribbon",
               aes(group = Treatment),
               color = "0.12",
               alpha = 0.12,
               fun.args = list(conf.int = .95, B = 2000)) +
  stat_summary(fun.y = mean,
               geom = "point",
               size = 3,
               aes(shape = Treatment),
               show.legend = FALSE) +
  stat_summary(fun.y = mean, 
               geom = "line",
               aes(group = Treatment),
               size = 1) +
  theme(axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        legend.position = "none") +
  labs(x = "", y = "Shrubs density  (m²)") +
  annotate("text", label = 'atop(bold("D"))', parse= TRUE, size = 7, x = 17.3, y = 0.95) +
  #    annotate("text", label = "2009", size = 3, x = 1, y = 1.866) +
  #   annotate("text", label = "2010", size = 3, x = 3, y = 1.71) +
  #  annotate("text", label = "2011", size = 3, x = 5, y = 1.789) +
  # annotate("text", label = "2012", size = 3, x = 7, y = 1.97) +
  #     annotate("text", label = "2013", size = 3, x = 9, y = 1.68) +
  #    annotate("text", label = "2014", size = 3, x = 11, y = 1.71) +
  #   annotate("text", label = "2015", size = 3, x = 13, y = 1.81) +
  #  annotate("text", label = "2016", size = 3, x = 15, y = 1.71) +
  # annotate("text", label = "2017", size = 3, x = 17, y = 1.735) +
  #scale_x_discrete(labels = c("0","06","12","18","24","30","36","42","48","54","60","66","72","78","84","90","96")) +
  expand_limits(y=1)
shrub

ggsave("C:/Users/Yuri/Google Drive/Yuri/Mestrado/parcelas_biota/projeto/PPG/tese/analises/02_figuras/densidade/ribbon_line_shrubs_density_month.png", w = 20, h = 10, units = "cm", dpi = 300)





# E-Herbs -------------------------------------------------------------------

ervas <- data.biota.den %>% 
  filter(`life_form` == "herb")
ervas

herb <- ggplot(ervas, aes(time, abundances, color = Treatment)) +
  scale_color_brewer(palette = "Dark2", name = "Treatment", labels = c("Closed", "Open")) + theme_classic() +
  stat_summary(fun.data = mean_cl_boot,
               geom = "ribbon",
               aes(group = Treatment),
               color = "0.12",
               alpha = 0.12,
               fun.args = list(conf.int = .95, B = 2000)) +
  stat_summary(fun.y = mean,
               geom = "point",
               size = 3,
               aes(shape = Treatment),
               show.legend = FALSE) +
  stat_summary(fun.y = mean, 
               geom = "line",
               aes(group = Treatment),
               size = 1) +
  theme(axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        legend.position = "none") +
  labs(x = "", y = "Herbs density  (m²)") +
  annotate("text", label = 'atop(bold("E"))', parse= TRUE, size = 7, x = 1, y = 1.56) +
  #    annotate("text", label = "2009", size = 3, x = 1, y = 1.866) +
  #   annotate("text", label = "2010", size = 3, x = 3, y = 1.71) +
  #  annotate("text", label = "2011", size = 3, x = 5, y = 1.789) +
  # annotate("text", label = "2012", size = 3, x = 7, y = 1.97) +
  #     annotate("text", label = "2013", size = 3, x = 9, y = 1.68) +
  #    annotate("text", label = "2014", size = 3, x = 11, y = 1.71) +
  #   annotate("text", label = "2015", size = 3, x = 13, y = 1.81) +
  #  annotate("text", label = "2016", size = 3, x = 15, y = 1.71) +
  # annotate("text", label = "2017", size = 3, x = 17, y = 1.735) +
  #scale_x_discrete(labels = c("0","06","12","18","24","30","36","42","48","54","60","66","72","78","84","90","96")) +
  expand_limits(y=1.60)
herb

ggsave("C:/Users/Yuri/Google Drive/Yuri/Mestrado/parcelas_biota/projeto/PPG/tese/analises/02_figuras/densidade/ribbon_line_herb_density_month.png", w = 20, h = 10, units = "cm", dpi = 300)






# F-bamboos -------------------------------------------------------------------

bamboos <- data.biota.den %>% 
  filter(`life_form` == "bamboo")
bamboos

bamboo <- ggplot(bamboos, aes(time, abundances, color = Treatment)) +
  scale_color_brewer(palette = "Dark2", name = "Treatment", labels = c("Closed", "Open")) + theme_classic() +
  stat_summary(fun.data = mean_cl_boot,
               geom = "ribbon",
               aes(group = Treatment),
               color = "0.12",
               alpha = 0.12,
               fun.args = list(conf.int = .95, B = 2000)) +
  stat_summary(fun.y = mean,
               geom = "point",
               size = 3,
               aes(shape = Treatment),
               show.legend = FALSE) +
  stat_summary(fun.y = mean, 
               geom = "line",
               aes(group = Treatment),
               size = 1) +
  theme(axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        legend.position = "none") +
  labs(x = "", y = "Bamboos density  (m²)") +
  annotate("text", label = 'atop(bold("F"))', parse= TRUE, size = 7, x = 17.3, y = 0.76) +
  #    annotate("text", label = "2009", size = 3, x = 1, y = 1.866) +
  #   annotate("text", label = "2010", size = 3, x = 3, y = 1.71) +
  #  annotate("text", label = "2011", size = 3, x = 5, y = 1.789) +
  # annotate("text", label = "2012", size = 3, x = 7, y = 1.97) +
  #     annotate("text", label = "2013", size = 3, x = 9, y = 1.68) +
  #    annotate("text", label = "2014", size = 3, x = 11, y = 1.71) +
  #   annotate("text", label = "2015", size = 3, x = 13, y = 1.81) +
  #  annotate("text", label = "2016", size = 3, x = 15, y = 1.71) +
  # annotate("text", label = "2017", size = 3, x = 17, y = 1.735) +
  #scale_x_discrete(labels = c("0","06","12","18","24","30","36","42","48","54","60","66","72","78","84","90","96")) +
  expand_limits(y=0.8)
bamboo

ggsave("C:/Users/Yuri/Google Drive/Yuri/Mestrado/parcelas_biota/projeto/PPG/tese/analises/02_figuras/densidade/ribbon_line_bamboos_density_month.png", w = 20, h = 10, units = "cm", dpi = 300)




