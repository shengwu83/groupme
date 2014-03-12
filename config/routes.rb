Groupme::Application.routes.draw do
  devise_for :users
	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
	root :to => "groups#index"
	resources :groups do
		resources :posts 
	end
end
