class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def main
    @tasks = Task.all.as_gantt_tasks
  end
  
  def gantt_save
    Task.update_from_params(params)  
  end
end
