class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def main
    @tasks = Task.all.as_gantt_tasks
  end
  
  def create
    Task.create! name: "Custom task", start: "2017-11-20", finish: "2017-11-25", progress: 50, dependencies: ""
    redirect_to root_path
  end

  def gantt_save
    Task.update_from_params(params)  
  end
end
