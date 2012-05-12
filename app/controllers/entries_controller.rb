class EntriesController < ApplicationController
  before_filter :prepare_blog
  before_filter :prepare_entry, :only => %w[show update destroy]
  before_filter :check_author, :only => %w[update destroy]

  def show
    @title = @entry.title
  end

  def all
    render :partial => "blogs/entries",
      :locals => { :entries => @blog.entries.all }
  end

  def new
    @entry = Entry.new
  end

  def create
    if entry = Entry.create_by_controller(params, current_blog)
      redirect_to [current_blog, entry]
    else
      redirect_to request.referer
    end
  end

  def update
    @entry.update_by_controller(params)
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
      redirect_to @blog
  end

  def check_author
    @entry.blog == current_blog or
      redirect_to current_blog
  end
end
