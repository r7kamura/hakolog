Tamayura::Application.routes.draw do
  root :to => "blogs#index"

  resources :blogs do
    resources :entries
  end
end
