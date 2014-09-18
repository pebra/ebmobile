# require 'susy'
# compass_config do |config|
#   config.output_style = :compact
# end

page "index.html", :layout => false
Slim::Engine.set_default_options :pretty => true
set :slim, :layout_engine => :slim

# page "/path/to/file.html", :layout => :otherlayout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

# activate :automatic_image_sizes
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  set :build_dir, '../www'
  activate :minify_css
  activate :minify_javascript, compressor:  Uglifier.new( mangle: false), ignore: ['js/app', 'bower_components']
  # Enable cache buster
  # activate :cache_buster
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  # Or use a different image path
  # set :http_path, "/Content/images/"
end



activate :relative_assets

after_configuration do
  sprockets.append_path File.join(root, 'bower_components')
end
