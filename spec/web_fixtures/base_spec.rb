require 'spec_helper'

describe WebFixtures::Base do

  it { should be_a(Array) }
  its(:dsl) { should be_a(WebFixtures::DSL) }

  describe "#run!" do

    before { @file = File.join(File.dirname(__FILE__), '..', 'fixtures','google.txt') }
    subject { WebFixtures::Base.new(@file) }

    context "when given a file" do

      it "should evaluate the given file" do
        subject.dsl.should_receive(:instance_eval).
          with(File.read(@file), @file)

        subject.run!
      end

      it "should store the resulting requests" do
        subject.should_receive(:store!)

        subject.run!
      end

      it "should return 0" do
        subject.run!.should == 0
      end

      it "should return 1 on errors" do
        subject.stub!(:store!).and_raise(Exception)

        subject.run!.should == 1
      end

    end

    context "when given a block" do

      before { @block = Proc.new { get "http://www.google.com" } }
      subject { WebFixtures::Base.new(&@block) }

      it "should evaluate the given block" do
        subject.dsl.should_receive(:instance_eval)

        subject.run!
      end

      it "should store the resulting requests" do
        subject.should_receive(:store!)

        subject.run!
      end

      it "should return 0" do
        subject.run!.should == 0
      end

      it "should return 1 on errors" do
        subject.stub!(:store!).and_raise(Exception)

        subject.run!.should == 1
      end

    end

  end

  describe "#store!" do

    before(:each) do
      @stdin = StringIO.new
      @stdout = StringIO.new

      subject << WebFixtures::Request.new(:get, "http://www.google.com", { :authenticate => true }, @stdin, @stdout)
      subject << WebFixtures::Request.new(:get, "http://www.google.com", {}, @stdin, @stdout)
      subject << WebFixtures::Request.new(:get, "http://www.google.com", {}, @stdin, @stdout)

      subject[0].username = "foo"
      subject[0].password = "bar"
    end

    it "should call #store! on each of its elements" do
      subject.each { |request| request.should_receive(:store!) }
      subject.store!
    end

    it "should pass credentials along to the following requests" do
      subject[1...-1].each do |request|
        request.should_receive(:username=).with("foo")
        request.should_receive(:password=).with("bar")
      end

      subject.store!
    end

  end

end