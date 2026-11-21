# frozen_string_literal: true

class PaymentMethodsController < ApplicationController
  include ResourceResponses

  before_action :set_payment_method, only: [:update, :destroy]

  def index
    prepare_index_context
    @new_payment_method = PaymentMethod.new
    @open_payment_method_modal = false
    @open_edit_payment_method_id = nil
  end

  def create
    @new_payment_method = PaymentMethod.new(payment_method_params)

    if @new_payment_method.save
      redirect_to(payment_methods_path, notice: t('.created'))
    else
      prepare_index_context
      @open_payment_method_modal = true
      @open_edit_payment_method_id = nil
      render(:index, status: :unprocessable_content)
    end
  end

  def update
    if @payment_method.update(payment_method_params)
      redirect_to(payment_methods_path, notice: t('.updated'))
    else
      prepare_index_context
      @new_payment_method = PaymentMethod.new
      @open_payment_method_modal = false
      @open_edit_payment_method_id = @payment_method.id
      render(:index, status: :unprocessable_content)
    end
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

  def prepare_index_context
    @payment_methods = PaymentMethod.order(:name)
  end
end
