module WebFixtures

  def self.generate(&block)
    WebFixtures::Base.new(&block)
  end

  class Base < Array

    attr_accessor :filename

    def initialize(filename = nil, &block)
      @filename = filename
      @block = block
    end

    def dsl
      @dsl ||= WebFixtures::DSL.new(self)
    end

    def run!
      if @block
        dsl.instance_eval(&@block)
      else
        dsl.instance_eval(File.read(filename), filename)
      end

      store!
      return 0
    rescue Exception
      return 1
    end

    def store!
      credentials = {}
      self.each do |request|
        request.username = credentials[:username] if credentials[:username]
        request.password = credentials[:password] if credentials[:password]

        request.store!

        credentials[:username] = request.username
        credentials[:password] = request.password
      end
    end

  end

end