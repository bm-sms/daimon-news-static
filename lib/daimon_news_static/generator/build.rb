require "thor"
require "tmpdir"
require "fileutils"

module DaimonNewsStatic
  module Generator
    class Build < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.join(File.dirname(__FILE__), "template", "build")
      end

      def create_site
        Dir.mktmpdir do |dir|
          generate_templates(dir)
          FileUtils.cd(dir) do
            system("middleman", "build")
          end
          FileUtils.mv(File.join(dir, "build"), name)
        end
      end

      private
      def generate_templates(dir)
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
                   "#{dir}/#{path}")
        end
      end
    end
  end
end
