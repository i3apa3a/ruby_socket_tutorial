#!/usr/bin/env ruby -w
require "socket"
require "optparse"
class Client
  def initialize( server )
    @server = server
    @request = nil
    @response = nil
    listen
    send
    @request.join
    @response.join
  end
 
  def listen
    @response = Thread.new do
      loop {
        msg = @server.gets.chomp
        puts "#{msg}"
      }
    end
  end
 
  def send
    puts "Enter the username:"
    @request = Thread.new do
      loop {
        msg = $stdin.gets.chomp
        @server.puts( msg )
      }
    end
  end
end

OptionParser.new do |opts|
  opts.version = "0.0.1"
  $port = 1337
  # Argument must match a regular expression.
  opts.on("-p", "--port PORT") {|arg| $port = arg.to_i}
  begin
    # Parse and remove options from ARGV.
    opts.parse!
  rescue OptionParser::ParseError => error
    # Without this rescue, Ruby would print the stack trace
    # of the error. Instead, we want to show the error message,
    # suggest -h or --help, and exit 1.
 
    $stderr.puts error
    $stderr.puts "(-h or --help will show valid options)"
    exit 1
  end
end
 
server = TCPSocket.open( "localhost", $port )
Client.new( server )
