Greentime::Application.routes.draw do

	root :to => "home#index"

	scope "api" do
		resources :administrations
	end

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
