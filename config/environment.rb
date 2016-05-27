# Load the Rails application.
require File.expand_path('../application', __FILE__)
def truncar(n)
  ('%0.2f' % n).to_f
end

# Initialize the Rails application.
Rails.application.initialize!
