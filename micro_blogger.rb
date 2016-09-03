require 'jumpstart_auth'
require 'bitly'
Bitly.use_api_version_3

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def run
    command = ""
    while command != "q"
      printf "Enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'spam' then spam_my_followers(parts[1..-1].join(" "))
        when 'elt' then everyones_last_tweet 
        when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
        when 'loop' then spam_tweets(parts[1], parts[2..-1].join(" "))
        else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end


  def dm(target, message)
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
    if screen_names.include?(target)
      puts "Trying to send #{target} this direct message:"
      puts message
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "You can only direct message people who follow you."
    end
  end

  def spam_tweets(times, message)
    times = times.to_i
    iterations = 0
    while iterations < times do
      tweet(message)
      sleep(10)
      iterations +=1
    end
  end

  def followers_list
    screen_names = Array.new
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
    return screen_names
  end


  def spam_my_followers(message)
    followers_list.each do |client|
      dm(client, message)
    end
  end


  def tweet(message)
  	if (message.length) <= 140
      @client.update(message)
	  else
	    puts "Message length greater than 140 characters"
    end
  end


  def everyones_last_tweet #Error with this method.
   friends = @client.friends.sort_by { |friend| friend.screen_name.downcase }
    friends.each do |friend|
      timestamp = friend.status.created_at
      puts "#{friend.screen_name.upcase} (#{timestamp.strftime("%b %d")}): #{friend.status.text}"
    end
  end

def shorten(original_url)
  bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
  puts "Shortening this URL: #{original_url}"
  bitly.shorten(original_url).short_url
end


end
blogger = MicroBlogger.new
blogger.run


