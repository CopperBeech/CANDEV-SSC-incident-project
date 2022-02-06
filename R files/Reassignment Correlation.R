#Find the correlation between business completion hours and number of reassignments

#Find the overall correlation
cor.test( ~ business_completion_hours+incident_reassignments, modified_incidents)
#Find the correlations for the low, medium, and high priority incidents
cor.test( ~ business_completion_hours+incident_reassignments, modified_incidents,
          subset = (priority == "Low"))
cor.test( ~ business_completion_hours+incident_reassignments, modified_incidents,
          subset = (priority == "Medium"))
cor.test( ~ business_completion_hours+incident_reassignments, modified_incidents,
          subset = (priority == "High"))

#Create table for plotting purposes
reassignments <- modified_incidents$incident_reassignments
bus_comp_hrs <- modified_incidents$business_completion_hours
priorities <- modified_incidents$priority
cor_table <- data.frame(reassignments, bus_comp_hrs, priorities)

#Create .csv file of table
write.csv(cor_table, file = "CORRELATION_TABLE.csv", row.names = FALSE)
