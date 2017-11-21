Rails.application.routes.draw do
  root to: "application#main"
  post "/gantt_save", to: "application#gantt_save"
  get "/create", to: "application#create", as: "create"
end
