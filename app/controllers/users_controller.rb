require 'open-uri'

class UsersController < ApplicationController
  before_filter :require_authorized_user, only: [:show, :edit, :update, :destroy]

  def poll_facebook
    # TODO move this stuff to a model somewhere
    url = "https://graph.facebook.com/me/friends?fields=location,id,name&access_token=#{current_user.facebook_access_token}"

    result = JSON.parse(open(url).read)

    friends = result["data"]

    # OPTIMIZE change this to map instead of each
    friends.each do |friend_hash|
      if friend_hash["location"].present?
        f = Friend.new
        f.name = friend_hash["name"]
        f.facebook_id = friend_hash["id"]
        f.location = friend_hash["location"]["name"]
        f.user = current_user
        f.save
      end
    end

    redirect_to current_user
  end

  def require_authorized_user
    @user = User.find(params[:id])

    if @user != current_user
      redirect_to root_url, flash: { alert: "Not authorized for that." }
    end
  end


  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @json = @user.friends.to_gmaps4rails

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        # email = UserMailer.welcome(@user)
        # email.deliver
        UserMailer.welcome(@user).deliver

        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
