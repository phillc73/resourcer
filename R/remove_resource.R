#############################################
# Unassign Resources function
#############################################
#############################################
# Tests

# remove_resource("Peck")

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
