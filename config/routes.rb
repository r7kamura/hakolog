Hakolog::Application.routes.draw do
  root :to => "blogs#index"

  get "logout" => "blogs#logout", :as => :logout
  get "login" => "blogs#login", :as => :login
  get "login_callback" => "blogs#login_callback", :as => :login_callback

  resources :blogs, :except => %w[index show] do
    collection do
      post "preview"
    end

    resources :entries, :except => %w[index show create update] do
      collection do
        get "search"
      end
    end
  end

  get "/:username" => "entries#index", :as => :blog_entries
  post "/:username" => "entries#create", :as => :blog_entry
  get "/:username/new" => "entries#new", :as => :new_blog_entry
  get "/:username/:title" => "entries#show", :as => :blog_entry
  put "/:username/:title" => "entries#update", :as => :blog_entry
  delete "/:username/:title" => "entries#destroy", :as => :blog_entry
end
