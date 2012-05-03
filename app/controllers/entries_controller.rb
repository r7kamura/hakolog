require "tempfile"

class EntriesController < ApplicationController
  before_filter :prepare_blog

  def index
    @entries = params[:random] ?
      @blog.random_entries.page(params[:page]) :
      @blog.entries.page(params[:page])
  end

  def show
    @entry = Entry.find(params[:id])
    @title = @entry.title
  end

  def search
    @entries = @blog.entries.search(params[:query]).page(params[:page])
    render :action => :index
  end

  def new
    @entry = Entry.new
  end

  def create
    if entry = Entry.create_with_title(
      :title   => params[:entry][:title],
      :body    => params[:entry][:body],
      :blog_id => current_blog.id
    ) then
      post(entry)
      current_blog.synced_at = Time.now
      current_blog.save
      redirect_to [current_blog, entry]
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
        :title => params[:entry][:title],
        :body  => params[:entry][:body],
      ) then
        move(old_path, entry.path) if entry.path != old_path
        post(entry, true)
      end
    end
    redirect_to [current_blog, entry]
  end

  def destroy
    entry = Entry.find(params[:id])
    entry.destroy
    redirect_to entry.blog
  end

  private

  def prepare_blog
    @blog = Blog.find_by_id(params[:blog_id]) or redirect_to :root
  end

  # create file on Dropbox
  def post(entry, overwrite = false)
    temp = Tempfile.new("")
    temp.write(entry.body)
    temp.close
    open(temp.path) { |file|
      client.put_file(entry.path, file, overwrite)
    }
  end

  # move file on Dropbox
  def move(old_path, new_path)
    client.file_move(old_path, new_path)
  end
end
