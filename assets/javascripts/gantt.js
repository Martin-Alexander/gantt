//= require snap
//= require moment
//= require frappe-gnatt

var RailsGantt = function(element, taskJSON) {
	this.tasks = formattedTasks(taskJSON);
	this.create(element);
}

var formattedTasks = function(tasks) {
	tasks.forEach(function(task) {
		task.end = task.finish;
		task.id = task.id.toString();
		delete task.finish;
	});
	return tasks;
}

RailsGantt.prototype.create = function(element) {
	this.gantt = new Gantt(element, this.tasks);
}