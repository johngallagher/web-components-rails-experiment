class Components::AcVehicleSearch
  attr_reader :vehicles, :makes, :models, :count, :search_types, :title, :total_number_of_pages, :current_page
  def initialize(state:)
    url = "http://www.arnoldclark.com/used-cars/search.json?search_type=#{state[:search_type]}&make=#{state[:make]}&model=#{state[:model]}&page=#{state[:page]}"
    response = JSON.parse(open(url).read)
    @vehicles = response["searchResults"].map { |result| OpenStruct.new(result) }
    @makes = response["searchCriteria"]["availableOptions"]["makes"]
    @models = response["searchCriteria"]["availableOptions"]["models"]
    @count = response["count"]
    @search_types = response["searchCriteria"]["availableOptions"]["searchTypes"]
    @title = response["title"]
    @state = state
    @total_number_of_pages = response["pagination"]["totalNumberOfPages"]
    @current_page = response["pagination"]["currentPage"]
  end
end
