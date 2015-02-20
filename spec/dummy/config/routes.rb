Rails.application.routes.draw do

  mount SwModuleInfox::Engine => "/sw_module_infox"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Searchx::Engine => '/searchx'
  #mount StateMachineLogx::Engine => '/sm_log'
  #mount BizWorkflowx::Engine => '/biz_wf'
  
  resource :session
  
  root :to => "sessions#new", controller: :authentify
  get '/signin',  :to => 'sessions#new', controller: :authentify
  get '/signout', :to => 'asessions#destroy', controller: :authentify
  get '/user_menus', :to => 'user_menus#index', controller: :main_app
  get '/view_handler', :to => 'application#view_handler', controller: :authentify
end
