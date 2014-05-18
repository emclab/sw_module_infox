SwModuleInfox::Engine.routes.draw do
  resources :module_infos do
    collection do
      get :search
      put :search_results
    end
  end

end
