require "thor"
require "daimon_news_static/generator"
require "daimon_news_static/version"

module DaimonNewsStatic
  class Command < Thor
    register(Generator::Build, "build", "build NAME", "Build a site")

    desc "version", "Show version"
    def version
      puts(VERSION)
    end
  end
end
