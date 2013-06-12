require 'open-uri'

desc "Updates all Users friends lists"
task :poll_facebook => :environment do
  User.find_each do |user|
    url = "https://graph.facebook.com/me/friends?fields=location,id,name&access_token=#{user.facebook_access_token}"

    result = JSON.parse(open(url).read)

    friends = result["data"]

    friends.map { |f| user.friends.create name: f["name"], facebook_id: f["id"], location: f["location"]["name"] if f["location"].present? }
  end
end
