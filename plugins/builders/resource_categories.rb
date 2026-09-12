# Generates one page per parenting resource category and locale, e.g.
# /resourcen/birthdays/ and /en/resourcen/birthdays/.
#
# This replaces the jekyll-datapage-generator plugin used before the move to
# Bridgetown. The localized fields (`title_de`/`title_en`, ...) of
# `_data/resource_categories.yaml` and `_data/resources.yaml` are flattened here
# so that `_layouts/resource.html` only ever sees `title` and `description`.
class Builders::ResourceCategories < SiteBuilder
  def build
    generator :generate_category_pages
  end

  def generate_category_pages
    site.config.available_locales.each do |loc|
      site.data.resource_categories.each do |category|
        add_category_page(category, loc)
      end
    end
  end

  private

  def add_category_page(category, loc)
    category_id = category["id"]
    page_locale = loc
    page_title = category["title_#{loc}"]
    page_description = category["description_#{loc}"]
    page_resources = resources_for(category_id, loc)
    page_seo_title = seo_title_for(page_title, loc)

    add_resource :pages, "resourcen/#{category_id}.#{loc}.html" do
      layout "resource"
      locale page_locale
      permalink "/:locale/resourcen/#{category_id}/"
      title page_title
      seo_title page_seo_title
      description page_description
      resources page_resources
    end
  end

  # A bare category name makes for a title like "Berlin | Papi Berlin", which
  # says nothing on a results page about what the page actually lists.
  def seo_title_for(title, loc)
    # "Berlin: Links für Eltern in Berlin" reads badly, so the category whose
    # name is already the city drops the locality.
    place = title.include?("Berlin") ? "" : " in Berlin"

    if loc.to_s == "en"
      "#{title}: links for parents#{place} | Papi Berlin"
    else
      "#{title}: Links für Eltern#{place} | Papi Berlin"
    end
  end

  # Resources belonging to a category, pinned ones first, each group sorted by
  # its localized title.
  #
  # @return [Array<Hash>]
  def resources_for(category_id, loc)
    matching = site.data.resources.select do |resource|
      Array(resource["categories"]).include?(category_id) ||
        Array(resource["pinned"]).include?(category_id)
    end

    pinned, regular = matching.partition do |resource|
      Array(resource["pinned"]).include?(category_id)
    end

    localize(pinned, loc, pinned: true) + localize(regular, loc)
  end

  def localize(resources, loc, pinned: false)
    resources.map do |resource|
      age = resource["age"].to_s.strip

      {
        "title" => resource["title_#{loc}"],
        "description" => resource["description_#{loc}"].to_s.strip,
        "url" => localized_url(resource["url"], loc),
        "age" => age.empty? ? nil : age,
        "lang" => resource["lang"],
        "pinned" => pinned,
      }
    end.sort_by { |resource| resource["title"].to_s.downcase }
  end

  # Links to our own pages are written as German paths (the default locale is
  # served from the root), so they need the locale prefix on the other locales.
  # External URLs are left alone.
  def localized_url(url, loc)
    return url unless url.to_s.start_with?("/")
    return url if loc.to_s == site.config.default_locale.to_s

    "/#{loc}#{url}"
  end
end
