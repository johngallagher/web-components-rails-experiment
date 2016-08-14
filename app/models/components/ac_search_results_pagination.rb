class Components::AcSearchResultsPagination
  attr_reader :total_number_of_pages, :current_page
  PATH = "/vehicles"

  def initialize(params:, total_number_of_pages:, current_page:)
    @params = params
    @total_number_of_pages = total_number_of_pages
    @current_page = current_page
  end

  def first_page? 
    @current_page == 1
  end

  def last_page? 
    @current_page == @total_number_of_pages
  end

  def first_page_link
    if first_page?
    %Q{
      <span class="ac-pagination__button ac-pagination__button--first ac-pagination--disabled">First
      </span>
    }.html_safe
    else
    %Q{
      <a data-page-number="1" href="#{page_path(1)}" class="ac-pagination__button ac-pagination__button--first">First
      </a>
    }.html_safe
    end
  end

  def previous_page_link
    if first_page?
    %Q{
      <span class="ac-pagination__button ac-pagination__button--previous ac-pagination--disabled">Previous
      </span>
    }.html_safe
    else
    %Q{
      <a data-page-number="#{@current_page - 1}" href="#{page_path(@current_page - 1)}" class="ac-pagination__button ac-pagination__button--previous">Previous
      </a>
    }.html_safe
    end
  end

  def page_link page_number
    if page_number == @current_page
    %Q{
      <span class="ac-pagination__link ac-pagination__link--current ac-pagination--disabled">#{page_number}
      </span>
    }.html_safe
    else
      %Q{
      <a data-page-number="#{page_number}" href="#{page_path(page_number)}" class="ac-pagination__link">#{page_number}
      </a>
      }.html_safe
    end
  end

  def next_page_link
    if last_page? 
    %Q{
      <span class="ac-pagination__button ac-pagination__button--next ac-pagination--disabled">Next
      </span>
    }.html_safe
    else
    %Q{
      <a data-page-number="#{@current_page + 1}" href="#{page_path(@current_page + 1)}" class="ac-pagination__button ac-pagination__button--next">Next
      </a>
    }.html_safe
    end
  end


  def last_page_link
    if last_page? 
    %Q{
      <span class="ac-pagination__button ac-pagination__button--last ac-pagination--disabled">Last
      </span>
    }.html_safe
    else
    %Q{
      <a data-page-number="#{@total_number_of_pages}" href="#{page_path(@total_number_of_pages)}" class="ac-pagination__button ac-pagination__button--last">Last
      </a>
    }.html_safe
    end
  end

  private

  def page_path page_number
    "#{PATH}?make=#{@params['make']}&model=#{@params['model']}&search_type=#{@params['search_type']}&page=#{page_number}"
  end

end
