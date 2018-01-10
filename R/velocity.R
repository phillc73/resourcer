#############################################
# Velocity function - shows total resource
# capacity assigned to a specific project
#############################################
#############################################
# Tests

# velocity()
# velocity(project = "Disguising")
# velocity(project = "Disg")

#############################################

velocity <- function(project = ""){

  if(file.exists("projects.csv")){

    project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)

    if(project == ""){

      # Calculate the capacity velocity for all projects
      cap_velocity_df <- aggregate(project_df['assigned_capacity'], by=project_df['project'], sum)
      colnames(cap_velocity_df) <- c("project", "capacity_velocity")

      # Calculate the weight velocity for all projects
      weight_velocity_df <- aggregate(project_df['weight'], by=project_df['project'], sum)
      colnames(weight_velocity_df) <- c("project", "weight_velocity")

      # Calculate the total velocity for all projects
      project_df$total_velocity <- project_df$assigned_capacity * project_df$weight
      total_velocity_df <- aggregate(project_df['total_velocity'], by=project_df['project'], sum)
      colnames(total_velocity_df) <- c("project", "total_velocity")

      # Merge dataframes together
      velocity_df <- merge(cap_velocity_df, weight_velocity_df, by.x = "project", by.y="project")
      velocity_df <- merge(velocity_df, total_velocity_df, by.x = "project", by.y="project")


    } else {
      project_match = paste0("^", project)

      if(any(grep(project_match, project_df$project)) == TRUE){

        # Calculate the velocity for individual project
        project_df <- project_df[grep(project, project_df$project), ]

        cap_velocity_df <- aggregate(project_df['assigned_capacity'], by=project_df['project'], sum)
        colnames(cap_velocity_df) <- c("project", "capacity_velocity")

        weight_velocity_df <- aggregate(project_df['weight'], by=project_df['project'], sum)
        colnames(weight_velocity_df) <- c("project", "weight_velocity")

        # Calculate the total velocity for inidividual project
        project_df$total_velocity <- project_df$assigned_capacity * project_df$weight
        total_velocity_df <- aggregate(project_df['total_velocity'], by=project_df['project'], sum)
        colnames(total_velocity_df) <- c("project", "total_velocity")

        # Merge dataframes together
        velocity_df <- merge(cap_velocity_df, weight_velocity_df, by.x = "project", by.y="project")
        velocity_df <- merge(velocity_df, total_velocity_df, by.x = "project", by.y="project")
      }
    }

    # Return the dataframe to print on screen
    if (requireNamespace("knitr", quietly = TRUE)) {
      knitr::kable(velocity_df, row.names = FALSE)
    } else {
      print(velocity_df, row.names = FALSE)
    }

  } else {
    # If projects.csv doesn't exist, show error
    print("There are no saved projects to view.")
  }
}
