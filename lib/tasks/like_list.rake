require "gmail"
namespace :like_list do
  task "show" do
    twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["CONSUMER_KEY"]
      config.consumer_secret = ENV["CONSUMER_SECRET"]
      config.access_token = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end

    html = <<"HTML"
<table>
  <tr>
    <th>User</th>
    <th>Tweet</th>
    <th>Created at</th>
  </tr>
HTML

    include ActionView::Helpers::DateHelper

    html += twitter.favorites(count: 10).map do |t|
      <<"HTML"
<tr>
  <td>#{t.user.name} (@#{t.user.screen_name})</td>
  <td>#{t.text}</td>
  <td>#{time_ago_in_words(t.created_at)} ago</td>
</tr>
HTML
    end.join
    html += "</table>"

    gmail = Gmail.new(ENV["EMAIL_ADDRESS"], ENV["GMAIL_PASSWORD"])
    message = gmail.generate_message do
      to ENV["EMAIL_ADDRESS"]
      subject "Today's like"
      html_part do
        content_type "text/html; charset=UTF-8"
        body html
      end
    end
    gmail.deliver(message)
    gmail.logout
  end
end
