require "tempfile"

class EntriesController < ApplicationController
  before_filter :prepare_blog

  def index
    @entry_count = Entry.count(:conditions => {:blog_id => @blog.id})
    @entries = params[:random] ?
      @blog.random_entries.page(params[:page]) :
      @blog.entries.page(params[:page])
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def create
    if entry = Entry.create_with_title(
        :title   => params[:title],
        :body    => params[:body],
        :blog_id => @blog.id
      ) then
      post(entry)
      @blog.synced_at = Time.now
      @blog.save
      redirect_to @blog
    else
      redirect_to request.referer
    end
  end

  def update
    entry = Entry.where(
      :blog_id => current_blog.id,
      :id      => params[:id]
    ).first
    if entry
      old_path = entry.path
      if entry.update_with_title(
        :title => params[:title],
        :body  => params[:body],
      ) && entry.path != old_path then
        rename(old_path, entry.path)
      end
    end
    redirect_to request.referer
  end

  private

  def prepare_blog
    @blog = Blog.find_by_id(params[:blog_id]) or redirect_to :root
  end

  # create file on Dropbox
  def post(entry)
    temp = Tempfile.new("")
    temp.write(entry.body)
    temp.close
    open(temp.path) { |file|
      client.put_file(entry.path, file, false)
    }
  end

  # rename file on Dropbox
  def rename(old_path, new_path)
    client.file_move(old_path, new_path)
  end
end
