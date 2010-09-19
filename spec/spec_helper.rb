$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'web_fixtures'
require 'spec'
require 'spec/autorun'

# Prevent `cmd` from actually executing
module Kernel
  def `(cmd)
    cmd
  end
end

Spec::Runner.configure do |config|
  
end
