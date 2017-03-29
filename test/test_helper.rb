ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'utils/custom_test_utils'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end
