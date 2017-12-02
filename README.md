# resourcer
R Package for Team Resource Management

## About

It's not even a package yet. Simply clone the repository, open resourcer.R script and load the functions. Examples/tests found at the bottom of the resourcer.R file and in the examples below.

## How to Use

`resourcer` evolved from a requirement to manage a large number of people, in multiple teams, working across multiple projects.

With `resourcer` you can:

* Add a resource (imagined as a person) to the resource list. This includes available capacity (imagined as hours per week), team affiliation and role. The function is applied in the form of `add_resource(name, capacity, team)`

```r
add_resource("Smith", 40, "A-Team", "Colonel")
add_resource("Murdock", 40, "A-Team", "Captain")
add_resource("Peck", 40, "A-Team", "Lieutenant")
add_resource("BA", 40, "A-Team", "Sergeant")
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
* Update a resource already assigned to a project. Simply add them again, but with a different amount of assigned capacity. The function is applied in the form of `assign_resource(name, assigned_capacity, project)`

```r
assign_resource("Murdock", 25, "Flying")
assign_resource("Smith", 10, "Smoking")
assign_resource("BA", 15, "Lifting Stuff")
```

* Remove a resource from a project. The function is applied in the form of `unassign_resource(name, project)`

```r
unassign_resource("BA", "Lifting Stuff")
```

* View all resources assigned to various projects, including their assigned capacity to each project. Returned table may be optionally ordered by any column. The function is applied in the form of `show_projects(order_by)`

```r
show_projects()
show_projects(order_by = "name")
show_projects("assigned_capacity")

|   |name    | assigned_capacity|project      |
|:--|:-------|-----------------:|:------------|
|4  |Smith   |                10|Smoking      |
|3  |Smith   |                20|Disguising   |
|5  |BA      |                20|Fixing Stuff |
|1  |Murdock |                25|Flying       |
|2  |Peck    |                30|Persuading   |
```


* View all resources on the resource list, their total capacity, their team and their available capacity (hours per week). Over assigned resources show as a negative number. The returned table may be optionally ordered by any column. The function is applied in the form of `show_resources(order_by)`. 

```r
show_resources()
show_resources("available_capacity")

|   |name    | capacity|team   | available_capacity|
|:--|:-------|--------:|:------|------------------:|
|3  |Peck    |       40|A-Team |                 10|
|4  |Smith   |       40|A-Team |                 10|
|2  |Murdock |       40|A-Team |                 15|
|1  |BA      |       40|A-Team |                 20|

```

* Remove a resource from the resource list. The function is applied in the form of `remove_resource(name)`

```r
remove_resource("Peck")
```

* Remove a project from the project list. The function is applied in the form of `remove_project(project)`

```r
remove_project("Recovering")
```


## To Do

* Support searching for resources by name, project, role and capacity.
* When removing a resource from the resource list, check they aren't still assigned to projects
* "Pretty" option for table output (currently only outputs as)
* Export a report with fancy charts and tables.




