class User < ActiveRecord::Base
  scope :male, where(:gender => 'M')
  scope :female, where(:gender => 'W')

  # chart :title => "Buying behavior of different gender",
  #       :type => :pie,
  #       :columns => {
  #         :male_bought => lambda {},
  #         :male_never_bought => lambda {},
  #         :female_bought => lambda {},
  #         :female_never_bought => lambda {}
  #       }

  chart :title => "Buying behavior of different age",
        :type => :column,
  			:x_columns => {
  				"Age between 10 and 20" => {:birthday => 20.years.ago.to_date..10.years.ago.to_date},
  				"Age between 20 and 30" => {:birthday => 30.years.ago.to_date..20.years.ago.to_date}
  			},
  			:y_columns => {
  				"Male" => lambda {|x_column| User.male.where(x_column).count },
  				"Female" => lambda {|x_column| User.female.where(x_column).count }
  			},
  			:y_title => "User count"
end