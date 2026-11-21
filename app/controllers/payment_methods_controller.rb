# frozen_string_literal: true

class PaymentMethodsController < ApplicationController
  include ResourceResponses

  before_action :set_payment_method, only: [:show, :update, :destroy]

  def index
    @payment_methods = PaymentMethod.order(:name)
  end

  def show; end

  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    create_resource(@payment_method, payment_methods_path)
  end

  def update
    update_resource(@payment_method, payment_method_params, payment_methods_path)
  end

  def destroy
    destroy_resource(@payment_method, payment_methods_path)
  end

  private

  def set_payment_method
    @payment_method = PaymentMethod.find(params.expect(:id))
  end

  def payment_method_params
    params.expect(payment_method: [:name])
  end
end
