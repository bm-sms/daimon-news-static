require "erb"
require "tmpdir"
require "fileutils"
require "optparse"
require "daimon/news/static/version"

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
            parser.version = VERSION

            parser.on("--template=PATH",
                      "Specify custom template path") do |path|
              options[:template_path] = path
            end
            parser.parse!(arguments)

            options
          end

          def source_root
            File.join(File.dirname(__FILE__), "..", "templates", "default")
          end

          def create_site
            Dir.mktmpdir do |tmpdir|
              generate_templates(tmpdir)
              replace_templates(tmpdir)
              FileUtils.cd(tmpdir) do
                system("bundle", "install")
                system("bundle", "exec", "middleman", "build")
              end
              true
            end
          end

          def generate_templates(tmpdir)
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
              source_path = File.join(source_root, path)
              dist_path = File.join(tmpdir, path)
              FileUtils.mkdir_p(File.dirname(dist_path))
              if File.file?("#{source_path}.erb")
                source = ERB.new(File.read("#{source_path}.erb"))
                name = @name
                build_dir = File.expand_path(@name)
                File.write(dist_path, source.result(binding))
              else
                FileUtils.cp(source_path, dist_path)
              end
            end
          end

          def replace_templates(tmpdir)
            return unless @options[:template_path]
            Dir.glob("#{@options[:template_path]}/*") do |path|
              basename = File.basename(path)
              case basename
              when "stylesheets", "stylesheet", "css"
                css_dist_path = File.join(tmpdir, "source", "stylesheets")
                FileUtils.rm_r(css_dist_path)
                FileUtils.cp_r(path, css_dist_path)
              when "javascripts", "javascript", "js"
                js_dist_path = File.join(tmpdir, "source", "javascripts")
                FileUtils.rm_r(js_dist_path)
                FileUtils.cp_r(path, js_dist_path)
              end
            end
          end
        end
      end
    end
  end
end
