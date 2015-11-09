require "thor"

module DaimonNewsStatic
  module Generator
    class Build < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(File.dirname(__FILE__), "template", "build")
      end

      def create_files
        [
          "source/javascripts/all.js",
          "source/layouts/layout.erb",
          "source/stylesheets/all.css",
          "source/stylesheets/normalize.css",
          "source/index.html.erb",
          "source/post.template.html.erb",
          "config.rb",
          "Gemfile",
          "Gemfile.lock",
        ].each do |path|
          template("#{path}.tt",
                   "#{name}/#{path}")
        end
      end
    end
  end
end
