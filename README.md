*Please don't use this on an actual production application as it has security vulerabilities*

# Installation
Add this line to your application's Gemfile:

```ruby
gem 'gantt', git: 'git://github.com/Martin-Alexander/gantt.git'
```

```bash
bundle install
```

# Configuration

Import Gantt task functionality to your model

```ruby
class Task < ActiveRecord::Base
  
  include Gantt::GanttInstanceMethods
  extend Gantt::GanttClassMethods
  
  # [...]

end
```

This gem does not have any migration generators. You will have to make sure that all tables that will be representing Gantt task object have the following columns in thier table:

```ruby
# [...]
t.string :name
t.date :start
t.date :finish
t.integer :progress
t.string :dependencies
t.string :custom_class
# [...]
```

Initialize the models which will contain the gantt task functionality:

```ruby
# config/initializers/gantt.rb

Gantt.config
```

Load JavaScript:

```javascript
// app/assests/javascripts/application.js

//= require gantt
```

# Usage

## Model


**Convert a Gantt task object into a hash**

```ruby
Task.find(3).to_gantt_task 
#=> {id: 3, name: "Task one", start: "2017-10-22", finish: "2017-11-02", progress: "50", dependencies: "1, 2"}
```

**Query the database for all Gantt tasks that have it as a dependency**

```ruby
Task.find(1).is_dependency_for
#=> <#ActiveRecord::Relation [#<Task id: 3, name ... >]>
```

**Query the database for all Gantt tasks that it is dependent on**

```ruby
Task.find(3).is_dependent_on
#=> <#ActiveRecord::Relation [#<Task id: 1, name ...>, #<Task id: 2, name ...>]>
```

**Add and remove dependencies**

```ruby
Task.find(3).remove_dependency(1)
Task.find(3).add_dependency("4")

# or

Task.find(3).remove_dependency(Task.find(1))
Task.find(3).add_dependency(Task.find(4))
```

**Converts a given query of Tasks into JSON that will be read by front-end JavaScript to generate the Gantt chart**

```ruby
# GET '/tasks'
@tasks = Task.all.as_gantt_tasks

# or

@tasks = Task.where(user: current_user).as_gantt_tasks
```

## Controller

The front-end JavaScript Gantt chart will send updates to a url of your choice as post HTTP request. To recieve these updates and apply them to the database pass the params of the request as a argument to the `Task::update_from_params` class method.

```ruby
# POST 'tasks/update'

# ID of Gantt task that was changed
@task = Task.find(params[:task_id])

Task.update_from_params(params)
```

## View

Change `form_tag` url paramater to match wherever you are updating your Gantt tasks

```erb
<svg id="gantt"></svg>

<script>
  var railsGantt = new RailsGantt("#gantt", <%= raw JSON.generate(@tasks) %>);
</script>

<%= form_tag "/gantt_save", remote: true, id: "hidden_gantt_form" do %>
  <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
  <%= hidden_field_tag :tasks, "", id: "gnatt_tasks_input"  %>
  <%= hidden_field_tag :task_changed, "", id: "task_changed_id"  %>
<% end %>
```

The `RailsGantt` contructor can be passed an optional third argument to specify the HTML structure of the info window.
