require 'simplecov'
SimpleCov.start

SimpleCov.at_exit do
  SimpleCov.result.format!
end
