Artime::Application.routes.draw do
	
	root :to => "home#index"

	devise_for :users
	ActiveAdmin.routes(self)

	scope "api" do
		resources :clients
		resources :companies
		resources :project_task_inputs do
			collection do
				get :billable_hours
			end
		end
		resources :projects do
			resources :project_tasks
			resources :project_users
		end
		resources :tasks do
			collection do
				get :last_projects_report
			end
		end
		resources :user_sessions do
			collection do
				get :me
			end			
		end
		resources :users
		resources :users_avatar
	end
end
