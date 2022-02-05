incidents <- read.csv("SSC dataset/INCIDENTS.csv", numerals = "allow.loss", col.names = c("ticket_number", 
                      "parent_service", "service", "org_id", "assigned_group", 
                      "open_date", "close_date", "priority", "status", "actual_completion_hours",
                      "business_completion_hours", "aging", "class_structure_id",
                      "class_structure", "classification_id", "classification",
                      "external_system", "global_ticket_id", "closure_code", "last_modified_date"))

modified_incidents <- cbind(incidents[, c(1, 3, 4, 5, 8, 10, 11)], incident_reassignments)

incidents_by_service <- split.data.frame(modified_incidents, modified_incidents$service)

mean_actual_hours <- function(dat){
  mean_actual_hrs <- mean(dat$actual_completion_hours, na.rm =TRUE)
  return(mean_actual_hrs)
}

mean_business_hours <- function(dat){
  mean_business_hrs <- mean(dat$business_completion_hours, na.rm =TRUE)
  return(mean_business_hrs)
}

mean_actual_time_by_service <- sapply(incidents_by_service, mean_actual_hours)
mean_business_time_by_service <- sapply(incidents_by_service, mean_business_hours)

mean_service_times <- cbind.data.frame(mean_actual_time_by_service, mean_business_time_by_service)
