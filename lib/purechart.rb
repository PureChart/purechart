require_relative "purechart/chart_helper"

if defined?(ActiveSupport.on_load)
  ActiveSupport.on_load(:action_view) do
    include PureChart::ChartHelpers
    puts "Helpers sent."
  end
else
  puts "Active support not defined"
end

module PureChart
  class << self
  end

  class Engine < Rails::Engine;
  end
end
