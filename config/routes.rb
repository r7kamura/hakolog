Hakolog::Application.routes.draw do
  root :to => "blogs#index"

  resources :blogs do
    collection do
      get "login"
      get "login_callback"
      get "logout"
    end

    resources :entries do
      collection do
        get "search"
      end
    end
  end
end
