module ReportEngine
  module Base
    def chart options
      parse_options options
    end

    # will get charts hash data
    #
    def charts
      # @@charts ||= begin
        _charts = []

        self.charts_data.each do |k, v|
          _charts << LazyHighCharts::HighChart.new('graph') do |f|
            f.title :text              => k
            f.xAxis :categories        => v['data'].keys
            f.yAxis :title             => {:text => v['config']['y_title'], :margin => 70}
            f.series :name             => "total", :data=> v['data'].values
            f.legend :align            => 'right', :verticalAlign => 'top', :y => 75, :x => 0, :layout => 'vertical'
            f.chart :defaultSeriesType => v['config']['type']
          end
        end
        _charts
      # end
    end

    def charts_data
      # @@data ||= begin # cache
        _data = Hash.new { |k,v| k[v] = Hash.new { |k1,v1| k1[v1] = {} } }

        # traverse all chart data configs, and calculate the criteria to result.
        #
        @@chart_options.each do |chart|
          chart_title = chart[:title]

          %w{type y_title}.each do |col|
            _data[chart_title]['config'][col] = chart[col]
          end

          chart[:x_columns].each do |x_key, x_value|
            chart[:y_columns].each do |y_key, y_value|
              _data[chart_title]['data']["#{x_key} #{y_key}"] = y_value.call(x_value)
            end
          end
        end
        _data
      # end
    end

    protected

    def parse_options options
      chart_option = {
        :title     => options.delete(:title),       # chart title
        :type      => options.delete(:type),        # chart type
        :x_columns => options.delete(:x_columns),   # x columns criteria
        :y_columns => options.delete(:y_columns),   # y columns criteria
        :columns   => options.delete(:columns),       # columns criteria
        :y_title   => options.delete(:y_title)
      }.with_indifferent_access

      chart_option.delete(:x_columns) if chart_option[:x_columns].blank?
      chart_option.delete(:y_columns) if chart_option[:y_columns].blank?

      # alert if set both columns and x_columns, y_columns
      if Rails.env != 'production' and
        chart_option[:columns].present? and
        chart_option[:x_columns].present? and
        chart_option[:y_columns].present?

        puts "\e[31mYou have defined :x and :y nodes for options at #{caller[0]} so the :columns node won't be loaded.\e[0m"
      end

      @@chart_options ||= []
      @@chart_options << chart_option
    end
  end
end