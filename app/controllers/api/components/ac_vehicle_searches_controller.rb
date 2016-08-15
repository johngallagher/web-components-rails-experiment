class Api::Components::AcVehicleSearchesController < ApplicationController
  def show
    @ac_vehicle_search = ::Components::AcVehicleSearch.new(params: params)
    render json: {
      component: "ac_vehicle_search",
      replacements: [{ 
        replace: "ac_vehicle_search_results",
        with_content: render_to_string(partial: "components/ac_vehicle_search_results")
      },
      { 
        replace: "ac_vehicle_search_filter",
        with_content: render_to_string(partial: "components/ac_vehicle_search_filter")
      },
      {
        replace: 'ac_vehicle_search_banner',
        with_content: render_to_string(partial: "components/ac_vehicle_search_banner")
      }]
    }
  end
end
