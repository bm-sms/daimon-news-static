require "sinatra/base"
require "sinatra/json"

class App < Sinatra::Base
  get "/posts.json" do
    posts = [
      {
        id: 1,
        title: "Post1",
        body: "content..."
      },
      {
        id: 2,
        title: "Post2",
        body: "content content content..."
      },
    ]
    json posts
  end
end
