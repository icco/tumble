require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-core/cli/rake'

PadrinoTasks.init

desc "Run a local server."
task :local do
  Kernel.exec("shotgun -s thin -p 9393")
end

desc "Gets new entries into all feeds."
task :cron do
  Feed.all.each do |f|
    f.get_entries
  end
end
