require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Identity Model" do
  it 'can construct a new instance' do
    @identity = Identity.new
    refute_nil @identity
  end
end
