# frozen_string_literal: true

class Data::EmployeeDataComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private
  attr_reader :user
end
