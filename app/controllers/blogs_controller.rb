class BlogsController < ApplicationController
  before_filter :prepare_blog, :only => :show

  def index
    @entry   = Entry.new if current_blog
    @entries = Entry.order("modified_at DESC").
      page(params[:page]).per(13).includes(:blog)
  end

  def show
    @entries = @blog.entries
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def create
    if blog = Blog.create(
      :username        => params[:username],
      :dropbox_session => session[:dropbox],
      :dropbox_id      => uid
    ) then
      session[:blog_id] = blog.id
      redirect_to blog
    else
      redirect_to :root
    end
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
    render :partial => Entry.initialize_with_title(
      params[:entry].merge(:blog_id => current_blog)
    )
  end

  private

  def prepare_blog
    @blog ||= Blog.find_by_username(params[:username]) or
      redirect_to :root
  end
end
