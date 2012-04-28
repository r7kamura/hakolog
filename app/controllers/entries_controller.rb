require "tempfile"

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
    entry = Entry.create_with_title(
      :title   => params[:title],
      :body    => params[:body],
      :blog_id => @blog.id
    )
    post(entry)
    redirect_to @blog
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
end
