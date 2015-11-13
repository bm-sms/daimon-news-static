require "redcarpet"
require "fileutils"
require "erb"

module Daimon::News::Static::Command
  class Build
    include ERB::Util

    def exec(argv, options)
      erb = ERB.new(File.read("templates/standard/layout.html.erb"), nil, "-")
      erb.def_method(self.class, "layout", "layout.html.erb")
      FileUtils.mkdir_p("build")
      Dir.glob("source/*.md") do |markdown_file|
        renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                           fenced_code_blocks: false,
                                           tables: true,
                                           autolink: false,
                                           footnotes: false)
        html_body = renderer.render(File.read(markdown_file))
        html = layout do
          html_body
        end
        html_file_name = "#{File.basename(markdown_file, ".md")}.html"
        File.open("build/#{html_file_name}", "wb+") do |file|
          file.puts(html)
        end
      end
    end

    def css_url
    end

    def favicon_url
    end

    def javascript_url
    end

    def title
    end
  end
end
