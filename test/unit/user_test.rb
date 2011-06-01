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
    # pp User.charts_data
    # pp User.charts
  end

  # test "has many books" do
  #   buying = Factory(:buying)
  #   user = buying.user
  #   book = buying.book
  # 
  #   p User.user_count 'M', false
  #   p User.user_count 'W', false
  #   p User.user_count 'M', true
  #   p User.user_count 'W', true
  # end

  private

  def range_rand(min,max)
    min + rand(max-min)
  end
end