require "optparse"
require "daimon/news/static/command"

module Daimon::News::Static
  class Runner
    def initilize
      @parser = OptionParser.new
    end

    def run(argv)
      command = Daimon::News::Static::Command::Build.new
      command.exec(argv, {})
    end

    def prepare
    end
  end
end
