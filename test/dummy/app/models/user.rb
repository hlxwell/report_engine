# Book.select("distinct user_id").where(:created_at => start_date..end_date).where("users.gender = 'M'").includes(:user)
# Book.select("distinct user_id").where(:created_at => start_date..end_date).where("users.gender = 'W'").includes(:user)

class User < ActiveRecord::Base
	chart :title => "Buying behavior of different gender",
	      :type => :pie,
				:columns => {
					:male_bought => lambda {},
					:male_never_bought => lambda {},
					:female_bought => lambda {},
					:female_never_bought => lambda {}
				}
end