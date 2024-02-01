# "Introduction to R - NICAR, 2020"
# Rob Wells, PhD
# University of Arkansas
# LinkedIn: https://www.linkedin.com/in/rob-wells-7929329/
# @rwells1961
# 1/12/2020

# ------- Get Organized --------- #  
#install.packages("here")
library(here)
#here() starts at here() starts at /Users/robwells/Dropbox/Current_Projects/R1_Intro_R_RStudio_Wells

#Wells setup
#setwd("~/Dropbox/Current_Projects/Guest_Lectures/Intro_To_R")

#---------------------------------------------------#
#  Orientation to R Studio  
#---------------------------------------------------#
#  There are four main windows:  

# Script writing, R Markdown, Table Viewer: Upper Left  
# Environment - data loaded in R: Upper Right  
# Console - write commands in R: Lower Left  
# File Manager and Html table viewer: Bottom Right  

#  In the Console window, type:
demo()
help()
help.start()
#---------------------------------------------------#
#Install software to grab data
#---------------------------------------------------#
#tidyverse installs 8 separate software packages to perform
#data import, tidying, manipulation, visualisation, and programming
install.packages("tidyverse")

#Rio package: easy importing features and janitor for data cleaning
install.packages("rio") 
install.packages("janitor")


#After you install a package on your hard drive, you can call it back up by summoning a library
#Libraries are bits of software you will have to load each time into R to make things run. 
library(tidyverse)
library(rio)
library(janitor)
#
#Check to see  what's installed by clicking on "Packages" tab in File Manager, lower right pane
#
#---------------------------------------------------#
#  Data
#---------------------------------------------------#
#Open this file in Excel:
./R1_Intro_R_RStudio_Wells/RealMediaSalariesCleaned.xlsx
#Select RealMediaSalaries2 tab
#
#IRE Old School: Four Corners Test!
#13 Columns
#1658 Rows
#Numberic data in Salary, Years Experience
#Mixed string data in Gender Identity / Ethnicity, Job duties
#
#---------------------------------------------------#
#Import Data 
#---------------------------------------------------#

MediaBucks <- rio::import("RealMediaSalariesCleaned.xlsx", which = "RealMediaSalaries2")

#What happened? Look at the table
View(MediaBucks)
#What happened?

#R grabbed the spreadsheet from the folder
#We told R to grab the first sheet, RealMediaSalaries2
#R created a dataframe called MediaBucks
#basics of R: <- is known as an “assignment operator.” 
#It means: “Make the object named to the left equal to the output of the code to the right.”

#---------------------------------------------------#
#  Explore Data
#---------------------------------------------------#

# How many rows?  
nrow(MediaBucks)

# How many columns?
ncol(MediaBucks)

#Names of your columns
colnames(MediaBucks)

#OR
names(MediaBucks)

#Check data types
str(MediaBucks)

# Let's look at the first six rows
head(MediaBucks)

#Here is a quick way to view the range of your data  
summary(MediaBucks$Salary)

#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 0   42000   60000   64174   78000  770000       4 

#Size and scope
sum(MediaBucks$Salary, na.rm=TRUE)
#
#$106 million! for 1,658 journalists

#Context:
#NYT earnings in 2018 = $126m in 2018
#Facebook earnings for two days: $135 million (Q32019=$6.1B)

#average
mean(MediaBucks$Salary, na.rm=TRUE)

#Distribution
quantile(MediaBucks$Salary, c(0.1, 0.2, 0.3, 0.4,0.5, 0.6, 0.7, 0.8, 0.9), na.rm=TRUE)
quantile(MediaBucks$Salary, c(0.25, 0.50, 0.75, 0.9, 0.99), na.rm=TRUE)

#---------------------------------------------------#
#  Navigation Tips
#---------------------------------------------------#


#Shortcut Commands
#Tab - Autocomplete
#In Console Window (lower left) 
#--Control (or Command) + UP arrow - last lines run
#Control (or Command) + Enter - Runs current or selected lines of code in the top left box of RStudio
#Shift + Control (or Command) +P - Reruns previous region code

#---------------------------------------------------#
#dplyr
#---------------------------------------------------#

#dplyr has many tools for data analysis
#select Choose which columns to include.
#filter Filter the data.
#arrange Sort the data, by size for continuous variables, by date, or alphabetically.
#group_by Group the data by a categorical variable.

#Build a simple summary table by Gender
Summary <- MediaBucks %>% 
  select(Gender, Salary) %>% 
  group_by(Gender) %>% 
  summarize(Total = sum(Salary, na.rm=TRUE))

#What is the sample size?
Gender <- MediaBucks %>% 
  count(Gender) %>% 
  arrange(desc(n))

#Better idea: Check Averages!

#Build a simple summary table by Gender
Summary <- MediaBucks %>% 
  select(Gender, Salary) %>% 
  group_by(Gender) %>% 
  summarize(Avg_Salary = mean(Salary, na.rm=TRUE))
#
#Quick filter out hourly workers
MediaSalary <- MediaBucks %>% 
  filter(Salary >= 1000)



#Questions
#1: View the range of your data  
#2: Number of rows
#3: Number of rows cut with filter

#Answer: #1

#Answer: #2

#Answer: #3

#---------------------------------------------------#
#Find Your News Organization
#---------------------------------------------------#

#Filter
WSJ <- subset(MediaBucks, COMPANY=="WallStreetJournal")  

summary(WSJ$Salary)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#    38   41000   51100   64275   75750  236000 
#
#Using Wildcards 
Journal <- subset(MediaBucks, grepl("?Journal", COMPANY))
Bloom <- subset(MediaBucks, grepl("?Bloomberg", COMPANY))
#
#Questions
#1: Build a table for NewYorkTimes employees
#2: Determine median salary of NewYorkTimes employees
#3: Identify title, gender and race of the highest paid position at NYT'
#4: Search for "Business" in Company, check salaries, compare to "Bloomberg"

#Answers:
#1: Build a table for NewYorkTimes employees

#2: Determine median salary of NewYorkTimes employees

#3: Identify title, gender and race of the highest paid position at NYT

#4: Search for "Business" in Company, check median salaries, compare to "Bloomberg"

#
#---------------------------------------------------#
# More Tables
#---------------------------------------------------#

#Build a table with several companies of your choice
BigBoys <- filter(MediaSalary, COMPANY %in% c("NewYorkTimes", "WallStreetJournal", "Bloomberg"))    
#
#Table with just reporter salaries
Reporters <- subset(MediaBucks, grepl("?reporter", TITLE))
summary(Reporters$Salary)
#
#Questions:
#1: Who is making $230,504 as a reporter???
#2: Make a table for editors, figure out medians.
#3: Find highest paid editor. Resent them.
#4: Make a table for any position involving data

#Answer:
#1: Who is making $230,504 as a reporter???

#2: Make a table for editors, figure out medians.

#3: Find highest paid editor. Resent them.

#4: Make a table for any position involving data


#-------------------------------------------------------------------#
# Build a Chart, By Gender
#-------------------------------------------------------------------#

MediaBucks %>% ggplot(aes(y = Salary, x=Gender)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Media Salaries by Gender", 
       subtitle = "Source: RealMediaSalaries survey, 2019 ",
       caption = "Graphic by Rob Wells",
       x="County",
       y="Salary")

#This ugly dog needs some work

#Get rid of scientific notation
options("scipen"=100, "digits"=4)

MediaBucks %>% ggplot(aes(y = Salary, x=Gender)) +
  geom_bar(stat = "identity") +
   scale_y_continuous(labels = scales::dollar) +
  labs(title = "Total Media Salaries by Gender", 
       subtitle = "Source: RealMediaSalaries survey, 2019 ",
       caption = "Graphic by Rob Wells",
       x="County",
       y="Salary")

#Add Color

MediaBucks %>% ggplot(aes(y = Salary, x=Gender, color = Gender)) +
  geom_bar(stat = "identity") +
  theme(legend.position = "none") +
  #coord_flip() +     #this makes it a horizontal bar chart instead of vertical
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Total Media Salaries by Gender", 
       subtitle = "Source: RealMediaSalaries survey, 2019 ",
       caption = "Graphic by Rob Wells",
       x="County",
       y="Salary")


#Average salaries is the story!
MediaBucks %>% 
  select(Gender, Salary) %>% 
  group_by(Gender) %>% 
  summarize(mean = mean(Salary, na.rm=TRUE))  %>% 
  ggplot(aes(y = mean, x=Gender, color = Gender, fill=Gender)) +
  geom_bar(stat = "identity") +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Average Media Salaries by Gender", 
       subtitle = "Source: RealMediaSalaries survey, 2019 ",
       caption = "Graphic by Rob Wells",
       x="County",
       y="Salary")

#Export
#Lower right, Export as .png file

#-------------------------------------------------------------------#
#      What You Have Learned So Far
#-------------------------------------------------------------------#  

# How to navigate in R studio
# How to install libraries and packages 
# How to import a .xlsx file into R
# How to obtain summary statistics (summary)
# How to build basic tables from a dataset
# How to conduct filter queries from a dataset
# How to build basic charts

#---------------------------------------------#
#   Tutorials                                 #
#---------------------------------------------#


#All Cheat Sheets
https://www.rstudio.com/resources/cheatsheets/
  
#MaryJo Webster tutorials
http://mjwebster.github.io/DataJ/R_tutorials/opiate_deaths.nb.html
https://github.com/mjwebster/R_tutorials/blob/master/Using_R.Rmd

#Aldhous' R tutorial
http://paldhous.github.io/NICAR/2018/r-analysis.html

#Ron Campbell Lecture
https://github.com/roncampbell/NICAR2018/blob/master/Intro%20to%20R.md

#Excellent Tutorial Spelling out Excel and Comparable Commands in R
https://trendct.org/2015/06/12/r-for-beginners-how-to-transition-from-excel-to-r/
https://docs.google.com/presentation/d/1O0eFLypJLP-PAC63Ghq2QURAnhFo6Dxc7nGt4y_l90s/edit#slide=id.g1bc441664e_0_59

#Andrew Ba Tran first Data Analysis Steps Using R
https://docs.google.com/presentation/d/1O0eFLypJLP-PAC63Ghq2QURAnhFo6Dxc7nGt4y_l90s/edit#slide=id.p

#Charts
https://www.rdocumentation.org/packages/ggplot2/versions/1.0.1/topics/geom_bar
http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/
  
#Base R Cheat Sheet
https://www.povertyactionlab.org/sites/default/files/r-cheat-sheet.pdf

