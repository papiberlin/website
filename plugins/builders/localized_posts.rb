# Adds `previous_in_locale` / `next_in_locale` to every post.
#
# `Resource#previous_resource` walks the whole posts collection, which under
# Bridgetown contains all locales at once. Under jekyll-polyglot the site was
# built once per language, so the prev/next links in `_layouts/post.html` never
# crossed a language boundary — this keeps that behaviour.
class Builders::LocalizedPosts < SiteBuilder
  def build
    generator :link_posts_within_locale
  end

  def link_posts_within_locale
    site.collections.posts.resources
      .group_by { |post| post.data.locale.to_sym }
      .each_value do |posts|
        ordered = posts.sort_by(&:date)

        ordered.each_with_index do |post, index|
          post.data.previous_in_locale = ordered[index - 1] if index.positive?
          post.data.next_in_locale = ordered[index + 1]
        end
      end
  end
end
