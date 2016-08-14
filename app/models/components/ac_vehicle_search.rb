class Components::AcVehicleSearch
  attr_reader :vehicles, :makes, :models, :count, :search_types, :title
  def initialize(make:, model:, search_type:)
    url = "http://www.arnoldclark.com/used-cars/search.json?search_type=#{search_type}&make=#{make}&model=#{model}"
    response = JSON.parse(open(url).read)
    @vehicles = response["searchResults"].map { |result| OpenStruct.new(result) }
    @makes = response["searchCriteria"]["availableOptions"]["makes"]
    @models = response["searchCriteria"]["availableOptions"]["models"]
    @count = response["count"]
    @search_types = response["searchCriteria"]["availableOptions"]["searchTypes"]
    @title = response["title"]
  end
end
