require "tempfile"

class EntriesController < ApplicationController
  before_filter :prepare_blog
  before_filter :prepare_entry, :only => %w[show update destroy]

  def index
    @entries = @blog.entries
  end

  def show
    @title = @entry.title
  end

  def search
    entries = @blog.entries.search(params[:query])
    render :partial => "entries/entries",
      :locals => { :entries => entries }
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
    if @entry && @entry.blog_id == current_blog.id
      old_path = @entry.path
      if @entry.update_with_title(
        :title => params[:entry][:title],
        :body  => params[:entry][:body],
      ) then
        move(old_path, @entry.path) if @entry.path != old_path
        post(@entry, true)
      end
    end
    redirect_to [current_blog, @entry]
  end

  def destroy
    @entry.destroy
    redirect_to @entry.blog
  end

  private

  def prepare_blog
    @blog ||= Blog.find_by_username(params[:username]) or
      redirect_to :root
  end

  def prepare_entry
    @entry ||= Entry.find_by_title(params[:title]) or
      redirect_to blog_entries_path(@blog)
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
