# resourcer
R Package for Team Resource Management

## About

It's not even a package yet. Simply clone the repository, open resourcer.R script and load the functions. Examples/tests found at the bottom of the resourcer.R file and in the examples below.

## How to Use

`resourcer` evolved from a requirement to manage a large number of people, in multiple teams, working across multiple projects.

With `resourcer` you can:

* Add a resource (imagined as a person) to the resource list. This includes available capacity (imagined as hours per week), team affiliation and role. Resource names must be unique. The function is applied in the form of `add_resource(name, capacity, team, role)`

```r
add_resource("Smith", 40, "A-Team", "Colonel")
add_resource("Murdock", 40, "A-Team", "Captain")
add_resource("Peck", 40, "A-Team", "Lieutenant")
add_resource("BA", 40, "A-Team", "Sergeant")
```

* View all resources in the resource list, their total capacity, their team and their available capacity (hours per week). Over assigned resources show as a negative number. The returned table may be optionally ordered by any column. Resources can also be searched by name, role and total capacity. Partial matches in search are supported. The function is applied in the form of `show_resources(order_by, name, role, capacity, team)`. 

```r
show_resources()
show_resources("available_capacity")

|name    | capacity|team   |role       | available_capacity|
|:-------|--------:|:------|:----------|------------------:|
|Smith   |       40|A-Team |Colonel    |                 40|
|Murdock |       40|A-Team |Captain    |                 40|
|Peck    |       40|A-Team |Lieutenant |                 40|
|BA      |       40|A-Team |Sergeant   |                 40|

# Search by resource name
show_resources(name = "Murdock")
# Search by resource name, partial match
show_resources(name = "Murd")
# Search by research role
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

* Multiple resources may also be added to the same project. In this example, the project "Disguising" already exists, with only Murdock assigned to it. Now Peck is also addedd....

```r
assign_resource("Peck", 25, "Disguising")
```

* Update a resource already assigned to a project. Simply add them again, but with a different amount of assigned capacity. The function is applied in the form of `assign_resource(name, assigned_capacity, project)`

```r
assign_resource("Murdock", 25, "Flying")
assign_resource("Smith", 10, "Smoking")
assign_resource("BA", 15, "Lifting Stuff")
```

* View all resources assigned to various projects, including their assigned capacity to each project. Returned table may be optionally ordered by any column. Projects can also be searched by assignee name, assignee role, assignee team and project description. Partial matches in search are supported. The function is applied in the form of `show_projects(order_by, project, name, role, team)`

```r
show_projects()
show_projects(order_by = "name")
# Order by assgined capacity, in the first position
show_projects("assigned_capacity")

|   |name    |role       |team   | assigned_capacity|project      |
|:--|:-------|:----------|:------|-----------------:|:------------|
|5  |Smith   |Colonel    |A-Team |                10|Smoking      |
|1  |Murdock |Captain    |A-Team |                20|Recovering   |
|4  |Smith   |Colonel    |A-Team |                20|Disguising   |
|6  |BA      |Sergeant   |A-Team |                20|Fixing Stuff |
|2  |Murdock |Captain    |A-Team |                25|Flying       |
|3  |Peck    |Lieutenant |A-Team |                30|Persuading   |

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

* Show total amount of resources assigned to a project. Leave empty to show all project or search by specific prohect name. Partial matches in search are supported. The function is applied in the form of `velocity(project)`

```r
velocity()

|project       | total_velocity|
|:-------------|--------------:|
|Disguising    |             45|
|Fixing Stuff  |             20|
|Flying        |             25|
|Lifting Stuff |             15|
|Persuading    |             30|
|Recovering    |             20|
|Smoking       |             10|

velocity(project = "Disguising")
velocity(project = "Disg")

|project    | total_velocity|
|:----------|--------------:|
|Disguising |             45|

```

* Remove a resource from a project. The function is applied in the form of `unassign_resource(name, project)`

```r
unassign_resource("BA", "Lifting Stuff")
unassign_resource("Peck", "Disguising")
show_projects()

|   |name    |role       |team   | assigned_capacity|project      |
|:--|:-------|:----------|:------|-----------------:|:------------|
|4  |Smith   |Colonel    |A-Team |                20|Disguising   |
|6  |BA      |Sergeant   |A-Team |                20|Fixing Stuff |
|2  |Murdock |Captain    |A-Team |                25|Flying       |
|3  |Peck    |Lieutenant |A-Team |                30|Persuading   |
|1  |Murdock |Captain    |A-Team |                20|Recovering   |
|5  |Smith   |Colonel    |A-Team |                10|Smoking      |
```


* Remove a resource from the resource list. The function is applied in the form of `remove_resource(name)`. Resources need to be manually unassigned from Projects first.

```r
unassign_resource("Peck", "Persuading")
remove_resource("Peck")
show_resources()

|   |name    | capacity|team   |role     | available_capacity|
|:--|:-------|--------:|:------|:--------|------------------:|
|1  |BA      |       40|A-Team |Sergeant |                 20|
|2  |Murdock |       40|A-Team |Captain  |                 -5|
|4  |Smith   |       40|A-Team |Colonel  |                 10|
```

* Remove a project from the project list. Projects will be removed, regardless of whether resources are still assigned to them. The function is applied in the form of `remove_project(project)`

```r
remove_project("Recovering")
show_projects()

|   |name    |role     |team   | assigned_capacity|project      |
|:--|:-------|:--------|:------|-----------------:|:------------|
|2  |Smith   |Colonel  |A-Team |                20|Disguising   |
|4  |BA      |Sergeant |A-Team |                20|Fixing Stuff |
|1  |Murdock |Captain  |A-Team |                25|Flying       |
|3  |Smith   |Colonel  |A-Team |                10|Smoking      |

```

## To Do

* When removing a resource from the resource list, check they aren't still assigned to projects
* Inverse searches. i.e. "not x"
* Export a report with fancy charts and tables.




