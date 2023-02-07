module PureChart
    module ChartHelpers
        def lollipop_chart(data, axes = { horizontal: "Value" })
            largest_value = (data.map { |object| object[:value] }).max()

            data.each do |object|
                object[:width] = (Float(object[:value]) / largest_value) * 100
            end

            gridlines = {
                vertical_lines: 10,
                vertical_increment: (Float(largest_value) / 10).ceil
            }

            ActionController::Base.render partial: '/lollipop', locals: {
                data: data,
                gridlines: gridlines,
                axes: axes
            }
        end

        def bar_chart
            "<div>Bar chart will be rendered here.</div>".html_safe
        end

        def column_chart
            "<div>Column chart will be rendered here.</div>".html_safe
        end

        def pie_chart
            ActionController::Base.render partial: '/pie'
        end
    end
end