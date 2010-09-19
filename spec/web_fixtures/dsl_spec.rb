require 'spec_helper'

describe WebFixtures::DSL do

  before(:each) do
    @base = WebFixtures::Base.new
  end

  subject do
    WebFixtures::DSL.new(@base)
  end

  it "#include_headers should set the :include_headers option" do
    subject.include_headers true
    subject.default_options[:include_headers].should be_true
  end

  it "#authenticate should set the :authenticate option" do
    subject.authenticate true
    subject.default_options[:authenticate].should be_true
  end

  it "#storage_path should set the :root_path option" do
    subject.storage_path './foo/bar'
    subject.default_options[:root_path].should == "./foo/bar"
  end

  [:get, :post, :put, :delete].each do |method|

    describe "##{method}" do

      it "should build a new request object" do
        WebFixtures::Request.should_receive(:new).
          with(method,
            "http://www.google.com",
            subject.default_options)

        subject.send method, "http://www.google.com"
      end

      it "should add the request to the base" do
        expect {
          subject.send method, "http://www.google.com"
        }.to change(@base, :size).by(1)
      end

      it "should allow overrides for default options" do
        WebFixtures::Request.should_receive(:new).
          with(method,
            "http://www.google.com",
            hash_including(:authenticate => true))

        subject.send method, "http://www.google.com", :authenticate => true
      end

    end

  end

end
