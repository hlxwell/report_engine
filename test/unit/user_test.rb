require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @users = []
    1000.times do |i|
      @users << Factory(:user)
    end
  end

  test "pie_chart" do
    pp @users.map(&:username)
    User.charts
  end
end