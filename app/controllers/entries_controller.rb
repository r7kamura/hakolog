class EntriesController < ApplicationController
  before_filter :prepare_blog

  def index
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def new
  end

  def create
    Entry.create(
      :title   => params[:title],
      :body    => params[:body],
      :blog_id => @blog.id
    )
    redirect_to @blog
  end

  private

  def prepare_blog
    @blog = Blog.find_by_id(params[:blog_id]) or redirect_to :root
  end
end
