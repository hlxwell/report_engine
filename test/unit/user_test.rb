require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @users = []
    100.times do |i|
      @users << Factory(:user,
                        :gender => %w{W M}[rand(2)],
                        :country_code => %w{zh en ja}[rand(3)],
                        :birthday => range_rand(10, 30).years.ago.to_date
                        )
    end
  end

  test "pie_chart" do
    pp User.charts
  end

  private

  def range_rand(min,max)
    min + rand(max-min)
  end
end