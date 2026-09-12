# Pairs up the translations of every resource so that `_layouts/default.html`
# can emit `rel="alternate" hreflang="…"` links and a working language switcher.
#
# Two resources are considered translations of each other when their URLs match
# once the locale prefix is stripped, which is how bridgetown-sitemap groups them
# for the sitemap's `xhtml:link` alternates. German is served from the root, so
# `/pages/kids-radio/` pairs with `/en/pages/kids-radio/`.
#
# Where that does not hold — the category archives, whose slugs are translated
# category names — a resource can set `alternate_key` in its data to name the
# pair explicitly.
#
# Every resource gets:
#   `alternate_urls`      – Hash of locale => relative URL, including itself.
#   `alternate_other_url` – the relative URL of the *other* locale, or nil.
#   `x_default_url`       – the relative URL Google should treat as `x-default`.
class Builders::AlternateLocales < SiteBuilder
  def build
    generator :link_alternate_locales
  end

  def link_alternate_locales
    grouped = localized_resources.group_by { |resource| pairing_key(resource) }

    grouped.each_value do |group|
      urls = group.to_h { |resource| [resource.data.locale.to_s, url_for(resource)] }
      next if urls.size < 2

      group.each do |resource|
        locale = resource.data.locale.to_s
        resource.data.alternate_urls = urls
        resource.data.alternate_other_url = urls.except(locale).values.first
        resource.data.x_default_url = urls[default_locale] || url_for(resource)
      end
    end
  end

  private

  def default_locale
    @default_locale ||= site.config.default_locale.to_s
  end

  # @return [Array<Bridgetown::Resource::Base>]
  def localized_resources
    site.collections.values
        .select { |collection| collection.metadata.fetch("output", false) }
        .flat_map(&:resources)
        .select { |resource| resource.data.locale }
  end

  # What makes two resources translations of each other. Most pages are matched
  # on their URL, but a resource whose translation lives at an unrelated URL can
  # name the pair itself through `alternate_key` — the category archives do,
  # because their slugs are the translated category names.
  #
  # @return [String]
  def pairing_key(resource)
    key = resource.data.alternate_key.to_s
    key.empty? ? base_path(resource) : key
  end

  # The German home page has `permalink: /`, which comes back out of
  # `relative_url` as `//`. Left alone that would never match `/en/`, and as an
  # href it would read as a protocol-relative URL.
  #
  # @return [String]
  def url_for(resource)
    resource.relative_url.to_s.squeeze("/")
  end

  # The resource's URL with its locale prefix removed, so that translations of
  # the same page collapse onto one key. Matching a whole path segment matters:
  # a naive prefix strip would turn the German `/datenschutz/` into `nschutz/`.
  #
  # @return [String]
  def base_path(resource)
    url_for(resource).sub(%r{\A/#{resource.data.locale}(/|\z)}, "/")
  end
end
