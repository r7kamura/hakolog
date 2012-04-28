module ApplicationHelper
  UNICODE_MAP = {
    :top    => 9729,
    :home   => 8686,
    :edit   => 9997,
    :logout => 8998,
    :hot    => 9832,
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
end
