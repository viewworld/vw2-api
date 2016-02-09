source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# gem 'active_model_serializers', '~> 0.10.0.rc4'
gem 'active_model_serializers'

gem 'cancancan'
# gem 'rolify'

# File attachment
gem 'paperclip'

# Payment API
gem 'braintree'

# In memory cache
gem 'redis'
gem 'redis-namespace'

# parent-children relationship
gem 'acts_as_tree'

gem 'dredd_hooks'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'uuid'
gem 'responders'
gem 'paranoia'

gem 'appsignal'

group :development, :test do
  gem 'rspec-rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  gem 'rubocop'
  gem 'brakeman', require: false
  gem 'pry-rails'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'factory_girl_rails'
end
