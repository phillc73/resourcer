#############################################
# Show Available Resources function
#############################################
#############################################
# Tests

# show_resources()
# show_resources(order_by = "name")
# show_resources("available_capacity")
# show_resources("weight")
# show_resources(name = "Murdock")
# show_resources(name = "Murd")
# show_resources(role = "Sergeant")
# show_resources(capacity = 40)

#############################################

show_resources <- function(order_by = "name", name = "", role = "", capacity = "", team = ""){

  # If resources.csv files exists load it and show contents
  if(file.exists("resources.csv")){

    resource_df <- read.csv("resources.csv", stringsAsFactors = FALSE)

    # Apply search by name
    name_match = paste0("^", name)

    if(any(grep(name_match, resource_df$name)) == TRUE){

      resource_df <- resource_df[grep(name_match, resource_df$name), ]

    } else {
      print("There are no resources matching that name. Please try again.")
    }

    # Apply search by role
    role_match = paste0("^", role)

    if(any(grep(role_match, resource_df$role)) == TRUE){

      resource_df <- resource_df[grep(role_match, resource_df$role), ]

    } else {
      print("There are no resources matching that role. Please try again.")
    }

    # Apply search by capacity
    capacity_match = paste0("^", capacity)

    if(any(grep(capacity_match, resource_df$capacity)) == TRUE){

      resource_df <- resource_df[grep(capacity_match, resource_df$capacity), ]

    } else {
      print("There are no resources matching that capacity value. Please try again.")
    }

    # Apply search by team
    team_match = paste0("^", team)

    if(any(grep(team_match, resource_df$team)) == TRUE){

      resource_df <- resource_df[grep(team_match, resource_df$team), ]

    } else {
      print("There are no team names matching that value. Please try again.")
    }

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

      # Only the cols we want
      assigned_df <- assigned_df[,c("name","capacity", "team.x", "role.x", "weight.x", "available_capacity")]
      names(assigned_df) <- c("name", "capacity", "team", "role", "weight", "available_capacity")

      # Resources not assigned to projects
      not_assigned_df <- resource_df[!resource_df$name %in% project_df$name,]

      # Calculate available capacity
      not_assigned_df$available_capacity <- not_assigned_df$capacity

      # Combine data frames
      resource_df <- rbind(not_assigned_df, assigned_df)
      # Remove any duplicate values
      resource_df <- unique(resource_df)


    } else {

      # If not assigned, available capacity equals total capacity
      resource_df$available_capacity <- resource_df$capacity

    }

    # Apply ordering
    if(order_by == "weight"){
      # Heighest weights first
      resource_df <- resource_df[with(resource_df, order(-eval(parse(text = order_by)))),]
    } else {
    resource_df <- resource_df[with(resource_df, order(eval(parse(text = order_by)))),]
    }

    # Return the dataframe to print on screen
    if (requireNamespace("knitr", quietly = TRUE)) {
      knitr::kable(resource_df, row.names = FALSE)
    } else {
      print(resource_df, row.names = FALSE)
    }

  } else {

    # If resources.csv doesn't exist, show error
    print("There are no saved resources to view.")
  }

}
