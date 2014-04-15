Greentime::Application.routes.draw do

	root :to => "home#index"

	scope "api" do
		resources :projects
	end

	devise_for :users
	
	ActiveAdmin.routes(self)

end
