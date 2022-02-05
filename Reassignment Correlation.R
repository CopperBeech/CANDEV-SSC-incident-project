#Find the correlation between business completion hours and number of reassignments

#Create vectors
reassignments <- modified_incidents$incident_reassignments
bus_comp_hrs <- modified_incidents$business_completion_hours

#Output a plot and the correlation
plot(reassignments, bus_comp_hrs)
cor.test(reassignments, bus_comp_hrs, alternative = "two.sided", method = "pearson")

##### OPTIONAL
#Now do the same for the log of the time
log_bus_comp_hrs <- log1p(bus_comp_hrs)
plot(reassignments, log_bus_comp_hrs)
cor.test(reassignments, log_bus_comp_hrs, alternative = "two.sided", method = "pearson")
