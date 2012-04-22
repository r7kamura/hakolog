class BlogsController < ApplicationController
  def index
  end

  def show
  end

  def login
    ds = DropboxSession.new(Setting.consumer_key, Setting.consumer_secret)
    session[:dropbox] = ds.serialize
    redirect_to ds.get_authorize_url(login_callback_blogs_path)
  rescue NoMethodError
    # please set correct consumer key and secret
    redirect_to :blogs
  end

  def login_callback
    ds = DropboxSession.deserialize(session[:dropbox])
    ds.get_access_token
    session[:dropbox] = ds.serialize
    redirect_to :blogs
  end
end
