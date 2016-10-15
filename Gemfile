source 'https://rubygems.org'

ruby '2.3.1'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'pry', '~>0.9.10'
end

group :development do
  gem 'listen', '~> 2.7.12' # prevent 2.8 and greater from being used
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'figaro'
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'faker'
end