module NewsServiceHelper
  def posts
    @items.find_all("/data_sources/news_service/posts/*")
  end

  def generate_posts
    posts.each do |post|
      attributes = {
        title: post[:title],
      }
      @items.create(
        post[:body],
        attributes,
        Nanoc::Identifier.new("/posts/#{post[:id]}"),
      )
      @items.delete_if do |item|
        item[:id] == post[:id]
      end
    end
  end
end
