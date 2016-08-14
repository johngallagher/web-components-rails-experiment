class Components::AcVehicleSearch
  attr_reader :vehicles, :makes, :models, :count, :search_types, :title, :total_number_of_pages, :current_page, :current_options
  def initialize(params:)
    url = "http://www.arnoldclark.com/used-cars/search.json?search_type=#{params[:search_type]}&make=#{params[:make]}&model=#{params[:model]}&page=#{params[:page].to_i}"
    Rails.logger.debug("URL is...")
    Rails.logger.debug(url)
    response = JSON.parse(open(url).read)
    @vehicles = response["searchResults"].map { |result| OpenStruct.new(result) }
    @makes = response["searchCriteria"]["availableOptions"]["makes"]
    @models = response["searchCriteria"]["availableOptions"]["models"]
    @count = response["count"]
    @search_types = response["searchCriteria"]["availableOptions"]["searchTypes"]
    @title = response["title"]
    @state = state
    @total_number_of_pages = response["pagination"]["totalNumberOfPages"]
    @current_page = response["pagination"]["currentPage"].to_i
  end
end
