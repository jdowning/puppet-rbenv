require 'puppetlabs_spec_helper/module_spec_helper'

# future parser flag
if ENV['PARSER'] == 'future'
  RSpec.configure do |c|
    c.parser = 'future'
  end
end
