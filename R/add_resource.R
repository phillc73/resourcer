################################################
# Add new resource function
################################################
#############################################
# Tests

# add_resource("Smith", 40, "A-Team", "Colonel", 5)
# add_resource("Murdock", 40, "A-Team", "Captain", 4)
# add_resource(name = "Peck", capacity = 40, team = "A-Team", role = "Lieutenant", weight = 3)
# add_resource(name = "BA", capacity = 40, team = "A-Team", role = "Sergeant", weight = 2)

#############################################

add_resource <- function(name, capacity, team, role, weight) {

  # Check if resources.csv file exists
  if(!file.exists("resources.csv")){

    # If resources.csv doesn't exist, new dataframe then create csv
    resource_df_new <- data.frame(name = character(0),
                                  capacity = numeric(0),
                                  team = character(0),
                                  role = character(0),
                                  weight = numeric(0))

    resource_df_new <- rbind(resource_df_new, data.frame(name = name,
                                                         capacity = capacity,
                                                         team = team,
                                                         role = role,
                                                         weight = weight))

    write.csv(resource_df_new, "resources.csv", row.names = FALSE)

  } else {

    # If resoruces.csv does exist, read it in and append new data
    resource_df <- read.csv("resources.csv", stringsAsFactors = FALSE)

    # Check if the name exists in resources table
    name_match <- paste0("^",name,"$")
    if(any(grep(name_match, resource_df$name)) == TRUE){

      print("Resource already exists.")

    } else {
      resource_df <- rbind(resource_df, data.frame(name = name,
                                                   capacity = capacity,
                                                   team = team,
                                                   role = role,
                                                   weight = weight))

      write.csv(resource_df, "resources.csv", row.names = FALSE)

    }
  }

}
