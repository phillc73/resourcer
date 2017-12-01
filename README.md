# resourcer
R Package for Team Resource Management

## About

It's not even a package yet. Simply clone the repository, open resourcer.R script and load the functions. Examples/tests found at the bottom of the resourcer.R file.

## How to Use

`resourcer` evolved from a requirement to manage a large number of people, in multiple teams, working across multiple projects.

With `resourcer` you can:

* Add a resource (imagined as a person) to the resource list. This includes available capacity (imagined as hours per week) and team affiliation.
* Add a resource to a project. This includes assigned capacity (hours per week) and project name. Resources may be added to multiple uniquely named projects.
* Update a resource already assigned to a project. Simply add them again, but with a different amount of assigned capacity.
* Remove a resource from a project.
* Remove a resource from the resource list.
* View all resources assigned to various projects, including their assigned capacity to each project. Returned table may be ordered by any column.
* View all resources on the resource list, their total capacity, their team and their available capacity (hours per week). Over assigned resources show as a negative number. The returned table may be ordered by any column.

## To Do

* When removing a resource from the resource list, check they aren't still assigned to projects
* Export a report with fancy charts and tables.




