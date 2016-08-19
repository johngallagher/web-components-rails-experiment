class ComponentUpdatesController < ApplicationController
  def show
    @ac_vehicle_search = Components::AcVehicleSearch.new(params: params)
    render json: {
      component: "ac_vehicle_search_filter",
      replacements: replacements
    }
  end

  def components_to_reload
    JSON.parse(params['onchange_reload'])
  end

  def replacements
    components_to_reload.map do |component|
      {
        replace: "[data-component='#{component}'] [data-dynamic]",
        with_elements: dynamic_sections_of(component)
      }
    end
  end

  def dynamic_sections_of component
    component_xml = Nokogiri::HTML("<html><body>" + render_to_string(partial: "components/#{component}", layout: false) + "</body></html>")
    component_xml.css("[data-component='#{component}'] [data-dynamic]").map { |element| element.to_s.split("\n").map(&:strip).join }
  end
end
