class BlogsController < ApplicationController
  def index
    @blogs = Blog.order("synced_at DESC").page(params[:page]).
      includes(:entries)
    require "pry"; binding.pry
  end

  def show
    @blog = Blog.find(params[:id])
    redirect_to blog_entries_path(@blog)
  end

  def create
    blog = Blog.new(
      :username        => params[:username],
      :dropbox_session => session[:dropbox],
      :dropbox_id      => uid,
      :synced_at       => Time.now
    )
    session[:blog_id] = blog.id if blog.save
    redirect_to blog
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

  def logout
    session.delete(:blog_id)
    session.delete(:dropbox)
    redirect_to :root
  end
end
