################################################
# Add new resource function
################################################
#############################################
# Tests

# assign_resource("Murdock", 20, "Recovering")
# assign_resource("Murdock", 25, "Flying")
# assign_resource("Murdock", 20, "Flying")
# assign_resource("Peck", 30, "Persuading")
# assign_resource("Smith", 20, "Disguising")
# assign_resource("Smith", 15, "Smoking")
# assign_resource("Smith", 10, "Smoking")
# assign_resource("BA", 30, "Lifting Stuff")
# assign_resource("BA", 25, "Fixing Stuff")
# assign_resource("BA", 20, "Lifting Stuff")

#############################################

add_resource <- function(name, capacity, team, role) {
  
  # Check if resources.csv file exists
  if(!file.exists("resources.csv")){
    
    # If resources.csv doesn't exist, new dataframe then create csv
    resource_df_new <- data.frame(name = character(0), capacity = numeric(0), team = character(0))
    resource_df_new <- rbind(resource_df_new, data.frame(name = name, capacity = capacity, team = team, role = role))
    write.csv(resource_df_new, "resources.csv", row.names = FALSE)
    
  } else {
    
    # If resoruces.csv does exist, read it in and append new data
    resource_df <- read.csv("resources.csv", stringsAsFactors = FALSE)
    
    # Check if the name exists in resources table
    name_match <- paste0("^",name,"$")
    if(any(grep(name_match, resource_df$name)) == TRUE){
      
      print("Resource already exists.")
      
    } else {
      resource_df <- rbind(resource_df, data.frame(name = name, capacity = capacity, team = team, role = role))
      write.csv(resource_df, "resources.csv", row.names = FALSE)
      
    }
  }
  
}