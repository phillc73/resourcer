#############################################
# Unassign Resources function
#############################################
#############################################
# Tests

# remove_resource("Peck")

#############################################

unassign_resource <- function(name, project){
  
  # Load in the project file
  project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)
  
  # Remove rows which match name and project input
  project_df <- project_df[!(project_df$name == name & project_df$project == project), ]
  
  # write new CSV
  write.csv(project_df, "projects.csv", row.names = FALSE)
  
}