#Read in the data
incident_owner_history <- read.csv(file = "SSC dataset/INCIDENT_OWNER_HISTORY.csv",
                             col.names = c("ticket_number", "status", "assigned_group",
                                           "parent_service", "service", "change_date",
                                           "time_in_status_by_owner_hours"))
head(incident_owner_history)
##Create a list where each element is a data frame for each ticket
incident_owner_history_list <- split.data.frame(incident_owner_history, incident_owner_history$ticket_number)
#This function returns the sum of the time at all statuses
sum_times <- function(ticket){
  total_time <- sum(ticket$time_in_status_by_owner_hours, na.rm = TRUE)
  return(total_time)
}
#This function counts the number of groups that worked on a ticket,
#and then subtracts 1 to give the number of reassignments
number_of_reassignments <- function(ticket){
  groups <- ticket$assigned_group
  groups <- unique(groups)
  reassignments <- length(groups)-1
  return(reassignments)
}
#Create a vector of incident restoration times
incident_times <- sapply(incident_owner_history_list, sum_times)
#Create a vector of incident reassignments
incident_reassignments <- sapply(incident_owner_history_list, number_of_reassignments)
#Output a plot and the correlation
plot(incident_reassignments, incident_times)
cor.test(incident_reassignments, incident_times, alternative = "two.sided", method = "pearson")
 
#Now do the same for the log of the time
log_incident_times <- log1p(incident_times)
plot(incident_reassignments, log_incident_times)
cor.test(incident_reassignments, log_incident_times, alternative = "two.sided", method = "pearson")
