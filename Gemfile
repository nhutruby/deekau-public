source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',          group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]



## Database
# User Mongo as the database
gem 'mongoid'
gem "bson"
gem "moped", github: "mongoid/moped"
gem 'redis'
## Front end
# ZURB Foundation on Sass
gem 'sprockets-rails', '2.3.3', :require => 'sprockets/railtie'
gem 'foundation-rails', '5.5.1.2'
gem 'foundation-icons-sass-rails'
gem 'marionette-rails'
gem "backbone-on-rails"
gem 'json2-rails'
gem 'haml'
gem 'haml-rails'
gem 'haml_coffee_assets'
gem 'requirejs-rails'
gem 'jquery-cookie-rails'
gem 'jquery-timepicker-rails'
gem 'autosize'
gem 'twitter-typeahead-rails' , '0.10.5'
gem 'jquery-ui-rails'

## Back end
gem 'devise'
gem 'rack-cors', :require => 'rack/cors'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'interactor'
gem 'active_model_serializers'
gem 'aws-sdk'
gem 'fog'
gem 'mini_magick'
gem 'timezone'
gem 'geocoder'
gem 'mongoid-slug'
gem 'kaminari'
gem 'enumerize'

## Performance
# gem 'newrelic_rpm'

## Development
group :development do
  gem 'yard'
  gem 'letter_opener'
  gem 'spring'
  gem 'ruby-debug-base'
  gem 'ruby-debug-ide'
end
group :development, :test do
  gem 'jasmine'
  gem 'mocha'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'mongoid-rspec'
  gem 'faker'
  gem 'selenium-webdriver'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
end

## Add
gem 'coffee-script-source', '1.8.0'
platform :jruby do
  gem 'jruby-openssl'
  gem 'torquebox', '4.0.0.beta2'
end