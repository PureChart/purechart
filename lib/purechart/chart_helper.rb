module PureChart
    module ChartHelpers
        def lollipop_chart(data, configuration = { axes: { horizontal: "Value" } }, path = "")
            # Set default configuration file path
            default_config_path = File.join( File.dirname(__FILE__), 'styles/default.yml' )

            default_config_hash = YAML.load(File.read(default_config_path))
            user_config_hash = {}

            if path != ""
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

        def bar_chart
            "<div>Bar chart will be rendered here.</div>".html_safe
        end

        def column_chart
            "<div>Column chart will be rendered here.</div>".html_safe
        end

        def pie_chart
            ActionController::Base.render partial: '/pie'
        end

        def box_plot(data)
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
            n=s_data.length
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
            
            #Q1 and Q3
            area+= "<rect width='#{(normalize(upper,min,max)-normalize(median,min,max))}' 
                    height='100' x='#{normalize(median,min,max)}' y='50' style='fill:rgb(0,0,255);stroke-width:3;stroke:red' />"
            area+= "<rect width='#{(normalize(median,min,max)-normalize(lower,min,max))}' 
                    height='100' x='#{normalize(lower,min,max)}' y='50' style='fill:rgb(0,0,255);stroke-width:3;stroke:red' />"
           
            def linemaker(start,endp)
                line = ""
                line+="<line x1='#{start}' y1='100' x2='#{endp}' y2='100' style='stroke:red;stroke-width:3' />"
                line+="<line x1='#{endp}'  y1='75' x2='#{endp}' y2='125' style='stroke:red;stroke-width:3' />"
                return line
            end
            #min wisker + lower outliers
            if min >= lower-iqr
                area+=linemaker(normalize(lower,min,max),normalize(min,min,max))
            else
                area+=linemaker(normalize(lower,min,max),(normalize(lower-iqr,min,max)))
                i=0
                while s_data[i] <= lower-iqr
                    area+= "<circle r='5' cx='#{normalize(s_data[i],min,max)}' cy='100' fill='red' />"
                    i+=1
                end
            end
            #max wisker + upper outliers
            if max <= upper+iqr
                area+=linemaker(normalize(upper,min,max),normalize(max,min,max))
            else
                area+=linemaker(normalize(upper,min,max),(normalize(upper+iqr,min,max)))
                i=s_data.length-1
                while s_data[i] >= upper+iqr
                    area+= "<circle r='5' cx='#{normalize(s_data[i],min,max)}' cy='100' fill='red' />"
                    i-=1
                end
            end

            area+="</svg>"
            area.html_safe

        end
    end
end