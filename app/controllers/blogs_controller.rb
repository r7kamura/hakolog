class BlogsController < ApplicationController
  def index
    @entry   = Entry.new if current_blog
    @entries = Entry.order("modified_at DESC").
      page(params[:page]).per(13).includes(:blog)
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
    redirect_to ds.get_authorize_url(url_for(:login_callback))
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

  def preview
    render :partial => Entry.initialize_with_title(params[:entry])
  end
end
