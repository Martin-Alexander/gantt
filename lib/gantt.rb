module Gantt
  require 'gantt/engine'

  module GanttActiveRecordRelationMethods

    # Turns as active record relation into an array of hashes
    def as_gantt_tasks
      JSON.parse(self.to_a.to_json)
    end
  end
	
  module GanttClassMethods

    # Expects the params sent by gantt chart javascript and updates all
    # gantt task objects in the database with the new information that 
    # it recieved
    def update_from_params(params)
      tasks = JSON.parse(params[:tasks])["tasks"]
      tasks.each do |task_params|
        task = find(task_params["id"])
        task.update!({
          name: task_params["name"],
          start: Date.parse(task_params["start"]),
          finish: Date.parse(task_params["end"]),
          progress: task_params["progress"].to_i,
          custom_class: task_params["custom_class"]
        })
      end            
    end
  end

  module GanttInstanceMethods

    # Converts a gantt task object into a hash
    def to_gantt_task
      JSON.parse(self.to_json)
    end

    # Queries for all gantt tasks that depend on it
    def is_dependency_for
      key = id
      self.class.where(
        "dependencies LIKE ? OR dependencies LIKE ? OR dependencies LIKE ? OR dependencies LIKE ?",
        "#{key}",
        "#{key},%",
        "%, #{key},%",
        "%, #{key}"
      )		
    end

    # Queries for all gantt tasks that it depends on
    def is_dependent_on
      return self.class.none if dependency_ids.empty?
      query_string = (["id = ?"] * dependency_ids.length).join(" OR ")

      # Yes, I know this is really really bad
      eval("#{self.class}.where(\"#{query_string}\", #{dependency_ids.join(", ")})")
    end

    # Adds a dependency (accepts gantt task ojects or ids)
    def add_dependency(gantt_task)
      new_id = if gantt_task.class == self.class 
        gantt_task.id.to_s
      else 
        self.class.find(gantt_task).id.to_s
      end
			
      raise(
        StandardError, 
        "Cannot add dependency. #{self} already has #{self.class.find(gantt_task)} as a dependency"
      ) if dependency_ids.include?(new_id)

      raise(
        StandardError,
        "Cannot add self as a dependency"
      ) if new_id.to_i == id

      new_dependency_ids = dependency_ids << new_id
      update!(dependencies: new_dependency_ids.join(", "))
    end

    # Removes a dependency (accepts gantt task ojects or ids)
    def remove_dependency(gantt_task)
      id_to_be_deleted = if gantt_task.class == self.class
        gantt_task.id.to_s
      else
        self.class.find(gantt_task).id.to_s
      end
			
      raise(
        StandardError,
        "Cannot remove dependency. #{self} does not have #{self.class.find(gantt_task)} as a dependency"
      ) if !dependency_ids.include?(id_to_be_deleted)

      new_dependency_ids = dependency_ids
      new_dependency_ids.delete(id_to_be_deleted)
      update!(dependencies: new_dependency_ids.join(", "))
    end

    private

    # Returns an array of dependency ids as strings
    def dependency_ids
      dependencies.split(",").map(&:strip)
    end
  end

  class GanttConfig
    attr_accessor :load_on
    
    def self.assert_that_class_has_correct_methods(_class)
      [:name, :start, :finish, :progress, :dependencies, :custom_class].each do |method|
        unless _class.new.methods.include?(method)
          raise StandardError, "#{_class} should respond to `#{method.to_s}` method"
        end
      end
    end
  end

  def self.config
    # config = GanttConfig.new
    # yield(config)

    ActiveRecord::Relation.send(:include, GanttActiveRecordRelationMethods)

    # config.load_on.each do |class_symbol|
      # resource = eval(class_symbol.to_s.camelize)
      # GanttConfig.assert_that_class_has_correct_methods(resource)
      # resource.send(:include, GanttInstanceMethods)
      # resource.send(:extend, GanttClassMethods)
    # end
  end
end
