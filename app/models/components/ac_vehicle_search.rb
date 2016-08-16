require 'json'
require 'open-uri'
require 'active_support/core_ext/hash/keys'
require 'active_support/inflector/methods'

module Components
  class AcVehicleSearch
    attr_reader :vehicles, :makes, :models, :count, :search_types, :title, :total_number_of_pages, :current_page, :current_options

    def initialize(params:)
      #before_search = Time.now
      url = "http://www.arnoldclark.com/used-cars/search.json?search_type=#{params[:search_type]}&make=#{params[:make]}&model=#{params[:model]}&page=#{params[:page].to_i}"
      response = JSON.parse(open(url).read)
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
      @current_options = response["searchCriteria"]["currentOptions"].symbolize_keys
    end

    def state
      @current_options
    end
  end
end

