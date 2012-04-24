class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_blog
    @current_blog ||= find_current_blog_by_session
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
  def find_current_blog_by_session
    if session[:blog_id]
      if blog = Blog.find_by_id(session[:blog_id])
        return blog
      else
        session.delete(:blog_id)
      end
    end
    if session[:dropbox]
      begin
        uid = find_dropbox_uid_by_serialized_session(session[:dropbox])
        return Blog.find_by_dropbox_id(uid)
      rescue DropboxAuthError
        session.delete(:dropbox)
      end
    end
    nil
  end

  def find_dropbox_uid_by_serialized_session(dropbox_session)
    ds     = DropboxSession.deserialize(dropbox_session)
    client = DropboxClient.new(ds, :app_folder)
    client.account_info["uid"]
  end
end
