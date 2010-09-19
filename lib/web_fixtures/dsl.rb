module WebFixtures
  class DSL

    attr_accessor :base
    attr_accessor :default_options

    @@default_options = {
      :include_headers => true,
      :authenticate    => false,
      :root_path       => "./fixtures"
    }

    def initialize(base, options = {})
      @base = base
      @default_options = @@default_options.merge(options)
    end

    def include_headers(choice)
      default_options[:include_headers] = choice
    end

    def authenticate(choice)
      default_options[:authenticate] = choice
    end

    def storage_path(path)
      default_options[:root_path] = path
    end

    def get(url, options = {})
      add_request(:get, url, options)
    end

    def post(url, options = {})
      add_request(:post, url, options)
    end

    def put(url, options = {})
      add_request(:put, url, options)
    end

    def delete(url, options = {})
      add_request(:delete, url, options)
    end

  private

    def add_request(method, url, options)
      base << WebFixtures::Request.new(method, url, default_options.merge(options))
    end

  end
end