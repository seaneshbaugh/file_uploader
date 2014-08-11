class FileUploader < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  configure :development, :production do
    enable :logging

    file = File.new(File.join(settings.root, 'log', "#{settings.environment}.log"), 'a+')

    file.sync = true

    use Rack::CommonLogger, file
  end

  register Sinatra::ConfigFile

  config_file File.join('config', 'settings.yml')

  get '/' do
    erb :index
  end

  post '/' do
    puts

    unless params['file'] && (file = params['file'][:tempfile]) && (file_name = params['file'][:filename])
      status 400

      content_type :json

      '{ status: 400, message: "No file uploaded." }'
    end

    current_time = Time.now

    File.open(File.join(settings.upload_directory, "#{"#{current_time.to_i}#{current_time.usec}".ljust(16, '0')}-#{file_name}"), 'wb') do |f|
      f.write file.read
    end

    status 200

    content_type :json

    erb :'upload.json', layout: false
  end

  not_found do
    erb :'404', layout: false
  end

  helpers do
    def partial(template, locals = nil)
      locals = locals.is_a?(Hash) ? locals : { template.to_sym => locals }

      template = ('_' + template.to_s).to_sym

      erb template, { layout: false }, locals
    end

    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end
  end

  run! if app_file == $0
end
