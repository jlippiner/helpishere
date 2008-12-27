require File.dirname(__FILE__) + '/../../local'
require File.dirname(__FILE__) + '/../mixins/fake_web_helper'

Local.app_id = 'myapikeyhere'

context "a new request with no options" do
  setup do
    @request = Local::Request.new
  end
  
  specify "should set defaults" do
    @request.options.each do |option|
      option.should_not_be_nil
    end
  end
  
  specify "should set results to 10" do
    @request.options[:results].should_equal 10
  end
  
  specify "should set start to 1" do
    @request.options[:start].should_equal 1
  end
  
  specify "should set sort to relevance" do
    @request.options[:sort].should_equal :relevance
  end
  
  specify "should set output to xml" do
    @request.options[:output].should_equal :xml
  end
  
end

context "a new requests path" do
  setup do
    @request = Local::Request.new
  end
  
  specify "should raise argument error without a query" do
    lambda { @request.path  }.should_raise ArgumentError
  end
  
  specify "should return a string" do
    @request.path('pizza').should_be_instance_of String
  end
  
  specify "should have query in it" do
    @request.path('pizza').should_match /pizza/
  end
  
  specify "should start with the yahoo local api url" do
    @request.path('pizza').should_starts_with 'http://local.yahooapis.com/LocalSearchService/V2/localSearch?'
  end
  
  specify "should contain your app id" do
    @request.path('pizza').should_match Regexp.new(Local.app_id)
  end
  
  specify "should contain the options" do
    @request.options.each do |key, value|
      @request.path('pizza').should_match Regexp.new(key.to_s + "=" + value.to_s)
    end
  end
end

context "a request performing a fetch" do
  include FakeWebHelper
  
  setup do
    @request = Local::Request.new
    with_fake_web(@request.path('pizza'), :file => 'local/success.xml') do
      @response = @request.fetch('pizza')
    end
  end
  
  specify "should return a response" do
    @response.should_be_instance_of Local::Response
  end
end

context "a successful new search" do
  include FakeWebHelper
  
  setup do
    @request = Local::Request.new
    with_fake_web(@request.path('pizza'), :file => 'local/success.xml') do
      @response = @request.fetch('pizza')  
    end
  end
  
  specify "should have 2 results" do
    @response.results.length.should_eql 2
  end
  
  specify "should be a success" do
    @response.should_be_success
  end
  
  specify "should not be a failure" do
    @response.should_not_be_failure
  end
  
  specify "should respond to total results" do
    @response.total_results.should_not_be_nil
  end
  
  specify "should have total results returned" do
    @response.total_returned.should_not_be_nil
  end
  
  specify "should have first position" do
    @response.first_position.should_not_be_nil
  end
end

context "an search that returned an error" do
  include FakeWebHelper
  
  setup do
    @request = Local::Request.new
    with_fake_web(@request.path('pizza'), :file => 'local/error.xml') do
      @response = @request.fetch('pizza')  
    end
  end
  
  specify "should be a failure" do
    @response.should_be_failure
  end
  
  specify "should not have any results and return an empty array" do
    @response.results.should_be_empty
  end
  
  specify "should have 0 results returned/total results/first position" do
    %w(total_results total_returned first_position).each do |method|
      @response.send(method).should_be_zero
    end
  end
end

context "a response's body" do
  include FakeWebHelper
  
  setup do
    @request = Local::Request.new
    with_fake_web(@request.path('pizza'), :file => 'local/success.xml') do
      @response = @request.fetch('pizza')  
    end
  end
  
  specify "should be a REXML element" do
    @response.body.should_be_instance_of REXML::Element
  end
  
  specify "should respond to root" do
    @response.body.should_respond_to :root
  end
end

context "a result" do
  include FakeWebHelper
  
  setup do
    @request = Local::Request.new
    with_fake_web(@request.path('pizza'), :file => 'local/success.xml') do
      @result = @request.fetch('pizza').results.first  
    end
  end
  
  specify "should have ratings" do
    @result.ratings.should_be_instance_of Local::Rating
  end
  
  specify "should respond to all result children" do
    %w(title address city state phone rating distance url clickurl mapurl businessurl businessclickurl).each do |method|
      @result.should_respond_to method
    end
  end
  
end

context "a result set" do
  include FakeWebHelper
  
  setup do
    @request = Local::Request.new
    with_fake_web(@request.path('pizza'), :file => 'local/success.xml') do
      @results = @request.fetch('pizza').results
    end
  end
  
  specify "should have one or more results" do
    @results.each do |result|
      result.should_be_instance_of Local::Result
    end
  end
end