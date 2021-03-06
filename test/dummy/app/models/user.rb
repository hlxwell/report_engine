class User < ActiveRecord::Base
  has_many :buyings
  has_many :books, :through => :buyings

  scope :male, where(:gender => 'M')
  scope :female, where(:gender => 'W')

  # type can be: line, spline, area, areaspline, column, bar, pie and scatter
  #
  pie_chart "Buying behavior of different gender",
            :tooltip_formatter => "function() {return this.point.name + ':' + this.y + ' people';}",
            :columns => {
              "male bought" => lambda { User.user_count('M', true) },
              "male never bought" => lambda { User.user_count('M', false) },
              "female bought" => lambda { User.user_count('W', true) },
              "female never bought" => lambda { User.user_count('W', false) }
            }

  column_chart  "User gender and age distribution",
          			:groups => {
          				"Age between 10 and 20" => {:birthday => 20.years.ago.to_date..10.years.ago.to_date},
          				"Age between 20 and 30" => {:birthday => 30.years.ago.to_date..20.years.ago.to_date}
          			},
          			:column_title => "User count",
          			:columns => {
                  "Male"   => lambda {|x_column| User.male.where(x_column).count },
                  "Female" => lambda {|x_column| User.female.where(x_column).count }
          			}

  def self.user_count gender = 'M', bought_book = false
    if bought_book
      Buying.select("distinct buyings.user_id").includes("user").where(["users.gender = ?", gender]).count
    else
      User.where(:gender => gender).includes(:buyings).where("buyings.id IS NULL").count
    end
  end
end