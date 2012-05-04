Hakolog::Application.routes.draw do
  root :to => "blogs#index"

  get "logout" => "blogs#logout", :as => :logout
  get "login" => "blogs#login", :as => :login
  get "login_callback" => "blogs#login_callback", :as => :login_callback

  resources :blogs do
    collection do
      post "preview"
    end

    resources :entries do
      collection do
        get "search"
      end
    end
  end
end
