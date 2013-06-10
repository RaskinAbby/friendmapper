require 'open-uri'

class AuthController < ApplicationController
  def facebook
    code = params[:code]

    app_id = "1375153749364030"
    redirect_uri = "http://localhost:3000/auth/facebook"
    app_secret = "594004c7fda93757d15612b7a083dfa2"

    url = "https://graph.facebook.com/oauth/access_token?client_id=#{app_id}&redirect_uri=#{redirect_uri}&client_secret=#{app_secret}&code=#{code}"

    result = open(url).read

    # Write some Ruby to extract the access token from that string and save it into the database under the currently signed in user (there is a column in the users table called 'facebook_access_token').

    token = result.split("&").first.split("=").last

    u = User.find_by_id(session[:user_id])

    u.facebook_access_token = token

    me_url = "https://graph.facebook.com/me?fields=name,id,location&access_token=#{token}"
    me_result = JSON.parse(open(me_url).read)

    u.name = me_result["name"]
    u.facebook_id = me_result["id"]
    u.location = me_result["location"]["name"]

    u.save

    redirect_to u

  end
end












