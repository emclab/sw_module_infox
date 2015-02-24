Rails.application.routes.draw do

  mount SwModuleInfox::Engine => "/sw_module_infox"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Searchx::Engine => '/searchx'
  #mount StateMachineLogx::Engine => '/sm_log'
  #mount BizWorkflowx::Engine => '/biz_wf'
  
  #resource :session
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/asessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
