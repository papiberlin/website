# Makes `resource.summary` return the first paragraph of a post rather than its
# first line, which is what Jekyll's `post.excerpt` used to give the post cards
# in `_components/postbox.liquid`. Several posts hard-wrap their paragraphs, so
# "first line" would cut them off mid-sentence.
class Builders::Excerpts < SiteBuilder
  def build
    define_resource_method :summary_extension_output do
      untransformed_content.to_s.strip.split(%r{\n[ \t]*\n}).first.to_s.strip
    end
  end
end
