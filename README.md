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

Initialize the model which will contain the gantt task functionality:

```ruby
# config/initializers/gantt.rb

Gantt.config do |config|
  config.load_on = :name_of_gantt_task_model
end
```

Load JavaScript:

```javascript
// app/assests/javascripts/application.js

//= require gantt
```

# Usage

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
