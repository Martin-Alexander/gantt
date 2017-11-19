# Installation
Add this line to your application's Gemfile:

```ruby
gem 'gantt', git: 'git://github.com/Martin-Alexander/gantt.git'
```

```bash
bundle install
```

# Configuration

The table representing the gantt task must contain the following in a migration:

```ruby
t.string :name
t.date :start
t.date :finish
t.integer :progress
t.string :dependencies
```

Initialize the models which will contain the gantt task functionality:

```ruby
# config/initializers/gantt.rb

Gantt.config do |config|
  config.load_on = [:name_of_gantt_task_model]
end
```

Load JavaScript:

```javascript
// app/assests/javascripts/application.js

//= require gantt
```

# Usage

## Model

```ruby
# Convert a Gantt task object into a hash

Task.find(3).to_gantt_task 
#=> {id: 3, name: "Task one", start: "2017-10-22", finish: "2017-11-02", progress: "50", dependencies: "1, 2"}

# Query the database for all Gantt tasks that have it as a dependency

Task.find(1).is_dependency_for
#=> <#ActiveRecord::Relation [#<Task id: 3, name ... >]>

# Query the database for all Gantt tasks that it is dependent on

Task.find(3).is_dependent_on
#=> <#ActiveRecord::Relation [#<Task id: 1, name ...>, #<Task id: 2, name ...>]>

# Add and remove dependencies

Task.find(3).remove_dependency(1)
Task.find(3).add_dependency("4")

# or

Task.find(3).remove_dependency(Task.find(1))
Task.find(3).add_dependency(Task.find(4))
```

## Controller

Converts a given query of Tasks into JSON that will be read by front-end JavaScript to generate the Gantt chart

```ruby
# GET '/tasks'
@tasks = Task.all.as_gantt_tasks

# or

@tasks = Task.where(user: current_user).as_gantt_tasks
```

Recieves input from front-end JavaScript Gantt chart and applies updates on the database

```ruby
# POST 'tasks/update'
Task.update_from_params(params)
```

## View

Change `form_tag` url paramater to match wherever you are updating your Gantt tasks

```html
<svg id="gantt"></svg>

<script>
  var railsGantt = new RailsGantt("#gantt", <%= raw JSON.generate(@tasks) %>);
</script>

<%= form_tag "/gantt_save", remote: true, id: "hidden_gantt_form" do %>
  <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
  <%= hidden_field_tag :tasks, "", id: "gnatt_tasks_input"  %>
<% end %>
```
