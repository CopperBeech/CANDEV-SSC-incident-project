test_data_frame <- merge.data.frame(incident_owner_history, incidents[, c(1, 8, 10, 11)],
                                    by = "ticket_number")