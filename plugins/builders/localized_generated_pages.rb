# Bridgetown wraps resource rendering in `Site#render_with_locale`, but renders
# generated pages without it. The paginated blog index (`/en/`, `/en/page2/`, …)
# is a generated page, so without this hook it would be rendered with the
# default locale and come out in German.
class Builders::LocalizedGeneratedPages < SiteBuilder
  def build
    hook :generated_pages, :pre_render, priority: :high do |page|
      page.site.locale = page.data.locale if page.data.locale
    end

    hook :generated_pages, :post_render, priority: :low do |page|
      page.site.locale = page.site.config.default_locale
    end
  end
end
