module ApplicationHelper
  UNICODE_MAP = {
    :home   => 8682,
    :edit   => 9997,
    :logout => 8998,
  }

  def unicode(name)
    "&##{UNICODE_MAP[name]};".html_safe
  end
end
