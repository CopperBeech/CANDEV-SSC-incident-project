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
