module Components
  class AcVehicleSearch
    FIELDS = ['make', 'model', 'search_type', 'age', 'transmission', 'fuel_type', 'distance', 'payment_type', 'min_price', 'max_price', 'location', 'photos_only', 'unreserved_only', 'keywords', 'body_type', 'mpg', 'colour', 'roadtax_cost', 'mileage', 'doors', 'seats', 'min_engine_size', 'max_engine_size', 'dor', 'branch_id', 'branch_name', 'sort_order']
    attr_reader :vehicles, :makes, :models, :count, :search_types, :title, :total_number_of_pages, :current_page, :current_options

    def initialize(params:)
      url = "http://www.arnoldclark.com/used-cars/search.json?#{params.permit(FIELDS).to_h.inject({}) { |memo, (field, value)| value == '[""]' ? memo.merge(field => '') : memo.merge(field => value) }.to_query}"
      response = JSON.parse(open(url).read)
      Rails.logger.debug("Url we called is #{url}")

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

