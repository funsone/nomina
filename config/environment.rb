# Load the Rails application.
require File.expand_path('../application', __FILE__)
def truncar(n)
  if -0.005<=n and n<=0.005
    return 0
  else
    if n<0
    (n + 0.005).round(2)
    else
    (n - 0.005).round(2)
    end
  end
end

# Initialize the Rails application.
Rails.application.initialize!
