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

        def dot_svg_render
           '''<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
                <path d="M 10 10 H 190 V 190 H 10 L 10 10" fill="none" stroke="black"/>
                <circle cx="15" cy="100" r="6" fill="red"/>
                <circle cx="30" cy="60" r="6" fill="red"/>
                <circle cx="90" cy="140" r="6" fill="red"/>
                <circle cx="130" cy="90" r="6" fill="red"/>
                <circle cx="160" cy="20" r="6" fill="red"/>
                <circle cx="180" cy="150" r="6" fill="red"/>
                <circle cx="40" cy="20" r="6" fill="red"/>
            </svg>'''.html_safe
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
            # Find total value for calculating percentages 
            total_value = 0
            data.each do |object|
                total_value += object[:value]
            end

            # Create svg and align viewbox
            result = '''<svg height="250" width="250" viewBox="0 0 250 250">
            <circle r="125" cx="125" cy="125" fill="white" />'''
            
            # Orient first slice at top of circle
            angle = -90

            # For each slice, create circle with stroke border, where gap between strokes = circumference (to make 1 slice)
            for object in data do
                # Circle radius should be 1/4 of bg circle dimension
                result += "<circle r='62.5' cx='125' cy='125' fill='transparent'
                stroke='#{object[:color]}'
                stroke-width='125'
                stroke-dasharray='calc(#{object[:value]}/#{total_value} * 2 * pi * 62.5) calc(2 * pi * 62.5)' 
                transform='rotate(#{angle}, 125, 125)'/>"

                # TODO - Fix error accumulated by pie slices (0.5 is temporary offset)
                angle += 360 * object[:value] / total_value + 0.5
            end

            result += "</svg>"
            result.html_safe
        end

        def line_graph
            "<div>Line graph will be rendered here.</div>".html_safe
        end

        def dot_plot
            "<div>Dot plot will be rendered here.</div>".html_safe
        end
    end
end
