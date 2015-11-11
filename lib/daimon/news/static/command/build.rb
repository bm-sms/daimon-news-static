require "erb"
require "tmpdir"
require "fileutils"

module Daimon
  module News
    module Static
      module Command
        class Build
          class << self
            def run(*arguments)
              new.run(arguments)
            end
          end

          def initialize
          end

          def run(arguments)
            @name = arguments.shift
            create_site
          end

          private
          def source_root
            File.join(File.dirname(__FILE__), "..", "templates", "default")
          end

          def create_site
            Dir.mktmpdir do |dir|
              generate_templates(dir)
              FileUtils.cd(dir) do
                system("middleman", "build")
              end
              FileUtils.mv(File.join(dir, "build"), @name)
            end
          end

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
              source_path = File.join(source_root, "#{path}.tt")
              source = ERB.new(File.read(source_path))
              dist_path = File.join(dir, path)
              FileUtils.mkdir_p(File.dirname(dist_path))
              File.write(dist_path, source.result)
            end
          end
        end
      end
    end
  end
end
