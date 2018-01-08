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

assign_resource <- function(name, assigned_capacity, project){

  # If the resources.csv files exists, load it
  if(file.exists("resources.csv")){

    resource_df <- read.csv("resources.csv", stringsAsFactors = FALSE)

    # Check if the name exists in resources table
    if(any(which(resource_df$name == name)) == TRUE){

      # Pull in the resource's role from resource_df
      name_match = paste0("^", name)
      name_df <- resource_df[grep(name_match, resource_df$name), ]

      # Check if projects.csv file exists
      if(!file.exists("projects.csv")){

        # If projects.csv doesn't exist, new dataframe then create csv
        project_df_new <- data.frame(name = character(0), role = character(0), team = character(0), assigned_capacity = numeric(0), project = character(0))

        project_df_new <- rbind(project_df_new, data.frame(name = name, role = name_df$role, team = name_df$team, assigned_capacity = assigned_capacity, project = project))
        write.csv(project_df_new, "projects.csv", row.names = FALSE)

      } else {

        # If projects.csv does exist, read it in and append new data
        project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)

        # Update hours of any resource previously assigned to a project
        name_match <- paste0("^",name,"$")
        project_match <- paste0("^",project,"$")

        if(any(grepl(name_match, project_df$name) & grepl(project_match, project_df$project)) == TRUE) {

          print("Updating hours of previously assigned resource....")

          project_df[project_df$name == name & project_df$project == project, "assigned_capacity"] <- assigned_capacity

          write.csv(project_df, "projects.csv", row.names = FALSE)


        } else {

          project_df <- rbind(project_df, data.frame(name = name, role = name_df$role, team = name_df$team, assigned_capacity = assigned_capacity, project = project))

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
