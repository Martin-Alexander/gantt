class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

	def main
		puts Task.first.is_dependency_for
    @tasks = Task.all.as_gantt_tasks
  end
  
  def gantt_save
    Task.update_from_params(params)  
  end
end
