module Components
  class AcVehicleSearch
    attr_reader :vehicles, :makes, :models, :count, :search_types, :title, :total_number_of_pages, :current_page, :current_options

    def initialize(params:)
      #before_search = Time.now
      whitelisted_params = params.permit('make', 'model', 'search_type', 'age', 'transmission', 'fuel_type', 'distance').to_h
      url = "http://www.arnoldclark.com/used-cars/search.json?#{whitelisted_params.to_query}"
      response = JSON.parse(open(url).read)
      Rails.logger.debug("Url we called is #{url}")
      #response = JSON.parse(dummy_json)
      #after_search = Time.now
      #Rails.logger.debug("Time to search #{(after_search - before_search) * 1000}")

      @vehicles = response["searchResults"].map { |result| OpenStruct.new(result) }
      @makes = response["searchCriteria"]["availableOptions"]["makes"]
      @models = response["searchCriteria"]["availableOptions"]["models"]
      @count = response["count"]
      @search_types = response["searchCriteria"]["availableOptions"]["searchTypes"]
      @title = response["title"]
      @total_number_of_pages = response["pagination"]["totalNumberOfPages"]
      @current_page = response["pagination"]["currentPage"].to_i
      @current_options = response["searchCriteria"]["currentOptions"].inject({}) { |memo, (key, value)| memo.merge(key.to_s.underscore.to_sym => value) }
    end

    def state
      @current_options
    end
  end
end

