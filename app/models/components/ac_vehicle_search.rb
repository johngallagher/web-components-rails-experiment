class Components::AcVehicleSearch
  attr_reader :vehicles, :makes, :models
  def initialize(make:, model:, params:)
    @make = make
    @model = model
    @params = params
    url = "http://www.arnoldclark.com/used-cars/search.json?make=#{@make}&model=#{@model}"
    search_response = JSON.parse(open(url).read)
    @vehicles = search_response["searchResults"].map { |result| OpenStruct.new(result) }
    @makes = search_response["searchCriteria"]["availableOptions"]["makes"]
    @models = search_response["searchCriteria"]["availableOptions"]["models"]
  end
end
