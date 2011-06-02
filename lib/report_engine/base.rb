module ReportEngine
  module Base
    %w{pie column}.each do |type|
      define_method "#{type}_chart" do |title, options|
        parse_options title, type, options
      end
    end

    # will get charts hash data
    #
    def charts
      # @@charts ||= begin
        _charts = []

        self.charts_data.each do |k, v|
          default_configs = {
            :chart => {:defaultSeriesType => v['config']['type']},
            :title => {:text => k},
            :legend => { :align => 'right', :verticalAlign => 'top', :y => 75, :x => 0, :layout => 'vertical' },
            :plot_options => {
              :pie => {
                :allowPointSelect => true,
                :cursor => 'pointer',
                :dataLabels => {},
                :showInLegend => true
              }
            },
            :tooltip => {
              :formatter => v['config']['tooltip_formatter']
            }
          }

          default_configs.merge!({
            :x_axis => { :categories => v['data'].keys },
            :y_axis => { :title => { :text => v['config']['column_title'], :margin => 70 } }
          }) if v['config']['type'] != :pie

          _charts << LazyHighCharts::HighChart.new('graph') do |f|
            f.chart default_configs[:chart]
            f.title default_configs[:title]
            f.legend default_configs[:legend]
            f.plotOptions default_configs[:plot_options]
            f.xAxis default_configs[:x_axis]
            f.yAxis default_configs[:y_axis]
            f.tooltip default_configs[:tooltip]
            # f.series :name => "total", :data=> [1,2,3,4]
            extract_data_for_series(v['data'], v['config']['type']).each do |data|
              f.series data
            end
          end
        end

        _charts
      # end
    end

    # data {
    #   10-20 {
    #     male
    #     female
    #   }
    #   20-30 {
    #     male
    #     female
    #   }
    # }
    def extract_data_for_series data, chart_type
      # groups => ["10-20", "20-30"]
      categories = data.keys

      ### final result should be:
      # :name => 'male', :data => [1, 2]
      # :name => 'female', :data => [4, 5]
      series = []

      ## for line, column chart
      # data.values => [{'male' => 1, 'female' => 2}, {'male' => 3, 'female' => 4}]
      ## for pie chart
      # data.values => [1,2,3,4]
      #
      if data.values.first.is_a? Hash
        data.values.each do |hash|
          hash.each do |k, v|
            # if {:name => "xxx"} exist?
            if i = series.index {|s| s[:name] == k}
              series[i][:data] << v
            else
              series << { :name => k, :data => [v] }
            end
          end
        end
      else
        if chart_type.to_s == 'pie'
          series << {:name => "total", :data => data.to_a}
        else
          data.each do |k, v|
            series << {:name => k, :data => v}
          end
        end
      end

      series
    end

    def charts_data
      # @@data ||= begin # cache
        # TODO: simplify this line
        _data = Hash.new { |k,v| k[v] = Hash.new { |k1,v1| k1[v1] = Hash.new { |k2,v2| k2[v2] = {} } } }

        # traverse all chart data configs, and calculate the criteria to result.
        #
        @@chart_options ||= []
        @@chart_options.each do |chart|
          chart_title = chart[:title]

          # {'config' => ...}
          %w{type column_title tooltip_formatter}.each do |col|
            _data[chart_title]['config'][col] = chart[col]
          end

          # {'data' => ...}
          if chart[:groups]
            chart[:groups].each do |group_name, group_value|
              _data[chart_title]['config']['categories'] = [] if _data[chart_title]['config']['categories'].blank?
              _data[chart_title]['config']['categories'] << group_name

              chart[:columns].each do |column_name, column_block|
                _data[chart_title]['data'][group_name][column_name] = column_block.call(group_value)
              end
            end
          else
            chart[:columns].each do |key, value|
              _data[chart_title]['data'][key] = value.call
            end
          end
        end

        _data
      # end
    end

    protected

    def parse_options title, type, options
      # a list of acceptable parameters.
      chart_option = {
        :title              => title,                           # chart title
        :type               => type,                            # chart type
        :groups             => options.delete(:groups),         # groups
        :columns            => options.delete(:columns),        # columns criteria
        :column_title       => options.delete(:column_title),   # y column title
        :tooltip_formatter  => options.delete(:tooltip_formatter)
      }.with_indifferent_access

      @@chart_options ||= []
      @@chart_options << chart_option
    end
  end
end