# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationService do
  let(:service_class) { Class.new(described_class) }

  describe ".call" do
    context "when error" do
      it "raises NotImplementedError when call is not implemented" do
        expect { service_class.call }.to raise_error(NotImplementedError)
      end
    end
  end
end