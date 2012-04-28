module ApplicationHelper
  UNICODE_MAP = {
    :home   => 8682,
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
end
