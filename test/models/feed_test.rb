require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Feed Model" do
  it 'can construct a new instance' do
    @feed = Feed.new
    refute_nil @feed
  end
end
