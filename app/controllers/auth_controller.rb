require 'open-uri'

class AuthController < ApplicationController
  def facebook
    @code = params[:code]

    url = "https://graph.facebook.com/oauth/access_token?client_id=1375153749364030&redirect_uri=http://localhost:3000/auth/facebook&client_secret=73f323db75506823171bb405183b9c17&code=#{@code}"

    @result = open(url).read

    # Write some Ruby to extract the access token from that string and save it into the database under the currently signed in user (there is a column in the users table called 'facebook_access_token').

    token = @result.split("&").first.split("=").last

    u = User.find_by_id(session[:user_id])

    u.facebook_access_token = token
    u.save

    redirect_to u

  end
end












