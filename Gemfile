source 'http://rubygems.org'

# Temp fix until v1.1.0
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
