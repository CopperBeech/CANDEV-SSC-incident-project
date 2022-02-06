#Find the mean and median number of hours an incident spends in each status

#Put the relevant columns in a list
times_list <- as.list(modified_incidents[, c(10:22)])
#Remove NA values from each vector
times_list <- lapply(times_list, na.omit)
boxplot(times_list)

#Calculate mean and median times for each status
mean_times <- sapply(times_list, mean)
median_times <- sapply(times_list, median)

#Find the number of observations for each status
sample_size <- sapply(times_list, length)

#Create a data frame showing statistics for each status
output_table <- data.frame(mean_times, median_times, sample_size)

print(output_table)

##### OPTIONAL
#Use log1p to avoid errors from taking the log of 0 values
log_times_list <- lapply(times_list_na_rm, log1p)

boxplot(log_times_list)
#Calculate the mean of the log times
mean_log_times <- sapply(log_times_list, mean)
