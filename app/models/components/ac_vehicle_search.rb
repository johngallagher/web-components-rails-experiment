require 'json'
require 'open-uri'
require 'active_support/core_ext/hash/keys'
require 'active_support/inflector/methods'

class Component
  def name
    self.class.to_s.gsub(/^Components::/, "").underscore.gsub("/", "__")
  end

  def data_attributes
    { component: name }
  end
end

module Components
  class AcVehicleSearch < Component

    attr_reader :vehicles, :makes, :models, :count, :search_types, :title, :total_number_of_pages, :current_page, :current_options
    def initialize(params:)
      url = "http://www.arnoldclark.com/used-cars/search.json?search_type=#{params[:search_type]}&make=#{params[:make]}&model=#{params[:model]}&page=#{params[:page].to_i}"
      response = JSON.parse(open(url).read)
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

    def data_attributes
      super.merge(current_options)
    end
  end
end

