##
# Database config for relational db.
init = Time.now
connections = {
  :development => "postgres://localhost/tumble",
  :test => "postgres://postgres@localhost/tumble_test",
  :production => ENV['DATABASE_URL']
}

# Setup our logger
ActiveRecord::Base.logger = logger

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = true

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper.
# if you're including raw json in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Set time to UTC:
Time.zone = "UTC"
ActiveRecord::Base.default_timezone = :utc

# Now we can estabilish connection with our db
if connections[Padrino.env]
  url = URI(connections[Padrino.env])
  options = {
    :adapter => url.scheme,
    :host => url.host,
    :port => url.port,
    :database => url.path[1..-1],
    :username => url.user,
    :password => url.password
  }

  case url.scheme
  when "sqlite"
    options[:adapter] = "sqlite3"
    options[:database] = url.host + url.path
  when "postgres"
    options[:adapter] = "postgresql"
  end

  # Log what we are connecting to.
  logger.bench "DB", init, "#{options.inspect}", :devel, :green

  ActiveRecord::Base.establish_connection(options)
else
  logger.push("No database configuration for #{Padrino.env.inspect}", :fatal)
end
