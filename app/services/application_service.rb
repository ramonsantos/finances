# frozen_string_literal: true

class ApplicationService
  def self.call(...)
    new(...).send(:call)
  end

  private

  def call
    raise NotImplementedError
  end
end