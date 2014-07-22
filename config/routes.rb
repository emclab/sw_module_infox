SwModuleInfox::Engine.routes.draw do

  resources :module_infos do
    collection do
      get :search
      get :search_results
    end
  end
  
  resources :module_actions

end
