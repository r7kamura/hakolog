class ApplicationController < ActionController::Base
  protect_from_forgery

  # find blog by session
  def current_blog
    @current_blog ||= begin
      if session[:blog_id]
        Blog.find_by_id(session[:blog_id])
      elsif session[:dropbox]
        Blog.find_by_dropbox_id(get_uid)
      end
    end
  end
  helper_method :current_blog

  private

  # find Dropbox user id by serialized session
  def get_uid(dropbox_session)
    ds     = DropboxSession.deserialize(dropbox_session)
    client = DropboxClient.new(ds, :app_folder)
    client.account_info["uid"]
  end
end
