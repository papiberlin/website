# Keeps featured posts out of the paginator.
class Builders::FeaturedPosts < SiteBuilder
  def build
    hook :resources, :post_read do |resource|
      next unless resource.collection.label == "posts"

      resource.data.exclude_from_pagination = true if resource.data.featured
    end
  end
end
