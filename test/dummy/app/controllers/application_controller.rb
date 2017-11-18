class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def main
    @tasks = Task.all.as_gantt_tasks
  end
end
