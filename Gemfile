source 'http://rubygems.org'

# Temp fix for: uninitialized constant Spree::User::DestroyWithOrdersError until v1.0.1
gem 'spree', :git => 'https://github.com/spree/spree.git'

group :test do
  gem 'ffaker'
end

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19"
end

gemspec
