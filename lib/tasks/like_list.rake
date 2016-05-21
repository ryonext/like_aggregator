namespace :like_list do
  task "show" do
    twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["CONSUMER_KEY"]
      config.consumer_secret = ENV["CONSUMER_SECRET"]
      config.access_token = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end

    body = twitter.favorites(count: 10).map do |t|
      "<blockquote class='twitter-tweet' data-lang='ja'><p lang='ja' dir='ltr'>#{t.text}</p>&mdash; #{t.user.name} (@#{t.user.screen_name}) <a href='https://twitter.com/#{t.user.screen_name}/status/#{t.id}'>#{t.created_at}</a></blockquote>
      <script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script>
      <br>"
    end.join

    require "gmail"
    gmail = Gmail.new(ENV["EMAIL_ADDRESS"], ENV["GMAIL_PASSWORD"])
    message = gmail.generate_message do
      to ENV["EMAIL_ADDRESS"]
      subject "Today's like"
      html_part do
        content_type "text/html; charset=UTF-8"
        body body
      end
    end
    gmail.deliver(message)
    gmail.logout
    p body
  end
end
