require 'bundler/setup'

Bundler.require(:default)

require 'sinatra/config_file'
require 'sinatra/reloader'

Dir[File.join(__dir__, 'lib', '*.rb')].sort.each do |file|
  require file
end

require File.join(__dir__, 'server')

run FileUploader
