library("knitr")

################################################
# Add new resource function
################################################

add_resource <- function(name, capacity, team) {
  
  # Check if resources.csv file exists
  if(!file.exists("resources.csv")){
    
    # If resources.csv doesn't exist, new dataframe then create csv
    resource_df_new <- data.frame(name = character(0), capacity = numeric(0), team = character(0))
    resource_df_new <- rbind(resource_df_new, data.frame(name = name, capacity = capacity, team = team))
    write.csv(resource_df_new, "resources.csv", row.names = FALSE)
    
  } else {
    
    # If resoruces.csv does exist, read it in and append new data
    resource_df <- read.csv("resources.csv", stringsAsFactors = FALSE)
    
    # Check if the name exists in resources table
    if(any(grepl(name, resource_df$name)) == TRUE){
      
      print("Resource already exists.")
      
    } else {
      
    resource_df <- rbind(resource_df, data.frame(name = name, capacity = capacity, team = team))
    write.csv(resource_df, "resources.csv", row.names = FALSE)
    
    }
  }
  
}

###############################################
# Assign a resource to a project function
###############################################

assign_resource <- function(name, assigned_capacity, project){
  
  # If the resources.csv files exists, load it
  if(file.exists("resources.csv")){
    
    resource_df <- read.csv("resources.csv", stringsAsFactors = FALSE)
      
    # Check if the name exists in resources table
      if(any(which(resource_df$name == name)) == TRUE){
        
        # Check if projects.csv file exists
        if(!file.exists("projects.csv")){
          
          # If projects.csv doesn't exist, new dataframe then create csv
          project_df_new <- data.frame(name = character(0), assigned_capacity = character(0), project = numeric(0))
          project_df_new <- rbind(project_df_new, data.frame(name = name, assigned_capacity = assigned_capacity, project = project))
          write.csv(project_df_new, "projects.csv", row.names = FALSE)
          
        } else {
          
          # If projects.csv does exist, read it in and append new data
          project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)

          # Update hours of any resource previously assigned to a project
         if(any(which(project_df$name == name)) && any(which(project_df$project == project)) == TRUE){

            
            print("Updating hours of previously assigned resource....")
            project_df[project_df$name == name & project_df$project == project, "assigned_capacity"] <- assigned_capacity
            
            write.csv(project_df, "projects.csv", row.names = FALSE)

            
          } else {
          
          project_df <- rbind(project_df, data.frame(name = name, assigned_capacity = assigned_capacity, project = project))
          
          write.csv(project_df, "projects.csv", row.names = FALSE)
          
          }

        }

      } else {
          # If name doesn't exist in resource table, show error
             print("Resource does not exist. Check spelling or add a resource first.")
    }
    
  } else {
    
    # If resources.csv file doesn't exist, show error
    print("There are no saved resources to assign. Please add resources before assigning to a project.")
  }
}

#############################################
# Unassign Resources function
#############################################

unassign_resource <- function(name, project){
  
  # Load in the project file
  project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)
  
  # Remove rows which match name and project input
  project_df <- project_df[!(project_df$name == name & project_df$project == project), ]
  
  # write new CSV
  write.csv(project_df, "projects.csv", row.names = FALSE)

}

#############################################
# Remove Resource function
#############################################
# Needs checks to see if name still assigned to projects

remove_resource <- function(name){
  
  # Load in the project file
  resource_df <- read.csv("resources.csv", stringsAsFactors = FALSE)
  
  # Remove rows which match name and project input
  resource_df <- resource_df[!(resource_df$name == name), ]
  
  # write new CSV
  write.csv(resource_df, "resources.csv", row.names = FALSE)
  
}

#############################################
# Show Available Resources function
#############################################

show_resources <- function(order_by = "name"){
  
  # If resources.csv files exists load it and show contents
  if(file.exists("resources.csv")){
    
  resource_df <- read.csv("resources.csv", stringsAsFactors = FALSE)
  
  # Calculate available capacity
  if(file.exists("projects.csv")){
    
    project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)
    
    # Merge resource and project dataframes by name col
    assigned_df <- merge(resource_df, project_df, by.x="name", by.y="name")
    
    # Calculate assigned capacity for unique names
    unique_assigned_df <- aggregate(assigned_df['assigned_capacity'], by=assigned_df['name'], sum)
    
    # Merge back together
    assigned_df <- merge(assigned_df, unique_assigned_df, by = "name", all.x=TRUE)

    # Calculate available capacity
    assigned_df$available_capacity <- assigned_df$capacity - assigned_df$assigned_capacity.y
    
    # Only the cold we want
    assigned_df <- assigned_df[,c("name","capacity","team", "available_capacity")]
    
    # Resources not assigned to projects
    not_assigned_df <- resource_df[!resource_df$name %in% project_df$name,]
    
    # Calculate available capacity
    not_assigned_df$available_capacity <- not_assigned_df$capacity
    
    # Combine data frames
    resource_df <- rbind(not_assigned_df, assigned_df)
    # Remove any duplicate values
    resource_df <- unique(resource_df)

    
  } else {
    
    resource_df$available_capacity <- resource_df$capacity
    
  }
  
  # Apply ordering
  resource_df <- resource_df[with(resource_df, order(eval(parse(text = order_by)))),]
  
  # Return the dataframe to print on screen
  knitr::kable(resource_df)
  
  } else {
    
    # If resources.csv doesn't exist, show error
    print("There are no saved resources to view.")
  }
  
}

#############################################
# Show Projects function
#############################################

show_projects <- function(order_by = "project"){
  
  # If projects.csv files exists load it and show contents
  if(file.exists("projects.csv")){
    project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)
    
    # Apply ordering
    project_df <- project_df[with(project_df, order(eval(parse(text = order_by)))),]
    
    # Return the dataframe to print on screen
    knitr::kable(project_df)
    
  } else {
    # If projects.csv doesn't exist, show error
    print("There are no saved projects to view.")
  }
  
}

#############################################
# Tests
#############################################

add_resource("Smith", 40, "A-Team")
add_resource("Murdock", 40, "A-Team")
add_resource("Peck", 40, "A-Team")
add_resource("BA", 40, "A-Team")

assign_resource("Murdock", 20, "Flying")
assign_resource("Murdock", 25, "Flying")
assign_resource("Peck", 30, "Persuading")
assign_resource("Smith", 20, "Disguising")
assign_resource("Smith", 15, "Smoking")
assign_resource("Smith", 10, "Smoking")
assign_resource("BA", 30, "Lifting Stuff")
assign_resource("BA", 20, "Fixing Stuff")
assign_resource("BA", 20, "Lifting Stuff")

unassign_resource("BA", "Lifting Stuff")

remove_resource("Peck")

show_resources()
show_resources("available_capacity")

show_projects()
show_projects(order_by = "name")
show_projects("assigned_capacity")


