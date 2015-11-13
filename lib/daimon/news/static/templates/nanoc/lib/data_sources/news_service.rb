class NewsServiceDataSource < Nanoc::DataSource
  identifier :news_service

  def items
    3.times.map do |i|
      id = i + 1
      post = {
        id: id,
        title: "post#{id}",
        body: "content" * id,
      }
      new_item(
        '',
        post,
        "/posts/#{post[:id]}",
      )
    end
  end
end
