Artime::Application.routes.draw do
	
	root :to => "home#index"

	devise_for :users
	ActiveAdmin.routes(self)

	scope "api" do
		resources :clients
		resources :companies
		
		resources :projects do
			resources :project_tasks
			resources :project_users
		end
		
		resources :tasks do
			collection do
				get :last_projects_report
			end
		end

		resources :timesheets do
			collection do
				get :billable_hours
				get :tasks
			end
		end

		resources :user_sessions do
			collection do
				get :me
			end			
		end
		
		resources :users
	end
end
