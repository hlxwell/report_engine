class User < ActiveRecord::Base
  scope :male, where(:gender => 'M')
  scope :female, where(:gender => 'W')

	chart :title => "Buying behavior of different gender",
	      :type => :pie,
				:columns => {
					:male_bought => lambda {},
					:male_never_bought => lambda {},
					:female_bought => lambda {},
					:female_never_bought => lambda {}
				}

  chart :title => "Buying behavior of different age",
        :type => :line,
  			:x_columns => {
  				:between_10_20 => {:birthday => (Date.today - 20)..(Date.today - 10)},
  				:between_20_30 => {:birthday => (Date.today - 30)..(Date.today - 20)}
  			},
  			:y_columns => {
  				:male => lambda {|x_column| User.male.where(x_column).count },
  				:female => lambda {|x_column| User.female.where(x_column).count }
  			}
end