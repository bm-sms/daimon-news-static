require "sinatra/base"
require "sinatra/json"

class App < Sinatra::Base
  get "/posts.json" do
    posts = [
      {
        title: "Post1",
        body: "content..."
      },
      {
        title: "Post2",
        body: "content content content..."
      },
    ]
    json posts
  end
end
