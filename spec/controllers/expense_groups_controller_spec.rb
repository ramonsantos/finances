# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpenseGroupsController, type: :controller do
  routes { Rails.application.routes }

  let!(:expense_group) { create(:expense_group) }

  let(:valid_attributes) { attributes_for(:expense_group) }
  let(:invalid_attributes) { attributes_for(:expense_group, name: nil) }

  describe "GET #index" do
    it "returns success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a group" do
        expect do
          post :create, params: { expense_group: valid_attributes }
        end.to change(ExpenseGroup, :count).by(1)
      end

      it "redirects with a notice" do
        post :create, params: { expense_group: valid_attributes }

        expect(response).to redirect_to(expense_groups_path)
        expect(flash[:notice]).to eq(I18n.t("expense_groups.create.created"))
      end
    end

    context "with invalid params" do
      it "renders index" do
        post :create, params: { expense_group: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:index)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys a group without expenses" do
      expect do
        delete :destroy, params: { id: expense_group.id }
      end.to change(ExpenseGroup, :count).by(-1)
    end

    it "blocks destroy when expenses exist" do
      category = create(:expense_category)
      create(:expense, expense_group: expense_group, expense_category: category)

      expect do
        delete :destroy, params: { id: expense_group.id }
      end.not_to change(ExpenseGroup, :count)

      expect(response).to redirect_to(expense_groups_path)
      expect(flash[:alert]).to eq(I18n.t("expense_groups.destroy.destroy_failed"))
    end
  end
end