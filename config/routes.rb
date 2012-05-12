Hakolog::Application.routes.draw do
  root :to => "blogs#index"

  get "logout" => "blogs#logout", :as => :logout
  get "login" => "blogs#login", :as => :login
  get "login_callback" => "blogs#login_callback", :as => :login_callback

  resources :blogs, :except => %w[index show] do
    collection do
      post "preview"
      put  "preview"
    end

    resources :entries, :except => %w[index show create update] do
      collection do
        get "all"
      end
    end
  end

  opts = { :constraints => { :title => /[\s\S]+/ } }
  get    "/:username" => "blogs#show", :as => :blog
  post   "/:username" => "entries#create", :as => :blog_entries
  get    "/:username/new" => "entries#new", :as => :new_blog_entry
  get    opts.merge("/:username/:title" => "entries#show", :as => :blog_entry)
  put    opts.merge("/:username/:title" => "entries#update", :as => :blog_entry)
  delete opts.merge("/:username/:title" => "entries#destroy", :as => :blog_entry)
end
