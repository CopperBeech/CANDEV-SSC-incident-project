incident_history <- read.csv(file = "SSC dataset/INCIDENT_HISTORY.csv", col.names = c("ticket_number", "status", "change_date", "time_in_status_hours"))
head(incident_history)
incident_history_list <- as.list(split.data.frame(incident_history, incident_history$ticket_number))

find_times <- function(Ticket, Status) {
  time <- Ticket$time_in_status_hours[Ticket$status == Status]
  if(length(time) == 1){
    return(time)
  } else if (length(time) > 1) {
    return(time[1])
  } else return(NA)
}

queued_times <- sapply(incident_history_list, find_times, Status = "QUEUED")
head(queued_times)
mean(queued_times, na.rm = TRUE)
