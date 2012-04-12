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
    resources :entity_names,  :path => "entities", :as => "entities"
    resources :thing_names,   :path => "things", :as => "things"
    resources :property_names, :path => "properites", :as => "properties"
    resources :property_links, :path => "links", :as => "links"
  end
  
  # matters
  namespace :matters do
    root to: "matters#home"
  end
  Router.apply(self)
  
  # system
  resources :users
  resources :sessions
end
