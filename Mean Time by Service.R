#Find the mean business completion hours to resolve an incident for each service

#Create list of data frames; one for each service
incidents_by_service <- split.data.frame(modified_incidents, modified_incidents$service)
#Function to compute the mean actual completion hours
mean_actual_hours <- function(dat){
  mean_actual_hrs <- mean(dat$actual_completion_hours, na.rm =TRUE)
  return(mean_actual_hrs)
}
#Function to compute the mean business completion hours
mean_business_hours <- function(dat){
  mean_business_hrs <- mean(dat$business_completion_hours, na.rm =TRUE)
  return(mean_business_hrs)
}
#Apply functions to each data frame
mean_actual_time_by_service <- sapply(incidents_by_service, mean_actual_hours)
mean_business_time_by_service <- sapply(incidents_by_service, mean_business_hours)

mean_service_times <- cbind.data.frame(mean_actual_time_by_service, mean_business_time_by_service)
print(mean_service_times)
