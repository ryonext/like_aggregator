namespace :like_list do
  task "show" do
    twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["CONSUMER_KEY"]
      config.consumer_secret = ENV["CONSUMER_SECRET"]
      config.access_token = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
    twitter.favorites(count: 200).each do |t|
      puts t.text
    end

    require "gmail"
    gmail = Gmail.new(ENV["EMAIL_ADDRESS"], ENV["GMAIL_PASSWORD"])
    message = gmail.generate_message do
      to ENV["EMAIL_ADDRESS"]
      subject "Today's like"
      html_part do
        content_type "text/html; charset=UTF-8"
        body "hoge"
      end
    end
    gmail.deliver(message)
    gmail.logout
  end
end
