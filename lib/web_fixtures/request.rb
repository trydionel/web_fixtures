module WebFixtures
  class Request

    attr_accessor :method
    attr_accessor :uri
    attr_accessor :options

    attr_accessor :input
    attr_accessor :output

    attr_accessor :username, :password

    def initialize(method, uri, options = {}, input = STDIN, output = STDOUT)
      @method = method
      @uri = uri
      @options = options

      @input = input
      @output = output
    end

    def store!
      `mkdir -p \"#{storage_path}\" && #{curl_command}`
    end

    def curl_command
      command = "curl -s"
      command << " -i" if options[:include_headers]
      command << " -u #{collect_username}:#{collect_password}" if options[:authenticate]
      command << " -X #{method.to_s.upcase}" if method != :get
      command << " -o \"#{output_file}\""
      command << " \"#{uri}\""
      command
    end

    def uri_components
      @uri_components ||= uri.split('/')
    end

    def storage_path
      root = options[:root_path] || "."
      directory = uri_components[2]

      File.join(root, directory)
    end

    def filename
      title = uri_components[3..-1].join("_")
      (title.empty? ? "root" : title) + ".txt"
    end

    def output_file
      File.join(storage_path, filename)
    end

    def collect_username
      return username if username
      return nil unless options[:authenticate]

      output.print "Username: "
      @username = input.gets.chomp
    end

    def collect_password
      return password if password
      return nil unless options[:authenticate]

      output.print "Password: "
      @password = input.gets.chomp
    end

  end
end