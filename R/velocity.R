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

      # Calculate the velocity for all projects
      velocity_df <- aggregate(project_df['assigned_capacity'], by=project_df['project'], sum)
      colnames(velocity_df) <- c("project", "total_velocity")


    } else {
      project_match = paste0("^", project)

      if(any(grep(project_match, project_df$project)) == TRUE){

        # Calculate the velocity for individual projects
        project_df <- project_df[grep(project, project_df$project), ]
        velocity_df <- aggregate(project_df['assigned_capacity'], by=project_df['project'], sum)
        colnames(velocity_df) <- c("project", "total_velocity")
      }
    }

    # Return the dataframe to print on screen
    if (requireNamespace("knitr", quietly = TRUE)) {
      knitr::kable(velocity_df)
    } else {
      velocity_df
    }

  } else {
    # If projects.csv doesn't exist, show error
    print("There are no saved projects to view.")
  }
}
