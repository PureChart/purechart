module PureChart
    module ChartHelpers
        def lollipop_chart(data, configuration = { axes: { horizontal: "Value" } }, path="")
            # Set default configuration file path
            default_config_path = File.join( File.dirname(__FILE__), 'styles/default.yml' )

            default_config_hash = YAML.load(File.read(default_config_path))
            user_config_hash = {}
            
            if path == "professional_light"
                # TODO - Instead of loading our own by default, try/catch to see if they defined their own
                # style using the same name
                style_config_path = File.join( File.dirname(__FILE__), 'styles/professional_light.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "professional_dark"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/professional_dark.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "futuristic_light"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/futuristic_light.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "futuristic_dark"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/futuristic_dark.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path != ""
                # TODO - Implement better logic
                if File.file?("app/purechart/" + path + ".yml")
                    user_config_hash = YAML.load(File.read("app/purechart/" + path + ".yml"))
                elsif File.file?("app/purechart/" + path + ".yaml")
                    user_config_hash = YAML.load(File.read("app/purechart/" + path + ".yaml"))
                elsif File.file?("app/purechart/" + path + ".json")
                    user_config_hash = JSON.load(File.read("app/purechart/" + path + ".json"))
                else
                    raise "(PureChart) ERROR - Could not locate configuration file '" + path + ".[YML, YAML, JSON]'. Make sure this file exists in your 'app/purechart' directory."
                end
            end
            
            # Merge user's configuration with default
            style_config = default_config_hash.merge(user_config_hash)

            # Format data for chart generation
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
                configuration: configuration,
                style: style_config
            }
        end

        def bar_chart(data, configuration = { axes: { horizontal: "Value" } }, path="")
            # Set default configuration file path
            default_config_path = File.join( File.dirname(__FILE__), 'styles/default.yml' )

            default_config_hash = YAML.load(File.read(default_config_path))
            user_config_hash = {}

            if path == "professional_light"
                # TODO - Instead of loading our own by default, try/catch to see if they defined their own
                # style using the same name
                style_config_path = File.join( File.dirname(__FILE__), 'styles/professional_light.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "professional_dark"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/professional_dark.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path != ""
                # TODO - Implement better logic
                if File.file?("app/purechart/" + path + ".yml")
                    user_config_hash = YAML.load(File.read("app/purechart/" + path + ".yml"))
                elsif File.file?("app/purechart/" + path + ".yaml")
                    user_config_hash = YAML.load(File.read("app/purechart/" + path + ".yaml"))
                elsif File.file?("app/purechart/" + path + ".json")
                    user_config_hash = JSON.load(File.read("app/purechart/" + path + ".json"))
                else
                    raise "(PureChart) ERROR - Could not locate configuration file '" + path + ".[YML, YAML, JSON]'. Make sure this file exists in your 'app/purechart' directory."
                end
            end
            
            # Merge user's configuration with default
            style_config = default_config_hash.merge(user_config_hash)

            # Format data for chart generation
            largest_value = (data.map { |object| object[:value] }).max()

            data.each do |object|
                object[:width] = (Float(object[:value]) / largest_value) * 100
            end

            gridlines = {
                vertical_lines: 10,
                vertical_increment: (Float(largest_value) / 10).ceil
            }

            ActionController::Base.render partial: '/bar', locals: {
                data: data,
                gridlines: gridlines,
                configuration: configuration,
                style: style_config
            }
        end

        def column_chart
            "<div>Column chart will be rendered here.</div>".html_safe
        end

        def pie_chart(data)
            # check for negative values 
            has_negative_value = 0

            # Find total value for calculating percentages 
            total_value = 0
            data.each do |object|
                total_value += (object[:value]).abs 
            end
            # Calculate percentages for each data point
            data.each do |object|
                object[:percent_value] = (Float(object[:value]) / total_value).abs 
                if object[:value] < 0 
                    object[:is_negative] = 1
                    has_negative_value = 1 
                else
                    object[:is_negative] = 0
                end
            end

            negative_value = {
                negative: has_negative_value
            }
        
            ActionController::Base.render partial: '/pie', locals: {
                data: data,
                negative_value: negative_value
            }
        end

        def box_plot(data, configuration = {}, path="")
            default_color_config = {
                colors: {
                    fill: "white",
                    stroke: "black" 
                },
                width: 1
            }

            merged_color_config = default_color_config.merge(configuration)

            fill_color = merged_color_config.dig(:colors, :fill)
            stroke_color = merged_color_config.dig(:colors, :stroke)
            stroke_width = merged_color_config[:width]

            default_config_path = File.join(File.dirname(__FILE__), 'styles', 'default.yml')
            default_config_hash = YAML.load(File.read(default_config_path))
            user_config_hash = {}

            if path == "professional_light"
                # TODO - Instead of loading our own by default, try/catch to see if they defined their own
                # style using the same name
                style_config_path = File.join( File.dirname(__FILE__), 'styles/professional_light.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "professional_dark"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/professional_dark.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "futuristic_light"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/futuristic_light.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "futuristic_dark"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/futuristic_dark.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "default"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/default.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path != ""
                # TODO - Implement better logic
                if File.file?("app/purechart/" + path + ".yml")
                    user_config_hash = YAML.load(File.read("app/purechart/" + path + ".yml"))
                elsif File.file?("app/purechart/" + path + ".yaml")
                    user_config_hash = YAML.load(File.read("app/purechart/" + path + ".yaml"))
                elsif File.file?("app/purechart/" + path + ".json")
                    user_config_hash = JSON.load(File.read("app/purechart/" + path + ".json"))
                else
                    raise "(PureChart) ERROR - Could not locate configuration file '" + path + ".[YML, YAML, JSON]'. Make sure this file exists in your 'app/purechart' directory."
                end
            end

            # Merge user's configuration with default
            style_config = default_config_hash.merge(user_config_hash)
            area =  '''<svg width="1000" height="200" xmlns="http://www.w3.org/2000/svg">'''

            s_data = data.map{ |data| data[:value]}.sort

            def find_median(array)
                return nil if array.empty?
                if array.length.even?
                    puts array.length
                    return (array[array.length/2]+array[array.length/2-1])/2.0
                else 
                    return array[array.length/2].to_f;
                end
            end

            def normalize(value,min,max)
                return ((value.to_f-(min))/(max.to_f-min)+0.025)*950.0
            end

            n = s_data.length
            min = s_data[0]
            max = s_data[-1]
            median = find_median(s_data)

            if s_data.length.even?
                lower = find_median s_data[0..n/2-1]
                upper = find_median s_data[n/2..-1]
            else
                lower = find_median s_data[0..n/2-1]
                upper = find_median s_data[n/2+1..-1]
            end

            iqr = 1.5*(upper - lower)

            # color selection from YML - FIX LATER
            # Q1 and Q3
            area += "<rect width='#{(normalize(upper, min, max) - normalize(median, min, max))}' 
            height='100' x='#{normalize(median, min, max)}' y='50' style='fill:#{fill_color};stroke-width:#{stroke_width};stroke:#{stroke_color}' />"
            area += "<rect width='#{(normalize(median, min, max) - normalize(lower, min, max))}' 
            height='100' x='#{normalize(lower, min, max)}' y='50' style='fill:#{fill_color};stroke-width:#{stroke_width};stroke:#{stroke_color}' />"

            def linemaker(start,endp, stroke, stroke_width)
                line = ""
                line+="<line x1='#{start}' y1='100' x2='#{endp}' y2='100' style='stroke:#{stroke};stroke-width:#{stroke_width}' />"
                line+="<line x1='#{endp}'  y1='75' x2='#{endp}' y2='125' style='stroke:#{stroke};stroke-width:#{stroke_width}' />"
                return line
            end

            # min wisker + lower outliers
            if min >= lower-iqr
                area+=linemaker(normalize(lower,min,max),normalize(min,min,max), stroke_color, stroke_width)
            else
                area+=linemaker(normalize(lower,min,max),(normalize(lower-iqr,min,max)), stroke_color, stroke_width)
                i=0
                while s_data[i] <= lower-iqr
                    area+= "<circle r='5' cx='#{normalize(s_data[i],min,max)}' cy='100' fill=#{stroke_color} />"
                    i+=1
                end
            end

            # max wisker + upper outliers
            if max <= upper+iqr
                area+=linemaker(normalize(upper,min,max),normalize(max,min,max), stroke_color, stroke_width)
            else
                area+=linemaker(normalize(upper,min,max),(normalize(upper+iqr,min,max)), stroke_color, stroke_width)
                i=s_data.length-1
                while s_data[i] >= upper+iqr
                    area+= "<circle r='5' cx='#{normalize(s_data[i],min,max)}' cy='100' fill=#{stroke_color} />"
                    i-=1
                end
            end

            area+="</svg>"
            area.html_safe
        end

        def line_graph(data)
            # If all values are very high, the "adjust factor" will be used
            # to make sure they are all evenly spread across the vertical axis
            # TODO - Decide what the "adjust factor" should be based on user
            # input... also rename it
            adjust_factor = 0

            chart = '''<svg style="border: 2px solid black;" width="500" height="500" xmlns="http://www.w3.org/2000/svg">'''
          
            min_val = data.min - adjust_factor
            max_val = data.max + adjust_factor
          
            # Calculate the vertical scaling factor
            scale_factor = 500.to_f / (max_val - min_val)
          
            prev_x = 10
            prev_y = -1

            i = 10
            data.each do |val|
                # Apply the transformation formula to scale the y coordinate
                scaled_y = ((val - min_val) * scale_factor)
                # Invert the y-axis to match the SVG coordinate system (0 at the top)
                inverted_y = 500 - scaled_y

                if prev_y == -1
                    prev_y = inverted_y
                end
            
                chart += "<path d='M#{prev_x} #{prev_y} L#{i} #{inverted_y}' stroke='black' stroke-width='4'/>"
                chart += "<circle cx='#{i}' cy='#{inverted_y}' r='7' fill='black'/>"

                prev_x = i
                prev_y = inverted_y

                i += 480.to_f / data.length
            end
          
            chart += "</svg>"
            chart.html_safe
        end

        def dot_plot(data)
            # If all values are very high, the "adjust factor" will be used
            # to make sure they are all evenly spread across the vertical axis
            # TODO - Decide what the "adjust factor" should be based on user
            # input... also rename it
            adjust_factor = 0

            chart = '''<svg style="border: 2px solid black;" width="500" height="500" xmlns="http://www.w3.org/2000/svg">'''
          
            min_val = data.min - adjust_factor
            max_val = data.max + adjust_factor
          
            # Calculate the vertical scaling factor
            scale_factor = 500.to_f / (max_val - min_val)

            i = 10
            data.each do |val|
                # Apply the transformation formula to scale the y coordinate
                scaled_y = ((val - min_val) * scale_factor)
                # Invert the y-axis to match the SVG coordinate system (0 at the top)
                inverted_y = 500 - scaled_y

                chart += "<circle cx='#{i}' cy='#{inverted_y}' r='7' fill='black'/>"

                i += 480.to_f / data.length
            end

            chart += "</svg>"
            chart.html_safe
        end

        def line_plot(data, configuration = { axes: { vertical: "Value" } }, path="")
            # Set default configuration file path
            default_config_path = File.join( File.dirname(__FILE__), 'styles/default.yml' )

            default_config_hash = YAML.load(File.read(default_config_path))
            user_config_hash = {}

            if path == "professional_light"
                # TODO - Instead of loading our own by default, try/catch to see if they defined their own
                # style using the same name
                style_config_path = File.join( File.dirname(__FILE__), 'styles/professional_light.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "professional_dark"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/professional_dark.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "futuristic_light"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/futuristic_light.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path == "futuristic_dark"
                style_config_path = File.join( File.dirname(__FILE__), 'styles/futuristic_dark.yml' )
                default_config_hash = YAML.load(File.read(style_config_path))
            elsif path != ""
                # TODO - Implement better logic
                if File.file?("app/purechart/" + path + ".yml")
                    user_config_hash = YAML.load(File.read("app/purechart/" + path + ".yml"))
                elsif File.file?("app/purechart/" + path + ".yaml")
                    user_config_hash = YAML.load(File.read("app/purechart/" + path + ".yaml"))
                elsif File.file?("app/purechart/" + path + ".json")
                    user_config_hash = JSON.load(File.read("app/purechart/" + path + ".json"))
                else
                    raise "(PureChart) ERROR - Could not locate configuration file '" + path + ".[YML, YAML, JSON]'. Make sure this file exists in your 'app/purechart' directory."
                end
            end

            # Merge user's configuration with default
            style_config = default_config_hash.merge(user_config_hash)

            # Format data for chart generation
            largest_value = (data.map { |object| object[:value] }).max()

            data.each do |object|
                object[:length] = (Float(object[:value]) / largest_value) * 10
            end

            gridlines = {
                vertical_lines: data.size
            }

            ActionController::Base.render partial: '/line_plot', locals: {
                data: data,
                gridlines: gridlines,
                configuration: configuration,
                style: style_config
            }
        end
    end
end
