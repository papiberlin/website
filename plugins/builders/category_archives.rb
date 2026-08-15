# Generates a per-locale archive page for every post category, e.g.
# /category/bibliothek/ and /en/category/school/.
#
# This replaces jekyll-archives. Bridgetown's built-in prototype pages are not
# used here because they index a collection across *all* locales, which would
# mix German and English posts under categories that exist in both languages.
class Builders::CategoryArchives < SiteBuilder
  def build
    generator :generate_archives
  end

  def generate_archives
    posts_by_locale_and_category.each do |(loc, category), posts|
      add_archive_page(loc, category, posts)
    end
  end

  private

  # @return [Hash{Array(Symbol, String) => Array<Bridgetown::Resource::Base>}]
  def posts_by_locale_and_category
    site.collections.posts.resources.each_with_object({}) do |post, index|
      Array(post.data.categories).each do |category|
        (index[[post.data.locale.to_sym, category]] ||= []) << post
      end
    end
  end

  def add_archive_page(loc, category, posts)
    slug = Bridgetown::Utils.slugify(category, mode: site.config.slugify_mode)
    page_locale = loc
    page_title = category
    page_posts = posts.sort_by(&:date).reverse
    # The builder path is used to build a URI, so it has to stay ASCII even
    # though the slug in the permalink may not be (e.g. "draußen").
    path_slug = Bridgetown::Utils.slugify(category, mode: "ascii")

    add_resource :pages, "category/#{path_slug}.#{loc}.html" do
      layout "archive"
      locale page_locale
      permalink "/:locale/category/#{slug}/"
      title page_title
      posts page_posts
    end
  end
end
