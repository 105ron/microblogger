require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def run
    puts "Welcome to the JSL Twitter Client!"
  end


  def tweet(message)
  	if (message.length) <= 140
      @client.update(message)
	else
	  puts "Message length greater than 140 characters"

	end
  end

end
blogger = MicroBlogger.new
blogger.tweet("MicroBlogger Initialized")

