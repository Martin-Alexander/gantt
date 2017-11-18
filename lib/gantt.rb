module Gantt
  require 'gnatt/engine'
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

    ActiveRecord::Relation.send(:include, AsGanttTasks)
  end
end
