source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'apipie-rails'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'knock'
gem 'multi_json'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'representable'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'dry-monads', '~> 1.3'
gem 'dry-system', '~> 0.12'
gem 'dry-transaction', '~> 0.13.0'
gem 'dry-validation', '~> 1.3'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 5.0.1'
  gem 'rspec-its', '~> 1.2', require: false
  gem 'rspec-rails', '~> 3.8.2'
  gem 'rubocop', '~> 0.66.0', require: false
  gem 'rubocop-rspec', '~> 1.30', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end