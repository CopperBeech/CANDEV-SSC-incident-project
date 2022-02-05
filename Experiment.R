incidents <- read.csv("SSC dataset/INCIDENTS.csv", numerals = "allow.loss", col.names = c("ticket_number", 
                      "parent_service", "service", "org_id", "assigned_group", 
                      "open_date", "close_date", "priority", "status", "actual_completion_hours",
                      "business_completion_hours", "aging", "class_structure_id",
                      "class_structure", "classification_id", "classification",
                      "external_system", "global_ticket_id", "closure_code", "last_modified_date"))
test_data_frame <- merge.data.frame(incident_owner_history, incidents[, c(1, 8, 10, 11)],
                                    by = "ticket_number")
