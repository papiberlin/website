# Generates a per-locale archive page for every post category, e.g.
# /category/bibliothek/ and /en/category/library/.
#
# This replaces jekyll-archives. Bridgetown's built-in prototype pages are not
# used here because they index a collection across *all* locales, which would
# mix German and English posts under categories that exist in both languages.
#
# Posts name their category in their own language, so the German and English
# archive for one category have different titles *and* different URLs. Both are
# resolved through `_data/post_categories.yaml`, which keys every category to a
# locale-independent id; that id is what lets the two archives point at each
# other with `rel="alternate" hreflang"` (see the `alternate_key` below).
class Builders::CategoryArchives < SiteBuilder
  # Raised when a post is filed under a category that `post_categories.yaml`
  # doesn't know about — a typo, or a new category someone forgot to add.
  class UnknownCategory < StandardError; end

  def build
    generator :generate_archives
  end

  def generate_archives
    posts_by_locale_and_category.each do |(loc, category_id), posts|
      add_archive_page(loc, category_id, posts)
    end
  end

  private

  # @return [Hash{Array(Symbol, String) => Array<Bridgetown::Resource::Base>}]
  def posts_by_locale_and_category
    site.collections.posts.resources.each_with_object({}) do |post, index|
      locale = post.data.locale.to_sym

      Array(post.data.categories).each do |category|
        category_id = category_id_for(category, locale, post)
        (index[[locale, category_id]] ||= []) << post
      end
    end
  end

  # Posts were written before the ids existed and still carry the localized
  # category name, so match on that. The comparison ignores case and surrounding
  # whitespace because the names in front matter are not typed consistently
  # (`[ Kommunikation ]`, `[communication]`).
  #
  # @return [String] the id from `_data/post_categories.yaml`
  def category_id_for(category, locale, post)
    name = category.to_s.strip.downcase

    entry = site.data.post_categories.find do |candidate|
      candidate["title_#{locale}"].to_s.strip.downcase == name
    end

    unless entry
      raise UnknownCategory,
            "#{post.relative_path}: category #{category.inspect} is not listed " \
            "for locale #{locale} in _data/post_categories.yaml"
    end

    entry["id"]
  end

  def add_archive_page(loc, category_id, posts)
    category = site.data.post_categories
                   .find { |entry| entry["id"] == category_id }["title_#{loc}"]
    slug = Bridgetown::Utils.slugify(category, mode: site.config.slugify_mode)
    page_locale = loc
    page_title = category
    page_posts = posts.sort_by(&:date).reverse
    page_description = archive_description(loc, category, page_posts)
    page_seo_title = archive_seo_title(loc, category)
    # Pairs this archive with its translation for hreflang, see
    # plugins/builders/alternate_locales.rb.
    page_alternate_key = "category/#{category_id}"
    # The builder path is used to build a URI, so it has to stay ASCII even
    # though the slug in the permalink may not be (e.g. "draußen").
    path_slug = Bridgetown::Utils.slugify(category, mode: "ascii")

    add_resource :pages, "category/#{path_slug}.#{loc}.html" do
      layout "archive"
      locale page_locale
      permalink "/:locale/category/#{slug}/"
      title page_title
      seo_title page_seo_title
      description page_description
      alternate_key page_alternate_key
      posts page_posts
    end
  end

  # "Musik | Papi Berlin" says very little on a results page; spell out what the
  # archive collects instead.
  def archive_seo_title(loc, category)
    if loc.to_s == "en"
      "#{category}: articles for fathers* in Berlin | Papi Berlin"
    else
      "#{category}: Beiträge für Väter* in Berlin | Papi Berlin"
    end
  end

  # Without this every archive would fall back to the site-wide description, so
  # all twenty of them would ship the same `<meta name="description">`.
  def archive_description(loc, category, posts)
    titles = posts.first(3).map { |post| post.data.title }.join(", ")

    if loc.to_s == "en"
      "Papi Berlin articles on #{category} for fathers* and parents in Berlin: #{titles}."
    else
      "Beiträge von Papi Berlin zum Thema #{category} für Väter* und Eltern in Berlin: #{titles}."
    end
  end
end
