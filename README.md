Report Engine
=============

Report Engine provides you some DSLs to generate almost all kinds of ordinary reports by merely some simple and easy steps of configuration in your model file.
Since all the chart data will be well cached, so don't worry about the performance on complex report.

Chart type includes:

1. Data Table (data_table)
2. Line Chart (line_chart)
3. Pie Chart (pie_chart)
4. Bar Chart (bar_chart)

After did configuration, You will:

1. Get a page of listing all charts according to your configuration.
2. Be able to embed any one of chart to any other places by coping embeded javascript.

Two kinds of data need to be displayed:

1. display the ratio between several data based on total records of table.
2. display historical data, by day, week, month, year.


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
		# :common_options means will be apply to sub conditions.
		#
		pie_chart :title => "Buying behavior of different gender",
							:common_options => {:state => 'active'},   <= will implement in the future.
							:columns => {
								:male => {
									:common_options => {:gender => 'M'},
									:bought => lambda {|criteria| Book.select("distinct user_id").where(:gender => 'M').count }
									:never_bought => lambda {|criteria| User.where(:gender => 'M').includes(:books).where("books.id IS NULL").count }
								},
								:female => {
									:common_options => {:gender => 'W'},
									:bought => lambda {|criteria| }
									:never_bought => lambda {|criteria| }
								}
							}

    # when y set a hash, each item should return a hash, and it will be a line or bar in the chart.
		# Ways to assign condition hash are:
		# 1. condition hash
		# 2. lambda block
		# 3. method name
		#
		line_chart  :title => "Daily male/female increasing ratio",
								:x => 7.days.ago..Time.now,
							  :y => {
									:male => lambda { |date_range| User.male.where(:created_at => date_range).count }
									:female => :get_female_count # expect to be defined a method: get_male_count(date)
								}

		# data_table support nested hash under y hash.
		# all the values in x will pass to lambdas in y hash.
		#
		data_table 	:title => "General report of new registers",
								:x => {
									:smart => ["iq >= ?", 100],
									:stupid => ["iq < ?", 70],
									:normal => ["iq >= ? and iq < ?", 70, 100]
								},
							  :y => {
									:en => {
										:male => lambda { |x_criteria| User.where(:gender => 'M', :locale => 'en').where(x_criteria).count },
										:female => lambda { |x_criteria| User.get_user_count(:en, :female, x_criteria) },
									},
									:ja => {
										:male => lambda { |x_criteria| User.male.ja.where(:created_at => date_range).count },
										:female => lambda { |x_criteria| User.female.ja.where(:created_at => date_range).count },
									},
									:de => lambda {|x_criteria| get_male_female_user_count_in(x_criteria, :de) }
								}
  end

Configuration
=============

Use `rails g report_engine:config` to generate a config file at `config/initializers/report_engine_config.rb`

Below is a default sample config file:

ReportEngine.config do
	mount_at '/admin/charts'
  authentication_method_name :check_admin
  default_update_frequency :daily
end

TO-DOs
======
<script type="text/javascript" charset="utf-8" src='/report_engine/data.json?model=user&name=xxx'>