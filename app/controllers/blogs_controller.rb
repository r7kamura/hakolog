class BlogsController < ApplicationController
  def index
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def create
    blog = Blog.new(
      :username        => params[:username],
      :dropbox_session => session[:dropbox],
      :dropbox_id      => uid
    )
    session[:blog_id] = blog.id if blog.save
    redirect_to :root
  end

  def login
    ds = DropboxSession.new(Setting.consumer_key, Setting.consumer_secret)
    session[:dropbox] = ds.serialize
    abs_url = url_for(:login_callback_blogs)
    redirect_to ds.get_authorize_url(abs_url)
  rescue NoMethodError
    redirect_to :root
  end

  def login_callback
    ds = DropboxSession.deserialize(session[:dropbox])
    ds.get_access_token
    session[:dropbox] = ds.serialize
    redirect_to :root
  end
end
