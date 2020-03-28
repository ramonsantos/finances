# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  # GET /users/sign_in
  def new
    @user = User.new
  end

  # POST /users/sign_in
  def create
    super
    flash.delete(:notice)
  end

  # DELETE /users/sign_out
  def destroy
    super
    flash.delete(:notice)
  end
end
