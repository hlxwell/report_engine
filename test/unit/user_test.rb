require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = Factory(:user)
  end

  test "pie_chart" do
    User.charts
  end
end