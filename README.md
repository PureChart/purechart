<p align="center">
  <img width="355px" src="README/PureChartLogo.png">
</p>

# PureChart
Fully customizable HTML/CSS charts for Ruby on Rails. PureChart serves as an alternative to other charting libraries that extensively use JavaScript and HTML `canvas` elements to render charts, resulting in Rails rendering problems and very limited customization options.

## Getting Started
Integrating PureChart into your Rails project is incredibly easy. Simply add `gem 'purechart'` to your Gemfile, run `bundle install` and you should be all set! Now, use our helpers to generate charts in your `html.erb` files and create your own style configurations in either `YML`, `TOML`, or `JSON` format in the `app/purechart` directory of your application.

**Note -** We're currently working on a documentation website ([docs.purechart.org](https://docs.purechart.org)). Check back once in a while for updates!

## Examples
### Lollipop Chart
#### Controller
```ruby
class ChartsController < ApplicationController
    def index
        @data = [
            {
                name: "Burger King",
                color: "#ff7f50",
                value: 1200,
            },
            {
                name: "McDonalds",
                color: "#ff4757",
                value: 500,
            },
            {
                name: "Green Burrito",
                color: "#2ed573",
                value: 780,
            }
        ]

        @axes = {
            horizontal: "Dollars"
        }
    end
end
```

#### Optional Style Configuration (`app/purechart/custom_bar.yml`)
```yml
---
labels:
  font: Inter Tight
...
```

#### Template
```erb
<div class="card">
    <%= lollipop_chart @data, @axes, "custom_bar" %>
</div>
```

<p align="center">
  <img width="500px" src="README/Lollipop.png">
</p>
