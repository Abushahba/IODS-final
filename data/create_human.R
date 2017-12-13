# This is the Data wrangling for human data! by Author: Ahmed Abushahba, 13/12/2017, let's import our data sets

library("dplyr")

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables.

str(hd)

dim(hd)

summary(hd)

str(gii)

dim(gii)

summary(gii)

# rename the variables with (shorter) descriptive names

hd <- hd %>% rename(HDI=Human.Development.Index..HDI., Life.Exp=Life.Expectancy.at.Birth, Edu.Exp =Expected.Years.of.Education, MYEd = Mean.Years.of.Education, GNI =Gross.National.Income..GNI..per.Capita, GNI_HDIRan =GNI.per.Capita.Rank.Minus.HDI.Rank)

gii <- gii %>% rename(GII=Gender.Inequality.Index..GII., Mat.Mor=Maternal.Mortality.Ratio, Ado.Birth=Adolescent.Birth.Rate, Parli.F=Percent.Representation.in.Parliament, Edu2.F=Population.with.Secondary.Education..Female., Edu2.M=Population.with.Secondary.Education..Male., Labo.F=Labour.Force.Participation.Rate..Female.,Labo.M=Labour.Force.Participation.Rate..Male.)

names(hd)

names(gii)

# Mutate the "Gender inequality" data and create two new variables. The first one should be the ratio of Female and Male populations with
# secondary education in each country. (i.e. edu2F / edu2M). The second new variable should be the ratio of labour force participation of females and males in each country 
#(i.e. labF / labM).

gii <- mutate(gii, Edu2.FM = ( Edu2.F / Edu2.M))
gii <- mutate(gii, Labo.FM = (Labo.F / Labo.M))

colnames(gii)


# Join together the two datasets using the variable Country as the identifier. 
# Keep only the countries in both data sets.
# Call the new joined data "human" and save it. 

hd_gii <- inner_join(hd, gii, by = "Country") 

str(hd_gii)

glimpse(hd_gii)

human <- hd_gii

# transform the Gross National Income (GNI) variable to numeric
human <- human[-1]

str(human$GNI)

# removing commas from GNI and make it numeric

library(stringr)

str_replace(human$GNI, pattern=",", replace ="")

human$GNI <- as.factor(human$GNI)

human$GNI = as.numeric(human$GNI)
is.numeric(human$GNI)

# Exclude unneeded variables: keep only the columns matching the following
# variable names:  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" 

keep_columns <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- dplyr::select(human, one_of(keep_columns))

# Remove all rows with missing values and remove
# the observations which relate to regions instead of countries
complete.cases(human)

data.frame(human, comp = complete.cases(human))
human_mut <- mutate(human, comp = complete.cases(human))
dim(human_mut)

human_mut <- filter(human, human_mut$comp == TRUE)
human_ <- human_mut

tail(human_, n=10)
humanW <- human_ [1:155,]

# Define the row names of the data by the country names
# and remove the country name column from the data. 

rownames(humanW) <- humanW$Country
humanW <- dplyr::select(humanW, -Country)

# Save the human data in data folder 

write.csv(humanW, file="C:/Users/ahmed/Desktop/IODS-final-master/IODS-final/data/humanW.csv")



