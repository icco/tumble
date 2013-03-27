require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:activerecord)
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

desc "Uses API to get all old entries for pinboard."
task :pinboard do

  Entry.transaction do
    feed = Feed.where("url LIKE '%pinboard%'").first
    posts = Pinboard::Post.all(:username => ENV['PINBOARD_USER'], :password => ENV['PINBOARD_PASSWORD'])

    posts.each do |item|
      p item
      e = Entry.find_or_create_by_url item.href
      e.feed = feed
      e.title = item.description
      e.date = item.time
      e.raw = item.to_json
      e.save
    end
  end
end

desc "Download and install pg data."
task :pgdown do
  puts "heroku pgbackups:capture --expire"
  puts "curl -o latest.dump `heroku pgbackups:url`"
  puts "pg_restore --verbose --clean --no-acl --no-owner -h localhost -d tumble latest.dump"
end
