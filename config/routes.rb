Dubsar::Application.routes.draw do

  root :to => "home#index"

  # scene
  match "/search" => "home#search", :as => "search"
  match "/find" => "home#find", :as => "find"
  match "/view" => "home#view", :as => "view"
  match "/play" => "home#play", :as => "play"
  match "/read" => "home#read", :as => "read"
  match "/cloud" => "home#cloud", :as => "cloud"
  match "/login" => "sessions#new", :as => "login"
  match "/logout" => "sessions#destroy", :as => "logout"

  # names
  namespace :names do
    root to: "names#home"
    resources :entities
    resources :things
    resources :properties
    resources :links
  end
  
  # matters
  namespace :matters do
    root to: "matters#home"
  end
  Router.matters(self)
  
  # system
  resources :users
  resources :sessions
end
