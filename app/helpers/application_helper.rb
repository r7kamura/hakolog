module ApplicationHelper
  UNICODE_MAP = {
    :top      => 9729,
    :home     => 8686,
    :edit     => 9997,
    :login    => 9111,
    :logout   => 8998,
    :hot      => 9832,
    :clock    => 8986,
    :scissors => 9986,
    :check    => 10004,
  }

  def unicode(name)
    "&##{UNICODE_MAP[name]};".html_safe
  end

  def unique_class_name
    controller.controller_name + "_" + controller.action_name
  end

  def pretty_date(datetime)
    (datetime || DateTime.new(0)).strftime("%Y-%m-%d")
  end

  def pretty_datetime(datetime)
    (datetime || DateTime.new(0)).strftime("%Y-%m-%d %H:%M")
  end

  def title_in_situation
    title = "Hakolog"
    title = "#{@blog.username}'s #{title}" if @blog.try(:username)
    title = "#{@title} - #{title}" if @title
  end
end
