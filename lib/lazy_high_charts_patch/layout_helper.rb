# coding: utf-8
require 'rails' unless defined? ::Rails

module LazyHighCharts
  module LayoutHelper
    def high_graph(placeholder, object, &block)
      tooltip_formatter_json = object.options[:tooltip][:formatter].present? ?
                                "{ formatter : #{object.options[:tooltip][:formatter]} }" : "{}"

      graph =<<-EOJS
      <script type="text/javascript">
      jQuery(function() {
            // 1. Define JSON options
            var options = {
                          chart: #{object.options[:chart].to_json},
                                  title:        #{object.options[:title].to_json},
                                  legend:       #{object.options[:legend].to_json},
                                  xAxis:        #{object.options[:xAxis].to_json},
                                  yAxis:        #{object.options[:yAxis].to_json},
                                  tooltip:      #{tooltip_formatter_json},
                                  credits:      #{object.options[:credits].to_json},
                                  plotOptions:  #{object.options[:plotOptions].to_json},
                                  series:       #{object.data.to_json},
                                  subtitle:     #{object.options[:subtitle].to_json}
                          };

            // 2. Add callbacks (non-JSON compliant)
            #{capture(&block) if block_given?}
            // 3. Build the chart
            var chart = new Highcharts.Chart(options);
        });
        </script>
      EOJS

      if defined?(raw) &&  ::Rails.version >= '3.0'
        return raw(graph)
      else
        return graph unless block_given?
        concat graph
      end
    end
  end
end
