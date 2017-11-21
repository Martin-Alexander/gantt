class Task < ActiveRecord::Base
	include Gantt::GanttInstanceMethods
	extend Gantt::GanttClassMethods
end