Greentime::Application.routes.draw do

	root :to => "home#index"

	scope "api" do
		resources :projects do
			resources :project_tasks
		end
		resources :clients
		resources :tasks
	end

	devise_for :users
	
	ActiveAdmin.routes(self)

end
