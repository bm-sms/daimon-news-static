require "stringio"
require "daimon/news/static/command/build"

class CommandBuildTest < Test::Unit::TestCase
  def setup
    @command = Daimon::News::Static::Command::Build.new
    @stdout_string = ""
    @stderr_string = ""
    stdout_io = StringIO.new(@stdout_string)
    stderr_io = StringIO.new(@stderr_string)
    $stdout = stdout_io
    $stderr = stderr_io
  end

  def teardown
    $stdout = STDOUT
    $stderr = STDERR
  end

  def test_usage
    @command.run([])
    assert_equal(<<-END_OF_FILE, @stderr_string)
#{$0}: missing site name
Usage: #{$0} SITE_NAME
    END_OF_FILE
  end
end
