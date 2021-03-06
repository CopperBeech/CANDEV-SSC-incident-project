#Import data files
incidents_filepath <- "C:\\Users\\Joseph Barss\\Documents\\R working directory\\SSC-IT-incident-management\\SSC dataset\\INCIDENTS.csv"

incidents <- read.csv(file = incidents_filepath, col.names = c("ticket_number", 
                                    "parent_service", "service", "org_id", "assigned_group", 
                                    "open_date", "close_date", "priority", "status", "actual_completion_hours",
                                    "business_completion_hours", "aging", "class_structure_id",
                                    "class_structure", "classification_id", "classification",
                                    "external_system", "global_ticket_id", "closure_code", "last_modified_date"))

incident_owner_history_filepath <- "C:\\Users\\Joseph Barss\\Documents\\R working directory\\SSC-IT-incident-management\\SSC dataset\\INCIDENT_OWNER_HISTORY.csv"

incident_owner_history <- read.csv(file = incident_owner_history_filepath, col.names = c(
                                                 "ticket_number", "status", "assigned_group",
                                                 "parent_service", "service", "change_date",
                                                 "time_in_status_by_owner_hours"))

##Create a list where each element is a data frame for each ticket
incident_owner_history_list <- split.data.frame(incident_owner_history, incident_owner_history$ticket_number)

#This function counts the number of groups that worked on a ticket,
#and then subtracts 1 to give the number of reassignments
number_of_reassignments <- function(ticket){
  groups <- ticket$assigned_group
  groups <- unique(groups)
  reassignments <- length(groups)-1
  return(reassignments)
}

#Create a vector of incident reassignments
incident_reassignments <- sapply(incident_owner_history_list, number_of_reassignments)

#This function returns the sum of the time at all statuses
sum_times <- function(ticket){
  total_time <- sum(ticket$time_in_status_by_owner_hours, na.rm = TRUE)
  return(total_time)
}

#Create a vector of incident restoration times
incident_times <- sapply(incident_owner_history_list, sum_times)

#Write a function to find the relevant time for each ticket
find_status_times <- function(dat, cat) {
  time <- dat$time_in_status_by_owner_hours[dat$status == cat]
  if(length(time) == 1){
    return(time)
  } else if (length(time) > 1) {
    return(sum(time))
  } else return(NA)
}

#Apply the function to the list for each status
queued_times <- sapply(incident_owner_history_list, find_status_times, cat = "QUEUED")
resolved_times <- sapply(incident_owner_history_list, find_status_times, cat = "RESOLVED")
inprog_times <- sapply(incident_owner_history_list, find_status_times, cat = "INPROG")
pendingrev_times <- sapply(incident_owner_history_list, find_status_times, cat = "PENDINGREV")
pending_times <- sapply(incident_owner_history_list, find_status_times, cat = "PENDING")
pendingchg_times <- sapply(incident_owner_history_list, find_status_times, cat = "PENDINGCHG")
pendingven_times <- sapply(incident_owner_history_list, find_status_times, cat = "PENDINGVEN")
pendingcus_times <- sapply(incident_owner_history_list, find_status_times, cat = "PENDINGCUS")
histedit_times <- sapply(incident_owner_history_list, find_status_times, cat = "HISTEDIT")
awaitchg_times <- sapply(incident_owner_history_list, find_status_times, cat = "AWAITCHG")
awaitcus_times <- sapply(incident_owner_history_list, find_status_times, cat = "AWAITCUS")
slahold_times <- sapply(incident_owner_history_list, find_status_times, cat = "SLAHOLD")
awaitven_times <- sapply(incident_owner_history_list, find_status_times, cat = "AWAITVEN")

#Create a new, cleaner data frame
modified_incidents <- cbind(incidents[, c(1, 3, 4, 5)], incident_reassignments, 
                            incidents[, c(8, 10, 11)], incident_times, queued_times,
                            resolved_times, inprog_times, pendingrev_times,
                            pending_times, pendingchg_times, pendingven_times,
                            pendingcus_times, histedit_times, awaitchg_times,
                            awaitcus_times, slahold_times, awaitven_times, 
                            incidents[17])

#Remove incidents where the actual completion hours was negative (due to data entry error)
modified_incidents <- modified_incidents[modified_incidents$actual_completion_hours >= 0, ]
#Remove incidents where the business completion hours was over 10,000 (due to data entry error)
modified_incidents <- modified_incidents[modified_incidents$business_completion_hours < 10000, ]
#Create new .csv file
write.csv(modified_incidents, file = "MODIFIED_INCIDENTS.csv", row.names = FALSE)

##### This is to create a modified version of INCIDENT_OWNER_HISTORY

#Remove rows in which no service is given
owner_history <- incident_owner_history[!(incident_owner_history$service == ""), c(1:5, 7)]
owner_history_list <- split.data.frame(owner_history, owner_history$ticket_number)
#This function will add a column telling the number of services that handled an incident
add_service_column <- function(ticket){
  services <- ticket$service
  services <- unique(services)
  number_of_services <- length(services)
  cbind(ticket, number_of_services)
}
#This function will add a column telling the number of groups that handled an incident
add_groups_column <- function(ticket){
  groups <- ticket$assigned_group
  groups <- unique(groups)
  number_of_groups <- length(groups)
  cbind(ticket, number_of_groups)
}

#Apply the functions to the list of data frames
modified_owner_history_list <- lapply(owner_history_list, add_service_column)
modified_owner_history_list <- lapply(modified_owner_history_list, add_groups_column)
#Bind the list of data frames back into a long data frame
modified_owner_history <- do.call(rbind, modified_owner_history_list)
#Create new .csv file
write.csv(modified_owner_history, file = "MODIFIED_OWNER_HISTORY.csv", row.names = FALSE)
