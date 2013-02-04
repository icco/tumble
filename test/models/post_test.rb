require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Post Model" do
  it 'can construct a new instance' do
    @post = Post.new
    refute_nil @post
  end
end
