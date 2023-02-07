<p align="center">
  <img width="350px" src="README/PureChartLogo.png">
</p>

# PureChart
Fully customizable HTML/CSS charts for Ruby on Rails. PureChart serves as an alternative to other charting libraries that extensively use JavaScript and HTML `canvas` elements to render charts, resulting in Rails rendering problems and very limited customization options.

## Getting Started
Integrating PureChart into your Rails project is incredibly easy. Simply add `gem 'purechart'` to your Gemfile, run `bundle install` and you should be all set! Now, just use our helpers to generate charts in your `erb.html` files.

**Note -** We're currently working on a documentation website (you can visit the repository [here](https://github.com/PureChart/purechart-website)) which will include detailed tutorials and examples. Check back from time to time for updates.

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

#### Template
```erb
<div class="card">
    <%= lollipop_chart @data, @axes %>
</div>
```

<p align="center">
  <img width="500px" src="README/Lollipop.png">
</p>
