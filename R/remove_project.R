#############################################
# Remove Project function
#############################################
#############################################
# Tests

# remove_project("Lifting Stuff")

#############################################

remove_project <- function(project){
  
  # Load in the project file
  project_df <- read.csv("projects.csv", stringsAsFactors = FALSE)
  
  # Remove rows which match name and project input
  project_df <- project_df[!(project_df$project == project), ]
  
  # write new CSV
  write.csv(project_df, "projects.csv", row.names = FALSE)
  
}