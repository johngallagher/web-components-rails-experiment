class ComponentUpdatesController < ApplicationController
  def show
    @ac_vehicle_search = Components::AcVehicleSearch.new(params: params)
    components_to_reload = JSON.parse(params['onchange_reload'])
    render json: {
      component: "ac_vehicle_search_filter",
      replacements: components_to_reload.map { |component| { replace: component, with_content: render_to_string(partial: "components/#{component}", layout: false) } }
    }
  end
end
