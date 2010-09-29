require 'spec_helper'

describe WebFixtures::Request do

  before(:each) do
    @stdin = StringIO.new
    @stdout = StringIO.new
  end

  subject do
    WebFixtures::Request.new(:get, 'http://www.google.com/translate', {}, @stdin, @stdout)
  end

  it "should build the storage path based on the URI domain" do
    subject.storage_path.should == "./www.google.com"
  end

  it "should build the filename based on the URI path" do
    subject.filename.should == "translate.txt"
  end

  it "should build the output file from the storage path and filename" do
    subject.output_file.should == './www.google.com/translate.txt'
  end

  describe "#collect_username" do

    it "should return nil if not authenticating" do
      subject.collect_username.should be_nil
    end

    context "when authenticating" do

      before(:each) do
        subject.options = { :authenticate => true }
      end

      it "should return the username if one is set" do
        subject.username = "foo"
        subject.collect_username.should == "foo"
      end

      it "should request a username from the user if one isn't set" do
        @stdin.should_receive(:gets).and_return("bar\n")
        subject.collect_username
      end

      it "should return the user input after requested" do
        @stdin << "bar"
        @stdin.rewind
        subject.collect_username

        subject.username.should == "bar"
      end

    end

  end
  
  describe "#data_string" do
    
    it "should map the data elements into key=value format" do
      subject.options = { :data => { :foo => "foo" } }
      subject.data_string.should == "foo=foo"
    end
    
    it "should join the data elements" do
      subject.options = { :data => { :foo => "foo", :bar => "bar" } }
      subject.data_string.should match /(foo=foo|bar=bar)\&(foo=foo|bar=bar)/ # messy way to handle (lack-of) hash ordering
    end
    
    it "should url-encode the data elements" do
      subject.options = { :data => { :foo => "f o o" } }
      subject.data_string.should == "foo=f+o+o"
    end
    
  end

  describe "#collect_password" do

    it "should return nil if not authenticating" do
      subject.collect_password.should be_nil
    end

    context "when authenticating" do

      before(:each) do
        subject.options = { :authenticate => true }
      end

      it "should return the password if one is set" do
        subject.password = "foo"
        subject.collect_password.should == "foo"
      end

      it "should request a password from the user if one isn't set" do
        @stdin.should_receive(:gets).and_return("bar\n")
        subject.collect_password
      end

      it "should return the user input after requested" do
        @stdin << "bar\n\n"
        @stdin.rewind
        subject.collect_password

        subject.password.should == "bar"
      end

    end

  end

  describe "#store!" do

    it "should ensure the output path exists before getting the URI" do
      subject.store!.should include('mkdir -p "./www.google.com"')
    end

    it "should include the curl command" do
      subject.store!.should include(subject.curl_command)
    end

  end

  describe "#curl_command" do

    it "should always include -s" do
      subject.curl_command.should include('-s')
    end

    it "should should not include -i when not including headers" do
      subject.curl_command.should_not include('-i')
    end

    it "should include -i when including headers" do
      subject.options = { :include_headers => true }
      subject.curl_command.should include('-i')
    end

    it "should not include -u when authenticating" do
      subject.curl_command.should_not include('-u')
    end

    it "should include -u user:pass when authenticating" do
      subject.options = { :authenticate => true }
      subject.username = "foo"
      subject.password = "bar"

      subject.curl_command.should include('-u foo:bar')
    end
    
    it "should include -d key=val when passing data" do
      subject.options = { :data => { :foo => "foo" } }
      subject.curl_command.should include('-d foo=foo')
    end

    it "should not include -X for GET requests" do
      subject.curl_command.should_not include('-X GET')
    end

    it "should include -X for non-GET requests" do
      subject.method = :post
      subject.curl_command.should include('-X POST')
    end

    it "should include -o output_file" do
      subject.curl_command.should include('-o "./www.google.com/translate.txt"')
    end

    it "should include the url" do
      subject.curl_command.should include("http://www.google.com/translate")
    end

  end

end