#####################################################################################
#                                 Data Wrangling                                    #
#                                   2018.08.14                                      #
#                   Instructor : Sungkyu Jung, TA : Boyoung Kim                     #
#                                                                                   #
#####################################################################################



#--- 1. “Most common women’s name

# make_babynames_dist() function in the mdsr package
library(Hmisc)
library(mdsr)
library(babynames)
BabynamesDist <- make_babynames_dist()
head(BabynamesDist, 2)


com_fem <- BabynamesDist %>%
  filter(sex == "F") %>%
  group_by(name) %>%
  mutate(est_num_alive = sum(est_alive_today)) %>%
  filter(est_num_alive != 0) %>%
  summarise(
    N = n(), est_num_alive = sum(est_alive_today),
    q1_age = wtd.quantile(age_today, est_alive_today, probs = 0.25),
    median_age = wtd.quantile(age_today, est_alive_today, probs = 0.5),
    q3_age = wtd.quantile(age_today, est_alive_today, probs = 0.75)) %>%
  arrange(desc(est_num_alive)) %>%
  head(25)




# binding the data, defining the x and y aesthetics, title, labels
w_plot <- ggplot(data = com_fem, aes(x = reorder(name, -median_age),  y = median_age)) + 
  xlab(NULL) + 
  ylab("Age (in years)") +
  ggtitle("Median ages for females with the 25 most common names")

# gold rectangles, points, flip
w_plot + 
  geom_linerange(
    aes(ymin = q1_age, ymax = q3_age),
    color = "#f3d478", 
    size = 5, 
    alpha = 0.7
  ) + 
  geom_point(fill = "#ed3324", colour = "white", size = 4, shape = 21) +
  coord_flip()



#--- 2.Summarizing groups

# babynames dataset
library(dplyr)
library(babynames)
head(babynames, 2)

# scan the data
babynames %>%
  filter(name == "Jackie")

#group_by function
babynames %>%
  filter(name == "Jackie") %>%
  group_by(year)

#summarise function
babynames %>%
  filter(name == "Jackie") %>%
  group_by(year) %>%
  summarise(
    N = n(), 
    total = sum(n), 
    boys = sum(ifelse(sex == "M", n,0))
  ) 

# Exercise
babynames %>%
  filter(name == "Jackie") %>%
  group_by(year) %>%
  summarise(
    N = n(), 
    total = sum(n), 
    boys = sum(ifelse(sex == "M", n, 0))
  )%>%
  mutate(pp = abs(0.5-boys/total)) %>% arrange(pp) %>%
  head(10)
