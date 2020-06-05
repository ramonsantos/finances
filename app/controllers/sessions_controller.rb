# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  include ClearFlash

  after_action :clear_flash, only: [:create, :destroy]

  # GET /users/sign_in
  def new
    @user = User.new
  end

  # POST /users/sign_in
  def create
    super
  end

  # DELETE /users/sign_out
  def destroy
    super
  end
end
