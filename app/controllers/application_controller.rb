class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_blog
    @current_blog ||= find_current_blog
  end
  helper_method :current_blog

  def login?
    session[:dropbox].present?
  end
  helper_method :login?

  private

  # 1. find by session[:blog_id]
  # 2. find by session[:dropbox]
  # unnecessary session will be removed after searching
  def find_current_blog
    if session[:blog_id]
      if blog = Blog.find_by_id(session[:blog_id])
        return blog
      else
        session.delete(:blog_id)
      end
    end
    if session[:dropbox]
      begin
        return Blog.find_by_dropbox_id(uid)
      rescue DropboxAuthError
        session.delete(:dropbox)
      end
    end
    nil
  end

  # Dropbox client
  def client
    ds     = DropboxSession.deserialize(session[:dropbox])
    client = DropboxClient.new(ds, :app_folder)
  end

  # Dropbox user id
  def uid
    client.account_info["uid"]
  end
end
