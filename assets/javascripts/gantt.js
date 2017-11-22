//= require snap
//= require moment
//= require frappe-gnatt

var RailsGantt = function(element, taskJSON, customPopup) {
  var formattedTasks = function(tasks) {
    tasks.forEach(function(task) {
      task.end = task.finish;
      task.id = task.id.toString();
      delete task.finish;
    });
    return tasks;
  }

  this.tasks = formattedTasks(taskJSON);
  this.create(element, customPopup);
}

RailsGantt.prototype.sendToServer = function(idOfChangedTask) {
  document.getElementById("gnatt_tasks_input").setAttribute("value", JSON.stringify({tasks: this.tasks}));
  document.getElementById("task_changed_id").setAttribute("value", idOfChangedTask)
  document.getElementById("hidden_gantt_form").submit();	
}

RailsGantt.prototype.create = function(element, customPopup) {
  var self = this;
  if (customPopup) { 
    var custom_popup_html = customPopup; 
  } else {
    var custom_popup_html = function(task) {
      return "<div class='details-container'>" +
          "<h5>${task.name}</h5>" +
          "<p>Expected to finish by ${task._end.format('MMM D')}</p>" +
          "<p>${task.progress}% completed!</p>" +
        "</div>";
    }		
  }
  this.gantt = new Gantt(element, this.tasks, {
    on_date_change: function(changed_task, start, end) {
      self.tasks.forEach(function(task) {
        if (task.id === changed_task.id) {
          task.end = end["_d"].getFullYear() + "-" + (end["_d"].getMonth() + 1) + "-" + end["_d"].getDate();
          task.start = start["_d"].getFullYear() + "-" + (start["_d"].getMonth() + 1) + "-" + start["_d"].getDate();
        }
      });
      self.sendToServer(changed_task.id);
    },
    on_progress_change: function(changed_task, start, end) {
      self.sendToServer(changed_task.id);
    },
    custom_popup_html: custom_popup_html
  });
}