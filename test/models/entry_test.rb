require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Entry Model" do
  it 'can construct a new instance' do
    @entry = Entry.new
    refute_nil @entry
  end
end
