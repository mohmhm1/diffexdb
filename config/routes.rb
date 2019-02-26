Rails.application.routes.draw do

  resources :transplices
  resources :transplices do
    collection {post :import}
  end
  resources :sleuths do
    collection {post :import}
  end
  resources :splices do
    collection {post :import}
  end
  resources :abundances do
    collection {post :import}
  end
  resources :samples do 
    collection {post :import}
  end

  resources :visitors
  root to: 'welcome#index'
  resources :matrix_description
  resources :paritaprevir
  resources :pipeline_description
  get 'export4', to: 'transplices#export', as: :transplices_export
  get 'export3', to: 'sleuths#export', as: :sleuths_export
  get 'export2', to: 'splices#export', as: :splices_export
  get 'export', to: 'samples#export', as: :samples_export
  get 'samples/import'
  get 'export1', to: 'abundances#export1', as: :abundances_export
  get 'abundances/import'
  get 'splices/import'
  get 'sleuths/import'
  get 'samples/import'
  get 'transplices/import'
  post 'runR' => 'abundances#runR', as: :runR
  post 'runRrace' => 'abundances#runRrace', as: :runRrace
  post 'runRstatus' => 'abundances#runRstatus', as: :runRstatus
  post 'runRkmeans_cluster' => 'abundances#runRkmeans_cluster', as: :runRkmeans_cluster
  post 'runRcoxph' => 'abundances#runRcoxph', as: :runRcoxph
  post 'runRkaplansingle' => 'abundances#runRkaplansingle', as: :runRkaplansingle
  post 'runRkaplansingle_file' => 'abundances#runRkaplansingle_file', as: :runRkaplansingle_file
  post 'runRstage' => 'abundances#runRstage', as: :runRstage
  post 'runRstage_file' => 'abundances#runRstage_file', as: :runRstage_file 
  post 'runRrace_file' => 'abundances#runRrace_file', as: :runRrace_file 
  get 'users', to: 'users#index'
end
