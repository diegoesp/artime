Greentime::Application.routes.draw do

	root :to => "home#index"

	scope "api" do
		resources :projects do
			resources :project_tasks
			resources :project_users
		end
		resources :clients
		resources :tasks do
			collection do
				get :last_projects_report
			end

		end
		resources :users
	end

	devise_for :users
	
	ActiveAdmin.routes(self)

end
