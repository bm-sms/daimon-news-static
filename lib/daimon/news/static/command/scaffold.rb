require "erb"
require "tmpdir"
require "fileutils"
require "optparse"
require "daimon/news/static/version"

module Daimon
  module News
    module Static
      module Command
        class Scaffold
          USAGE = "Usage: #{$0} OUTPUT_PATH [SITE_NAME]"

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
              $stderr.puts("#{$0}: missing output path")
              $stderr.puts(USAGE)
              return false
            end
            @output_path = arguments.shift
            @name = arguments.shift || "daimon-news"
            Dir.mktmpdir do |tmpdir|
              scaffold_user_assets_dir(tmpdir)
              FileUtils.mv(File.join(tmpdir, "source"), @output_path)
            end
          end

          private
          def parse_options(arguments)
            options = {}

            parser = OptionParser.new("#{$0} SITE_NAME")
            parser.version = VERSION

            parser.parse!(arguments)

            options
          end

          def source_root
            File.join(File.dirname(__FILE__), "..", "templates", "default")
          end

          def scaffold_user_assets_dir(tmpdir)
            [
              "source/javascripts/all.js",
              "source/layouts/layout.erb",
              "source/stylesheets/all.css",
              "source/stylesheets/normalize.css",
            ].each do |path|
              source_path = File.join(source_root, path)
              dist_path = File.join(tmpdir, path)
              FileUtils.mkdir_p(File.dirname(dist_path))
              if File.file?("#{source_path}.erb")
                source = ERB.new(File.read("#{source_path}.erb"))
                name = @name
                File.write(dist_path, source.result(binding))
              else
                FileUtils.cp(source_path, dist_path)
              end
            end
          end
        end
      end
    end
  end
end
