module SassInitializer
  def self.registered(app)
    # Enables support for SASS template reloading in rack applications.
    # See http://nex-3.com/posts/88-sass-supports-rack for more details.
    #
    # Store SASS files within 'app/css'
    require 'sass/plugin/rack'
    Sass::Plugin.options[:template_location] = Padrino.root("app/css")
    Sass::Plugin.options[:css_location] = Padrino.root("public/css")
    app.use Sass::Plugin::Rack
  end
end
