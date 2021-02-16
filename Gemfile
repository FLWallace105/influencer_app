source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.2'
gem 'bootsnap', '~> 1.3' # Boot large ruby/rails apps faster
# Use Puma as the app server
gem 'puma', '~> 3.7'
gem 'devise', '~> 4.4', '>= 4.4.3'
gem 'resque', '~> 1.27', '>= 1.27.4'
gem 'shopify_api', '9.2.0'
gem 'iconv', '~> 1.0', '>= 1.0.5' # translates strings between various encoding systems
gem "sinatra", ">= 2.0.2"
gem "loofah", ">= 2.2.3"
gem "sprockets", ">= 3.7.2"
gem "ffi", ">= 1.9.24"
gem "rubyzip", ">= 1.2.2"
gem "rack", ">= 2.0.6"
gem "activestorage", ">= 5.2.1.1"
#gem "activejob", ">= 5.2.1.1"
#gem "nokogiri", ">= 1.8.5"

# DATABASE:
gem 'pg', '~> 1.0'
gem 'email_validator', '~> 1.6'
gem 'strip_attributes', '~> 1.8'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'activerecord-import', '~> 1.0', '>= 1.0.4'

# FRONT END:
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1' # bootstrap-sass dependency
gem 'bootswatch-rails', '~> 3.3', '>= 3.3.5' # easy themes out of the box
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'simple_form', '~> 4.0'
gem 'kaminari', '~> 1.2' # Pagination

group :development, :test do
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'faker', '~> 1.8', '>= 1.8.7' # generates fake data
  gem 'pry-rails', '~> 0.3.6' # cause rails console to use pry
  gem 'pry-byebug', '~> 3.6' # adds step-by-step debugging features
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'timecop', '~> 0.9.1'
  gem 'bullet', '~> 5.7', '>= 5.7.5' # easily find and fix n+1 queries
end

group :development do
  gem 'better_errors', '~> 2.4'
  gem 'web-console', '>= 3.3.0' # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'binding_of_caller', '~> 0.8.0' # better errors gem dependency
  gem 'spring', '~> 2.0', '>= 2.0.2' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'listen', '>= 3.0.5', '< 3.2' # spring-watcher-listen gem dependency
  gem 'spring-commands-rspec', '~> 1.0', '>= 1.0.4'
  gem 'chromedriver-helper', '~> 1.2'
end

group :test do
  gem 'capybara', '~> 3.0', '>= 3.0.2'
  gem 'launchy', '~> 2.4', '>= 2.4.3' # enhances capybara
  gem 'selenium-webdriver', '~> 3.11'
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'
  gem 'database_cleaner', '~> 1.6', '>= 1.6.2'
  gem 'fake_ftp', '~> 0.3.0'
end

group :production do
end
