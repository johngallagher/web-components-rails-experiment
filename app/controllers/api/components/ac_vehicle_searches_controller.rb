class Api::Components::AcVehicleSearchesController < ApplicationController
  def show
    @ac_vehicle_search = ::Components::AcVehicleSearch.new(params: params)
    render json: {
      component: @ac_vehicle_search.name,
      replacements: @ac_vehicle_search.dependencies.map { |dependency| replacement_for(dependency) } 
    }
  end

  private

  def replacement_for dependency
    { 
      replace: dependency,
      with_content: render_to_string(partial: "components/#{dependency}") 
    }
  end
end
