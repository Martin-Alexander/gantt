module Gantt
  require 'gantt/engine'
  class GanttConfig
    attr_accessor :load_on
    
    def self.assert_that_class_has_correct_methods(_class)
      [:name, :start, :finish, :progress, :dependencies].each do |method|
        unless _class.new.methods.include?(method)
          raise StandardError, "#{_class} should respond to `#{method.to_s}` method"
        end
      end
    end
  end

  module AsGanttTasks
    def as_gantt_tasks
      JSON.parse(self.to_a.to_json)
    end
  end

  def self.config
    config = GanttConfig.new
    yield(config)
    resource = eval(config.load_on.to_s.camelize)
    GanttConfig.assert_that_class_has_correct_methods(resource)
    
    resource.class_eval do
      def to_gantt_task
        JSON.parse(self.to_json)
      end
    end
    
    resource.class_eval do
      def self.update_from_params(params)
        tasks = JSON.parse(params[:tasks])["tasks"]
        tasks.each do |task_params|
          task = find(task_params["id"])
          task.update!({
            name: task_params["name"],
            start: Date.parse(task_params["start"]),
            finish: Date.parse(task_params["end"]),
            progress: task_params["progress"].to_i
          })
        end            
      end
    end
    ActiveRecord::Relation.send(:include, AsGanttTasks)
  end
end
