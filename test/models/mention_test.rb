require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Mention Model" do
  it 'can construct a new instance' do
    @mention = Mention.new
    refute_nil @mention
  end
end
