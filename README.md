# resourcer

[![Build Status](https://travis-ci.org/phillc73/resourcer.svg?branch=master)](https://travis-ci.org/phillc73/resourcer)

R Package for Team Resource Management


## About

This package can be used to define team resources and assign them to projects. 

When resources are added, their overall available capacity is also defined. These resources may then be assigned to projects, with a specific allocated capacity. Resources may be added to multiple projects.

Resources may be viewed, showing their available and unassigned capacity. Projects may also be viewed, showing which resources are assigned to them.

Projects and resources may be searched by name.


### Install

```r
# install.packages("devtools")
devtools::install_github("phillc73/resourcer")
library("resourcer")
```

Examples/tests found in each R file and in the examples below. Manual pages and vignette still to be written.

This package has no dependencies, although [knitr](https://yihui.name/knitr/) is suggested for producing prettier tables.


## How to Use

`resourcer` evolved from a requirement to manage a large number of people, in multiple teams, working across multiple projects.

With `resourcer` you can:

* Add a resource (imagined as a person) to the resource list. This includes available capacity (imagined as hours per week), team affiliation, role and weight. Weight is a concept of value. The higher the weight, the higher value assigned to the resource. Resource names must be unique. The function is applied in the form of `add_resource(name, capacity, team, role, weight)`

```r
add_resource("Smith", 40, "A-Team", "Colonel", 5)
add_resource("Murdock", 40, "A-Team", "Captain", 4)
add_resource(name = "Peck", capacity = 40, team = "A-Team", role = "Lieutenant", weight = 3)
add_resource(name = "BA", capacity = 40, team = "A-Team", role = "Sergeant", weight = 2)
```

* View all resources in the resource list, their total capacity, their team, their available capacity (hours per week) and their weight. Over assigned resources show available capacity as a negative number. The returned table may be optionally ordered by any column. Default ordering is alphabetical by name. Resources can also be searched by name, role and total capacity. Partial matches in search are supported. The function is applied in the form of `show_resources(order_by, name, role, capacity, team)`. 

```r
show_resources()
show_resources("available_capacity")
show_resources(order_by = "weight")

|name    | capacity|team   |role       | weight| available_capacity|
|:-------|--------:|:------|:----------|------:|------------------:|
|Smith   |       40|A-Team |Colonel    |      5|                 40|
|Murdock |       40|A-Team |Captain    |      4|                 40|
|Peck    |       40|A-Team |Lieutenant |      3|                 40|
|BA      |       40|A-Team |Sergeant   |      2|                 40|

# Search by resource name
show_resources(name = "Murdock")
# Search by resource name, partial match
show_resources(name = "Murd")
# Search by resource role
show_resources(role = "Sergeant")
# Search by capacity
show_resources(capacity = 40)
# Search by team
show_resources(team = "A-Team")

```

* Add a resource to a project. This includes assigned capacity (hours per week) and project name. Resources may be added to multiple uniquely named projects. The function is applied in the form of `assign_resource(name, assigned_capacity, project)`

```r
assign_resource("Murdock", 20, "Recovering")
assign_resource("Murdock", 20, "Flying")
assign_resource("Peck", 30, "Persuading")
assign_resource("Smith", 20, "Disguising")
assign_resource("Smith", 15, "Smoking")
assign_resource("BA", 30, "Lifting Stuff")
assign_resource("BA", 20, "Fixing Stuff")

```

* View all resources assigned to various projects, including their assigned capacity to each project. Returned table may be optionally ordered by any column. Projects can also be searched by assignee name, assignee role, assignee team and project description. Partial matches in search are supported. The function is applied in the form of `show_projects(order_by, project, name, role, team)`

```r
show_projects()
show_projects(order_by = "name")
# Order by assgined capacity, in the first position
show_projects("assigned_capacity")

|name    |role       |team   | assigned_capacity|project       |
|:-------|:----------|:------|-----------------:|:-------------|
|Smith   |Colonel    |A-Team |                15|Smoking       |
|Murdock |Captain    |A-Team |                20|Recovering    |
|Murdock |Captain    |A-Team |                20|Flying        |
|Smith   |Colonel    |A-Team |                20|Disguising    |
|BA      |Sergeant   |A-Team |                20|Fixing Stuff  |
|Peck    |Lieutenant |A-Team |                30|Persuading    |
|BA      |Sergeant   |A-Team |                30|Lifting Stuff |

# Search by project description
show_projects(project = "Disguising")
# Search by project description, partial match
show_projects(project = "Disg")
# Search by project description and assignee name
show_projects(project = "Disguising", name = "Smith")
# Order by assigned capacity and search by assignee name
show_projects(order_by = "assigned_capacity", name = "Smith")
# Search by assignee role within projects
show_projects(role = "Colonel")
# Search by assignee team within projects
show_projects(team = "A-Team")

```

* Multiple resources may also be added to the same project. In this example, the project "Disguising" already exists, with only Murdock assigned to it. Now Peck is also added....

```r
assign_resource("Peck", 25, "Disguising")
show_projects(project = "Disguising")

|name  |role       |team   | assigned_capacity|project    |
|:-----|:----------|:------|-----------------:|:----------|
|Smith |Colonel    |A-Team |                20|Disguising |
|Peck  |Lieutenant |A-Team |                25|Disguising |

```

* Update a resource already assigned to a project. Simply add them again, but with a different amount of assigned capacity. The function is applied in the form of `assign_resource(name, assigned_capacity, project)`

```r
assign_resource("Murdock", 25, "Flying")
assign_resource("Smith", 10, "Smoking")
assign_resource("BA", 15, "Lifting Stuff")
show_projects()

|name    |role       |team   | assigned_capacity|project       |
|:-------|:----------|:------|-----------------:|:-------------|
|Smith   |Colonel    |A-Team |                20|Disguising    |
|Peck    |Lieutenant |A-Team |                25|Disguising    |
|BA      |Sergeant   |A-Team |                20|Fixing Stuff  |
|Murdock |Captain    |A-Team |                25|Flying        |
|BA      |Sergeant   |A-Team |                15|Lifting Stuff |
|Peck    |Lieutenant |A-Team |                30|Persuading    |
|Murdock |Captain    |A-Team |                20|Recovering    |
|Smith   |Colonel    |A-Team |                10|Smoking       |

```

* Show total amount of resources assigned to a project. Leave empty to show all projects or search by specific project name. Capacity velocity is the sum of all resources' assigned capacity to that project. Weight velocity is the sum of all resources' assigned weights to that project. Total velocity is the sum of the individual products of all resources' assigned capacity and weight to that project. Partial matches in search are supported. The function is applied in the form of `velocity(project)`

```r
velocity()

|project       | capacity_velocity| weight_velocity| total_velocity|
|:-------------|-----------------:|---------------:|--------------:|
|Disguising    |                45|               8|            175|
|Fixing Stuff  |                20|               2|             40|
|Flying        |                25|               4|            100|
|Lifting Stuff |                15|               2|             30|
|Persuading    |                30|               3|             90|
|Recovering    |                20|               4|             80|
|Smoking       |                10|               5|             50|

velocity(project = "Disguising")
velocity(project = "Disg")

|project    | capacity_velocity| weight_velocity| total_velocity|
|:----------|-----------------:|---------------:|--------------:|
|Disguising |                45|               8|            175|

```

* Remove a resource from a project. The function is applied in the form of `unassign_resource(name, project)`

```r
unassign_resource("BA", "Lifting Stuff")
unassign_resource("Peck", "Disguising")
show_projects()

|name    |role       |team   | assigned_capacity|project      |
|:-------|:----------|:------|-----------------:|:------------|
|Smith   |Colonel    |A-Team |                20|Disguising   |
|BA      |Sergeant   |A-Team |                20|Fixing Stuff |
|Murdock |Captain    |A-Team |                25|Flying       |
|Peck    |Lieutenant |A-Team |                30|Persuading   |
|Murdock |Captain    |A-Team |                20|Recovering   |
|Smith   |Colonel    |A-Team |                10|Smoking      |

```

* Remove a resource from the resource list. The function is applied in the form of `remove_resource(name)`. Resources need to be manually unassigned from Projects first.

```r
unassign_resource("Peck", "Persuading")
remove_resource("Peck")
show_resources()

|name    | capacity|team   |role     | weight| available_capacity|
|:-------|--------:|:------|:--------|------:|------------------:|
|BA      |       40|A-Team |Sergeant |      2|                 20|
|Murdock |       40|A-Team |Captain  |      4|                 -5|
|Smith   |       40|A-Team |Colonel  |      5|                 10|

```

* Remove a project from the project list. Projects will be removed, regardless of whether resources are still assigned to them. The function is applied in the form of `remove_project(project)`

```r
remove_project("Recovering")
show_projects()

|name    |role     |team   | assigned_capacity|project      |
|:-------|:--------|:------|-----------------:|:------------|
|Smith   |Colonel  |A-Team |                20|Disguising   |
|BA      |Sergeant |A-Team |                20|Fixing Stuff |
|Murdock |Captain  |A-Team |                25|Flying       |
|Smith   |Colonel  |A-Team |                10|Smoking      |

```

## To Do

* When removing a resource from the resource list, check they aren't still assigned to projects
* Inverse searches. i.e. "not x"
* Export a report with fancy charts and tables.




