library(ggplot2)

#Output a plot and the correlation
reassignments <- modified_incidents$incident_reassignments
bus_comp_hrs <- modified_incidents$business_completion_hours
priorities <- modified_incidents$priority
cor_table <- data.frame(reassignments, bus_comp_hrs, priorities)
cor_table <- cor_table[complete.cases(cor_table),]

ggplot(cor_table, aes(reassignments, bus_comp_hrs))+geom_point()+xlab("Reassignments")+ylab("Business Completion Hours")+ggtitle("All Incidents")
ggplot(cor_table[cor_table$priorities=="Low",], aes(reassignments, bus_comp_hrs))+geom_point(color="green")+xlab("Reassignments")+ylab("Business Completion Hours")+ggtitle("Low Priority Incidents")
ggplot(cor_table[cor_table$priorities=="Medium",], aes(reassignments, bus_comp_hrs))+geom_point(color="blue")+xlab("Reassignments")+ylab("Business Completion Hours")+ggtitle("Medium Priority Incidents")
ggplot(cor_table[cor_table$priorities=="High",], aes(reassignments, bus_comp_hrs))+geom_point(color="red")+xlab("Reassignments")+ylab("Business Completion Hours")+ggtitle("High Priority Incidents")
