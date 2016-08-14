class Api::Components::AcVehicleSearchesController < ApplicationController
  def show
    @ac_vehicle_search = ::Components::AcVehicleSearch.new(params: params)
    render json: [
      { 
        replace: "ac_vehicle_search_results",
        with_content: render_to_string(partial: "components/ac_vehicle_search_results")
      },
      { 
        replace: "ac_vehicle_search_filter",
        with_content: render_to_string(partial: "components/ac_vehicle_search_filter")
      }
    ]
  end
end
