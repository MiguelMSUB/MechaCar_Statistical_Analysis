demo_table <- read.csv(file='demo.csv',check.names=F,stringsAsFactors = F)

x <- c(3, 3, 2, 2, 5, 5, 8, 8, 9)
x[3]
demo_table[3,"Year"]

#For example, if we want to select the vector of vehicle classes from demo_table, we would use the following statement:
demo_table$"Vehicle_Class"

#Once we have selected the single vector, we can use bracket notation to select a single value.
demo_table$"Vehicle_Class"[2]

num_rows <- 1:nrow(demo_table)
sample_rows <- sample(num_rows, 3)
demo_table[sample_rows,]
demo_table[sample(1:nrow(demo_table), 3),]

library(tidyverse)
?mutate()

#we want to use our coworker vehicle data from the demo_table and add a column for 
#the mileage per year, as well as label all vehicles as active, we would use the following statement:

demo_table <- demo_table %>% mutate(Mileage_per_Year=Total_Miles/(2020-Year),IsActive=TRUE) #add columns to original data frame
demo_table3 <- read.csv('demo2.csv',check.names = F,stringsAsFactors = F)

#To change this dataset to a long format, we would use gather() to reshape this dataset.
long_table <- gather(demo_table3,key="Metric",value="Score",buying_price:popularity)
long_table <- demo_table3 %>% gather(key="Metric",value="Score",buying_price:popularity)
wide_table <- long_table %>% spread(key="Metric",value="Score")

#And if we want to check if our newly created wide-format table is exactly the same as our original demo_table3, 
#we can use R's all.equal() function:
all.equal(demo_table3, wide_table)

#15.3.1 Introduction to ggplot2
head(mpg)

#import dataset into ggplot2
plt <- ggplot(mpg,aes(x=class)) 

#plot a bar plot
plt + geom_bar()

#Another use for bar plots is to compare and contrast categorical results. 
#For example, if we want to compare the number of vehicles from each manufacturer in the dataset, 
#we can use dplyr's summarize() function to summarize the data, and ggplot2's geom_col() to visualize the results:

#create summary table
mpg_summary <- mpg %>% group_by(manufacturer) %>% summarize(Vehicle_Count=n(), .groups = 'keep') 
#import dataset into ggplot2
plt <- ggplot(mpg_summary,aes(x=manufacturer,y=Vehicle_Count)) 
#plot a bar plot
plt + geom_col() 

#To address the issues with the plot, we'll need to add formatting functions to our plotting statement. 
#To change the titles of our x-axis and y-axis, we can use the xlab()and ylab()functions, respectively:
plt + geom_col() + xlab("Manufacturing Company") + ylab("Number of Vehicles in Dataset") +
  #rotate the x-axis label 45 degrees
  theme(axis.text.x=element_text(angle=45,hjust=1)) 

#When creating the ggplot object for our line data, we need to set the categorical variable to the x value
#and our continuous variable to the y value within our aes() function. 
#For example, if we want to compare the differences in average highway fuel economy (hwy) of Toyota vehicles 
#as a function of the different cylinder sizes (cyl), our R code would look like the following:
#create summary table
mpg_summary <- subset(mpg,manufacturer=="toyota") %>% group_by(cyl) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep') 
#import dataset into ggplot2
plt <- ggplot(mpg_summary,aes(x=cyl,y=Mean_Hwy)) 
plt + geom_line()

#To adjust the x-axis and y-axis tick values, we'll use the scale_x_discrete() and scale_y_continuous() functions:
#add line plot with labels
plt + geom_line() + scale_x_discrete(limits=c(4,6,8)) + scale_y_continuous(breaks = c(15:30))


#if we want to create a scatter plot to visualize the relationship between the size of each car engine (displ) versus their city fuel efficiency (cty), 
#we would create the following ggplot object:
#import dataset into ggplot2
plt <- ggplot(mpg,aes(x=displ,y=cty)) 
#add scatter plot with labels
plt + geom_point() + xlab("Engine Size (L)") + ylab("City Fuel-Efficiency (MPG)") 


#If we apply these custom aesthetics to our previous example, we can use scatter plots to visualize the relationship between city fuel efficiency 
#and engine size, while grouping by additional variables of interest:
#import dataset into ggplot2
plt <- ggplot(mpg,aes(x=displ,y=cty,color=class))
#add scatter plot with labels
plt + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", color="Vehicle Class")

#By coloring each data point by its vehicle class, we can see that vehicle class data points are clustering together 
#in regard to our engine size and city fuel efficiency. We're not limited to only adding one aesthetic either:
#import dataset into ggplot2
plt <- ggplot(mpg,aes(x=displ,y=cty,color=class,shape=drv))
#add scatter plot with multiple aesthetics
plt + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", color="Vehicle Class",shape="Type of Drive")


#To generate a boxplot in ggplot2, we must supply a vector of numeric values. 
#For example, if we want to generate a boxplot to visualize the highway fuel efficiency of our mpg dataset
#import dataset into ggplot2
plt <- ggplot(mpg,aes(y=hwy))
#add boxplot
plt + geom_boxplot()

#Expanding on our previous example, if we want to create a set of boxplots that compares highway fuel efficiency 
#for each car manufacturer,
#import dataset into ggplot2
plt <- ggplot(mpg,aes(x=manufacturer,y=hwy))
#add boxplot and rotate x-axis labels 45 degrees
plt + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + theme(axis.text.x=element_text(angle=45,hjust=1))

#15.3.6 Create Heatmap Plots

#we want to visualize the average highway fuel efficiency across the type of vehicle class from 1999 to 2008,
mpg_summary <- mpg %>% group_by(class,year) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep') #create summary table
plt <- ggplot(mpg_summary, aes(x=class,y=factor(year),fill=Mean_Hwy))
plt + geom_tile() + labs(x="Vehicle Class",y="Vehicle Year",fill="Mean Highway (MPG)") #create heatmap with labels

#we want to look at the difference in average highway fuel efficiency across each vehicle model from 1999 to 2008
mpg_summary <- mpg %>% group_by(model,year) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep') #create summary table
plt <- ggplot(mpg_summary, aes(x=model,y=factor(year),fill=Mean_Hwy)) #import dataset into ggplot2
plt + geom_tile() + labs(x="Model",y="Vehicle Year",fill="Mean Highway (MPG)") + #add heatmap with labels 
  theme(axis.text.x = element_text(angle=90,hjust=1,vjust=.5)) #rotate x-axis labels 90 degrees

#15.3.7 Add Layers to Plots
# to recreate our previous boxplot example comparing the highway fuel efficiency across manufacturers,
#add our data points using the geom_point() function:
plt <- ggplot(mpg,aes(x=manufacturer,y=hwy)) #import dataset into ggplot2
plt + geom_boxplot() + #add boxplot
   theme(axis.text.x=element_text(angle=45,hjust=1)) + #rotate x-axis labels 45 degrees
   geom_point() #overlay scatter plot on top

#create summary table
mpg_summary <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ), .groups = 'keep') 
#import dataset into ggplot2
plt <- ggplot(mpg_summary,aes(x=class,y=Mean_Engine)) 
#add scatter plot
plt + geom_point(size=4) + labs(x="Vehicle Class",y="Mean Engine Size") 


#If we compute the standard deviations in our dplyr summarize() function, 
#we can layer the upper and lower standard deviation boundaries to our visualization 
#using the geom_errorbar() function:

mpg_summary <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ),SD_Engine=sd(displ), .groups = 'keep')
plt <- ggplot(mpg_summary,aes(x=class,y=Mean_Engine)) #import dataset into ggplot2
plt + geom_point(size=4) + labs(x="Vehicle Class",y="Mean Engine Size") + #add scatter plot with labels
  geom_errorbar(aes(ymin=Mean_Engine-SD_Engine,ymax=Mean_Engine+SD_Engine)) #overlay with error bars

#Faceting is performed by adding a facet() function to the end of our plotting statement. 
mpg_long <- mpg %>% gather(key="MPG_Type",value="Rating",c(cty,hwy)) #convert to long format
head(mpg_long)

#we want to visualize the different vehicle fuel efficiency ratings by manufacturer
plt <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type)) #import dataset into ggplot2
plt + geom_boxplot() + theme(axis.text.x=element_text(angle=45,hjust=1)) #add boxplot with labels rotated 45 degrees

#The facets argument expects a list of grouping variables to facet by using the vars() function. 
#Therefore, to facet our previous example by the fuel-efficiency type,
plt <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type)) #import dataset into ggplot2
plt + geom_boxplot() + facet_wrap(vars(MPG_Type)) + #create multiple boxplots, one for each MPG type
  theme(axis.text.x=element_text(angle=45,hjust=1),legend.position = "none") + xlab("Manufacturer") #rotate x-axis labels





