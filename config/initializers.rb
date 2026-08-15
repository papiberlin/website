# This configuration file is for settings which affect the whole site.
#
# For technical reasons, this file is *NOT* reloaded automatically when you use
# `bin/bridgetown start`. If you change this file, please restart the server.
#
# For reloadable site metadata like title, SEO description, etc. take a look at
# `src/_data/site_metadata.yml`.

Bridgetown.configure do |config|
  url "https://papiberlin.de"

  template_engine "liquid"

  timezone "Europe/Berlin"

  # German is served from the root, English from /en/.
  available_locales [:de, :en]
  default_locale :de
  prefix_default_locale false

  # Pages and posts get trailing-slash "pretty" URLs.
  permalink "pretty"

  collections do
    posts do
      permalink "/:locale/pages/:slug/"
    end
  end

  pagination do
    enabled true
    per_page 12
    permalink "/page:num/"
  end

  # bridgetown-paginate registers itself on require, it has no initializer.
  init :"bridgetown-sitemap"
end
