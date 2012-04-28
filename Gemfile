source "https://rubygems.org"

gem "rails", "3.2.3"
gem "mysql2"
gem "jquery-rails"

gem "slim-rails"
gem "settingslogic"
gem "dropbox_sdk", ">= 0.0.2", :git => "git://github.com/r7kamura/dropbox_sdk.git"

group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end

group :development, :test do
  gem "pry"
end

group :development do
  gem "quiet_assets"
end

group :test do
  gem "rspec-rails"
  gem "capybara"
  gem "factory_girl_rails", "~> 3.0"
  gem "spork"
  gem "guard-spork"
  gem "guard-rspec"
  gem "growl"
  gem "webmock"
end
