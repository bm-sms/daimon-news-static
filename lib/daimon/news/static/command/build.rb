require "erb"
require "tmpdir"
require "fileutils"
require "optparse"

module Daimon
  module News
    module Static
      module Command
        class Build
          USAGE = "Usage: #{$0} SITE_NAME"

          class << self
            def run(*arguments)
              new.run(arguments)
            end
          end

          def initialize
          end

          def run(arguments)
            @options = parse_options(arguments)
            if arguments.size < 1
              $stderr.puts("#{$0}: missing site name")
              $stderr.puts(USAGE)
              return false
            end
            @name = arguments.shift
            create_site
          end

          private
          def parse_options(arguments)
            options = {}

            parser = OptionParser.new("#{$0} SITE_NAME")

            parser.parse!(arguments)

            options
          end

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
