#############################################
# Show Projects function
#############################################
#############################################
# Tests

# show_projects()
# show_projects(order_by = "name")
# show_projects("assigned_capacity")
# show_projects(project = "Disguising")
# show_projects(project = "Disg")
# show_projects(project = "Disguising", name = "Smith")
# show_projects(order_by = "assigned_capacity", name = "Smith")
# show_projects(role = "Colonel")

#############################################

show_projects <- function(order_by = "project", project = "", name = "", role = "", team = "", velocity = ""){

  # If projects.csv files exists load it and show contents
  if(file.exists("projects.csv")){
    project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)

    # Apply ordering
    project_df <- project_df[with(project_df, order(eval(parse(text = order_by)))),]

    # Apply search by name
    name_match = paste0("^", name)

    if(any(grep(name_match, project_df$name)) == TRUE){

      project_df <- project_df[grep(name_match, project_df$name), ]

    } else {
      print("There are no assigned resources matching that name. Please try again.")
    }

    # Apply search by project
    project_match = paste0("^", project)

    if(any(grep(project_match, project_df$project)) == TRUE){

      project_df <- project_df[grep(project_match, project_df$project), ]

    } else {
      print("There are no projects matching that description. Please try again.")
    }

    # Apply search by team
    team_match = paste0("^", team)

    if(any(grep(team_match, project_df$team)) == TRUE){

      project_df <- project_df[grep(team_match, project_df$team), ]

    } else {
      print("There are no team names matching that value. Please try again.")
    }

    # Apply search by role
    role_match = paste0("^", role)

    if(any(grep(role_match, project_df$role)) == TRUE){

      project_df <- project_df[grep(role_match, project_df$role), ]

    } else {
      print("There are no assigned resources matching that role. Please try again.")
    }

    # Return the dataframe to print on screen
    if (requireNamespace("knitr", quietly = TRUE)) {
      knitr::kable(project_df)
    } else {
      project_df
    }

  } else {
    # If projects.csv doesn't exist, show error
    print("There are no saved projects to view.")
  }

}
