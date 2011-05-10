Model Chart Fu
==============

Model-chart-fu provides you some DSLs to generate almost all kinds of ordinary charts by merely some simple and easy steps of configuration in your model file.
Since all the chart data will be well cached, so the performance will be very fast.

Charts type includes:

1. Data Table
2. Line Chart
3. Pie Chart
4. Bar Chart

After did configuration, You will:

1. Get a page of listing all charts according to your configuration.
2. Be able to embed any one of chart to any other places by coping embeded javascript.

Usage
=====

  ### columns
  # username
  # locale
  # firstname
  # lastname
  # gender
  # last_sign_in_at
  #
  class User < AR
    ### two kinds of data need to be displayed:
    # display the ratio between several data based on total records of table.
    # display historical data, by day, week, month, year.

    pie_chart :title => "Gender Ratio", :desc => "Male vs Female", :update_frequency => "daily" do
			{
				"Male" => User.male.count,
				"Female" => User.female.count
			}
    end

    bar_chart :title => "Locale Distribution", :desc => "User count for each locale", :update_frequency => "daily" do
			data_hash = {}
      LOCALES.each do |locale|
        data_hash[locale] = User.send(locale).count
      end
			data_hash
    end

    # same data but used for many kinds of charts.
    chart_set :title => "Locale Distribution", :types => [:pie, :bar], :update_frequency => 'daily' do
			data_hash = {}
      LOCALES.each do |locale|
        data_hash[locale] = User.send(locale).count
      end
			data_hash
    end

    line_chart :title => "New Users", :desc => "New registered users", :update_frequency => 'daily' do
			data_hash = {}
      (7.days.ago..Time.now).map do |date|
        data_hash[date] = User.where("created_at between ? and ?", date.start_of_the_day, date.end_of_the_day).count
      end
			data_hash
    end

		### This will aggregate the records count by combination of conditions of x axis and y axis :
		#	\ 1 2 3
		#	1 1 2 3
		#	2 2 4 6
		#	3 3 6 9
		#
    table_chart :title => "Latest logged in users", :update_frequency => 'daily' do
      {
        model => User,
				x_axis_columns => {
					:total => :all,
					:last_7_days => 7.days
				},

				y_axis_columns => {
					:total => :all,
					:logged_in => ['last_logged_in > ?']
				}
      }
    end
  end

Configuration
=============

Use `rails g model_chart_fu:config` to generate a config file at `config/initializers/model_chart_fu_config.rb`

Below is a default sample config file:

ModelChartFu.config do
	mount_chart_list_at '/admin/charts'
  auth_method_name :check_admin
  default_update_frequency :daily
end