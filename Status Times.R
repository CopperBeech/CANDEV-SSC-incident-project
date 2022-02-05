incident_history <- read.csv(file = "SSC dataset/INCIDENT_HISTORY.csv", col.names = c("ticket_number", "status", "change_date", "time_in_status_hours"))
head(incident_history)
status_names <- unique(incident_history$status)
##Create a list where each element is a data frame for each ticket
incident_history_list <- as.list(split.data.frame(incident_history, incident_history$ticket_number))
 
#Write a function to find the relevant time for each ticket
find_times <- function(Ticket, Status) {
  time <- Ticket$time_in_status_hours[Ticket$status == Status]
  if(length(time) == 1){
    return(time)
  } else if (length(time) > 1) {
    return(sum(time))
  } else return(NA)
}

#Apply the function to the list for each status
queued_times <- sapply(incident_history_list, find_times, Status = "QUEUED")
resolved_times <- sapply(incident_history_list, find_times, Status = "RESOLVED")
closed_times <- sapply(incident_history_list, find_times, Status = "CLOSED")
new_times <- sapply(incident_history_list, find_times, Status = "NEW")
inprog_times <- sapply(incident_history_list, find_times, Status = "INPROG")
pendingrev_times <- sapply(incident_history_list, find_times, Status = "PENDINGREV")
pending_times <- sapply(incident_history_list, find_times, Status = "PENDING")
pendingchg_times <- sapply(incident_history_list, find_times, Status = "PENDINGCHG")
pendingven_times <- sapply(incident_history_list, find_times, Status = "PENDINGVEN")
pendingcus_times <- sapply(incident_history_list, find_times, Status = "PENDINGCUS")
histedit_times <- sapply(incident_history_list, find_times, Status = "HISTEDIT")
awaitchg_times <- sapply(incident_history_list, find_times, Status = "AWAITCHG")
awaitcus_times <- sapply(incident_history_list, find_times, Status = "AWAITCUS")
slahold_times <- sapply(incident_history_list, find_times, Status = "SLAHOLD")
awaitven_times <- sapply(incident_history_list, find_times, Status = "AWAITVEN")
#Put the vectors in a list for simplicity
times_list <- list(queued_times, resolved_times, closed_times, new_times, inprog_times,
                   pendingrev_times, pending_times, pendingchg_times, pendingven_times,
                   pendingcus_times, histedit_times, awaitchg_times, awaitcus_times,
                   slahold_times, awaitven_times)
#Remove NA values
times_list_na_rm <- sapply(times_list, na.omit)
boxplot(times_list_na_rm)

#Calculate mean and median times for each status
mean_times <- sapply(times_list_na_rm, mean)
median_times <- sapply(times_list_na_rm, median)

#Use log1p to avoid errors from taking the log of 0 values
log_times_list <- lapply(times_list_na_rm, log1p)

boxplot(log_times_list)
#Calculate the mean of the log times
mean_log_times <- sapply(log_times_list, mean)
#Create a data frame showing statistics for each status
output_table <- data.frame(mean_times, mean_log_times, median_times, row.names = names_of_statuses)

print(output_table)