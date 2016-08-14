class Api::Components::AcVehicleSearchLoadingsController < ApplicationController
  def show
    render json: [
      { 
        replace: "ac_spinner",
        with_content: render_to_string(partial: "components/ac_spinner", locals: { loading: true })
      }
    ]
  end
end
