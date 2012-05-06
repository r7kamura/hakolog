class EntriesController < ApplicationController
  before_filter :prepare_blog
  before_filter :prepare_entry, :only => %w[show update destroy]
  before_filter :check_author, :only => %w[update destroy]

  def index
    @entries = @blog.entries

    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def show
    @title = @entry.title
  end

  def search
    render :partial => "entries/entries",
      :locals => { :entries => @blog.entries.search(params[:query]) }
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
      entry.post
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
        @entry.post(true)
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
    @entry ||= Entry.find_by_blog_id_and_title(@blog.id, params[:title]) or
      redirect_to blog_entries_path(@blog)
  end

  def check_author
    @entry.blog == current_blog or
      redirect_to blog_entries_path(current_blog)
  end

  # move file on Dropbox
  def move(old_path, new_path)
    client.file_move(old_path, new_path)
  end
end
