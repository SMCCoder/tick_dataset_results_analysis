# Oct 29
# Running t-test on tick_dataset_results.xlsx file with response variables (density, count) on
# y-axis and methods/life stage/etc as x-axis to determine probability of difference between methods

# Oct 30
# Running more t-tests and further analyzing the data

#-------------------------------------------
# load libraries

library("ggplot2")
library("dplyr")
library(wesanderson)
library(RColorBrewer)
library(MuMIn)
library(car)
library(nlme)  
library(ncf)
library(lme4)
library(Matrix)
library(coefplot)
library(MASS)

#-------------------------------------------

tick_dataset_results <- readxl::read_xlsx("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/tick_dataset_results_10292019.xlsx", sheet = 1)

# subset data between two different methods - dragging and found on a person
dragging <- tick_dataset_results[tick_dataset_results$sampling_technique == "dragging",]
found_on_people <- tick_dataset_results[tick_dataset_results$sampling_technique == "found on a person",]
# subset deer tick life stages
adult <- tick_dataset_results[tick_dataset_results$life_stage == "adult",]
nymph <- tick_dataset_results[tick_dataset_results$life_stage == "nymph",]
larvae <- tick_dataset_results[tick_dataset_results$life_stage == "larvae",]

t.test(adult$stability_time, nymph$stability_time)
#t = 0.5784, df = 82.59, p-value = 0.5646
# t-value indicates probability between 0.5 and 0.75
# low probability of difference between datasets
#
# p-value greater than 0.05, accept null hypothesis
# statistically insignificant

t.test(adult$stability_time, larvae$stability_time)
#t = -5.1721, df = 12.859, p-value = 0.000186
# t-value indicates probability below 0.5
# very low probability of difference between datasets
#
# p-value less than 0.05, reject null hypothesis
# therefore alternative hypothesis: true difference in means is not equal to 0 is supported
# statiscally significant

t.test(nymph$stability_time, larvae$stability_time)
# t = -5.755, df = 11.406, p-value = 0.0001107
# t-value indicates probability below 0.5
# very low probability of difference between datasets
#
# p-value less than 0.05, reject null hypothesis
# therefore alternative hypothesis: true difference in means is not equal to 0 is supported
# statiscally significant


# create barplot for years to reach stability for each range of years
years_to_reach_stability <- ggplot(tick_dataset_results, aes(x = stability_time)) +
  geom_bar() +
  scale_y_continuous(name = "# of datasets", expand = c(0,0)) +
  xlab("Years to reach stability") + 
  xlim(low=0, high=14)+
  ggtitle("Years to reach stability for all datasets") +
  theme(axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.line.y = element_line(size = 0.5, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

years_to_reach_stability

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/years_to_reach_stability ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
years_to_reach_stability
dev.off()


# run t-test between two different datasets: dragging and found_on_people, for stability time
# assumes that the variances of y1 and y2 are unequal
t.test(dragging$stability_time, found_on_people$stability_time)
# t = 4.1311, df = 128.88, p-value = 6.451e-05
# t-value indicates probability above 0.9995
# very high probability of difference between datasets
#
# p-value less than 0.05, reject null hypothesis
# therefore alternative hypothesis: true difference in means is not equal to 0 is supported

# create boxplot for years to reach stability between different sampling methods
tick_dataset_results_drag_found <- subset(tick_dataset_results, sampling_technique == "dragging" | sampling_technique == "found on a person")
yrs_stab_by_samp_tech <- ggplot(tick_dataset_results_drag_found, aes(x = sampling_technique, y = stability_time)) +
  geom_boxplot() + 
  scale_x_discrete(name = "Sampling Technique") +
  scale_y_continuous(name = "Time to reach stability (years)") +
  ggtitle("Years to reach stability for each sampling technique") + 
  theme(axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.line.y = element_line(size = 0.5, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

yrs_stab_by_samp_tech

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/yrs_stab_by_samp_tech ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
yrs_stab_by_samp_tech
dev.off()


# run t-test between two different datasets: dragging and found_on_people, for proportion right
# assumes that the variances of y1 and y2 are unequal
t.test(dragging$proportion_right, found_on_people$proportion_right)
#t = -1.9102, df = 102.04, p-value = 0.05892
# t-value indicates probability below 0.5
# low probability of difference between datasets
#
# p-value above 0.05, supports null hypothesis
# therefore true difference in means is equal to 0 is supported
# and not statiscally significant

# create boxplot for proportion significant between different sampling methods
tick_dataset_results_drag_found <- subset(tick_dataset_results, sampling_technique == "dragging" | sampling_technique == "found on a person")
proportion_sig_by_samp_tech <- ggplot(tick_dataset_results_drag_found, aes(x = sampling_technique, y = proportion_significant)) +
  geom_boxplot() + 
  scale_x_discrete(name = "Sampling Technique") +
  scale_y_continuous(name = "Proportion Significantly Right") +
  ggtitle("Proportion significantly right for \neach sampling technique") + 
  theme(axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.line.y = element_line(size = 0.5, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

proportion_sig_by_samp_tech

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/proportion_sig_by_samp_tech ",Sys.Date(),".png", sep = ''), width = 600, height = 454)
proportion_sig_by_samp_tech
dev.off()


# create dataframe with average number of phase changes by each data range
ave_phase_changes_by_start_year <- tick_dataset_results %>% group_by(start_year) %>% summarise(ave_num_phases = mean(number_phases))

# create boxplot for average number phase changes by data range
ave_num_phases_by_start_year <- ggplot(ave_phase_changes_by_start_year, aes(x = start_year, y = ave_num_phases)) +
  geom_bar(stat = "identity") +
  scale_x_continuous(name = "Start year of dataset") +
  scale_y_continuous(name = "Average # of phase changes", expand = c(0,0)) +
  ggtitle("Average # of phase changes by start year") + 
  theme(axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.line.y = element_line(size = 0.5, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

ave_num_phases_by_start_year

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/ave_num_phases_by_start_year ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
ave_num_phases_by_start_year
dev.off()

# create line plot for years to reach stability for each range of years for all life stages
pal<-brewer.pal(4, "Set2")
tick_dataset_results_sub_lf <- subset(tick_dataset_results, life_stage == "adult" | life_stage == "nymph" | life_stage == "larvae")
years_to_reach_stability_ls <- ggplot(tick_dataset_results_sub_lf, aes(x=stability_time, color=life_stage)) +
  scale_color_manual(values = pal)+
  geom_line(stat = "count", size=2) +
  scale_y_continuous(name = "Number of datasets", expand = c(0,0)) +
  xlab("Years to reach stability") + 
  xlim(low=0, high=14)+
  labs(color="Life Stage") +
  ggtitle("Years to reach stability for all datasets for each life stage") +
  theme(axis.line.x = element_line(size = 1, colour = "black"),
        axis.line.y = element_line(size = 1, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        legend.text = element_text(size = 15),
        legend.title = element_text(size = 17),
        legend.position = c(0.9, 0.9),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

years_to_reach_stability_ls

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/years_to_reach_stability_for_each_ls ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
years_to_reach_stability_ls
dev.off()


plot(tick_dataset_results$stability_time, tick_dataset_results$geographic_scope)

# create line plot for years to reach stability for each range of years for all life stages
pal<-brewer.pal(4, "Set2")
years_to_reach_stability_gs <- ggplot(tick_dataset_results, aes(x=stability_time, color=geographic_scope)) +
  scale_color_manual(values = pal)+
  geom_line(stat = "count", size=2) +
  scale_y_continuous(name = "Number of datasets", expand = c(0,0)) +
  xlab("Years to reach stability") + 
  xlim(low=0, high=14)+
  labs(color="Geographic scope") +
  ggtitle("Years to reach stability for all datasets for each geographic scope") +
  theme(axis.line.x = element_line(size = 1, colour = "black"),
        axis.line.y = element_line(size = 1, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        legend.text = element_text(size = 15),
        legend.title = element_text(size = 17),
        legend.position = c(0.9, 0.9),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

years_to_reach_stability_gs

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/years_to_reach_stability_for_each_gs ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
years_to_reach_stability_gs
dev.off()


# create line plot for years to reach stability for each range of years for all life stages
pal<-brewer.pal(4, "Set2")
years_to_reach_stability_gs <- ggplot(tick_dataset_results, aes(x=stability_time, color=geographic_scope)) +
  scale_color_manual(values = pal)+
  geom_line(stat = "count", size=2) +
  scale_y_continuous(name = "Number of datasets", expand = c(0,0)) +
  xlab("Years to reach stability") + 
  xlim(low=0, high=14)+
  labs(color="Geographic scope") +
  ggtitle("Years to reach stability for all datasets for each geographic scope") +
  theme(axis.line.x = element_line(size = 1, colour = "black"),
        axis.line.y = element_line(size = 1, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        legend.text = element_text(size = 15),
        legend.title = element_text(size = 17),
        legend.position = c(0.9, 0.9),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

years_to_reach_stability_gs

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/years_to_reach_stability_for_each_gs ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
years_to_reach_stability_gs
dev.off()



ggplot(tick_dataset_results, aes(x=state, y=stability_time)) + geom_point()
# ny seemed to take the longest time to reach stability

ggplot(tick_dataset_results, aes(x=state, y=proportion_wrong)) + geom_boxplot() + geom_point() 
# ny seemed to have the greatest proportion significance
nj <- tick_dataset_results[tick_dataset_results$state == "NJ",]
ny <- tick_dataset_results[tick_dataset_results$state == "NY",]
ma <- tick_dataset_results[tick_dataset_results$state == "MA",]

t.test(nj$proportion_wrong, ny$proportion_wrong)
# t = -1.869, df = 97.947, p-value = 0.06461
# t-value indicates probability below 0.5
# very low probability of difference between datasets
#
# not a statistically significant difference between states NY and NJ

t.test(ny$proportion_wrong, ma$proportion_wrong)
# t = 3.8321, df = 89, p-value = 0.0002364
# t-value indicates probability above 0.995
# very high probability of difference between datasets
#
# p-value less than 0.05, reject null hypothesis
# therefore alternative hypothesis: true difference in means is not equal to 0 is supported
# statiscally significant

t.test(nj$proportion_wrong, ma$proportion_wrong)
# t = 0.85054, df = 40, p-value = 0.4001
# t-value indicates probability between 0.20 and 0.25
# low probability of difference between datasets
#
# p-value above than 0.05, accept null hypothesis
# therefore not statistically significant

#create boxplot of state vs proportion wrong
proportion_sig_w_by_state <- ggplot(tick_dataset_results, aes(x = state, y = proportion_wrong)) +
  geom_boxplot() + 
  scale_x_discrete(name = "State") +
  scale_y_continuous(name = "Proportion Significantly Wrong") +
  ggtitle("Proportion significantly wrong for each state") + 
  theme(axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.line.y = element_line(size = 0.5, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

proportion_sig_w_by_state

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/proportion_sig_w_by_state ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
proportion_sig_w_by_state
dev.off()


ggplot(tick_dataset_results, aes(x=data_range, y=number_phases)) + geom_point()
# larger data ranges seemed to have a larger number of phases

# run t-test between two different datasets: data_range and number_phases
# assumes that the variances of y1 and y2 are unequal
t.test(tick_dataset_results$data_range, tick_dataset_results$number_phases)
# t = 24.071, df = 142.62, p-value < 2.2e-16
# t-value indicates probability above 0.9995
# very high probability of difference between datasets
#
# p-value less than 0.05, reject null hypothesis
# therefore alternative hypothesis: true difference in means is not equal to 0 is supported
# statiscally significant


ggplot(tick_dataset_results, aes(x=geographic_scope, y=proportion_significant)) + geom_point()
#proportion significant seems to be smaller with smaller geographic scope

ggplot(tick_dataset_results, aes(x=geographic_scope, y=stability_time)) + geom_point()
#stability time seems to increase with smaller geographic scope


ggplot(tick_dataset_results, aes(x=start_year, y=number_phases)) + geom_point()
# number of phases seems to decrease with more recent start years

# define recent datasets as older than 2005 and older datasets as older than 1999
recent <- tick_dataset_results[tick_dataset_results$start_year > 2005,]
old <- tick_dataset_results[tick_dataset_results$start_year < 1999,]

t.test(recent$number_phases, old$number_phases)
# t = -11.765, df = 32.4, p-value = 3.088e-13
# t-value indicates probability below 0.5
# very low probability of difference between datasets
#
# p-value less than 0.05, reject null hypothesis
# therefore alternative hypothesis: true difference in means is not equal to 0 is supported
# statiscally significant

num_phases_by_start_year <- ggplot(tick_dataset_results, aes(x = start_year, y = number_phases, group=start_year)) +
  geom_violin(width = 2, size=1) +
  geom_count(color="darkgray") + 
  scale_x_continuous(name = "Start year of dataset") +
  scale_y_continuous(name = "Number of phase changes", expand = c(0,0)) +
  ggtitle("Number of phase changes by start year") + 
  theme(axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.line.y = element_line(size = 1, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        legend.text = element_text(size = 15),
        legend.title = element_text(size = 17),
        legend.position = c(0.9, 0.9),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

num_phases_by_start_year

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/num_phases_by_start_year ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
num_phases_by_start_year
dev.off()

tick_dataset_results_sub_frac_nym_inf <- subset(tick_dataset_results, life_stage == "fraction of nymphal ticks infected with B. burgdorferi")
tick_dataset_results_sub_frac_adu_inf <- subset(tick_dataset_results, life_stage == "fraction of adult ticks infected with B. burgdorferi")

tick_dataset_results_sub_frac_inf <- subset(tick_dataset_results, life_stage == "fraction of adult ticks infected with B. burgdorferi" | life_stage == "fraction of nymphal ticks infected with B. burgdorferi")


ggplot(tick_dataset_results_sub_frac_inf, aes(x=life_stage, y=stability_time)) + geom_point()
#fraction of nymphal ticks appear reach stability after longer periods of time


ggplot(tick_dataset_results, aes(x=data_range, y=number_phases)) + geom_point()

large <- tick_dataset_results[tick_dataset_results$data_range > 17,]
small <- tick_dataset_results[tick_dataset_results$data_range < 14,]
t.test(small$number_phases, large$number_phases)
# t = 11.749, df = 32.165, p-value = 3.547e-13
# t-value indicates probability above 0.995
# very high probability of difference between datasets
#
# p-value less than 0.05, reject null hypothesis
# therefore alternative hypothesis: true difference in means is not equal to 0 is supported
# statiscally significant

num_phases_by_data_range <- ggplot(tick_dataset_results, aes(x = data_range, y = number_phases, group=data_range)) +
  geom_violin(width = 2, size=1) +
  geom_count(color="darkgray") + 
  scale_x_continuous(name = "Data range (years)") +
  scale_y_continuous(name = "Number of phase changes", expand = c(0,0)) +
  ggtitle("Number of phase changes by data range") + 
  theme(axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.line.y = element_line(size = 1, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        legend.text = element_text(size = 15),
        legend.title = element_text(size = 17),
        legend.position = c(0.1, 0.9),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

num_phases_by_data_range

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/num_phases_by_data_range ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
num_phases_by_data_range
dev.off()

ggplot(tick_dataset_results, aes(x=stability_time, y=proportion_wrong)) + geom_point()
# seems that proportion wrong is higher with smaller years it took to reach stability

large_stab <- tick_dataset_results[tick_dataset_results$stability_time > 10,]
small_stab <- tick_dataset_results[tick_dataset_results$stability_time < 9,]

t.test(large_stab$proportion_wrong, small_stab$proportion_wrong)
# t = -0.099863, df = 35.402, p-value = 0.921
# t-value indicates probability lower than 0.5
# very low probability of difference between datasets
#
# p-value higher than 0.05, accept null hypothesis
# statiscally insignificant

por_wrong_by_stab_time <- ggplot(tick_dataset_results, aes(stability_time, proportion_wrong)) +
  geom_point() +
  geom_smooth(size=2) +
  scale_x_continuous(name = "Years to stability", expand = c(0,0)) +
  scale_y_continuous(name = "Proportion significantly wrong", expand = c(0,0)) +
  ggtitle("Proportion significantly wrong by years to stability") + 
  theme(axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.line.y = element_line(size = 1, colour = "black"),
        axis.line = element_line(size=1, colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        plot.title=element_text(size = 27, margin=margin(0,0,15,0)),
        axis.text.x=element_text(colour="black", size = 18),
        axis.text.y=element_text(colour="black", size = 18),
        axis.title.x = element_text(size = 23, margin=margin(15,0,0,0)),
        axis.title.y = element_text(size = 23, margin=margin(0,15,0,0)))

por_wrong_by_stab_time

png(filename = paste("D:/Ixodes_scapularis_research_2019/tick_dataset_results_algorithms/por_wrong_by_stab_time ",Sys.Date(),".png", sep = ''), width = 876, height = 604)
por_wrong_by_stab_time
dev.off()


fit1=lmer(stability_time ~ data_range + state + life_stage + sampling_technique + geographic_scope + (1|location), data = tick_dataset_results, REML=FALSE)
anova(fit1)
summary(fit1)


