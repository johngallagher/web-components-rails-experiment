module ApplicationHelper
  def stylesheet_for_component(name)
    stylesheet = (Rails.application.assets || ::Sprockets::Railtie.build_environment(Rails.application)).find_asset("#{name}/#{name}").to_s
    "<style>#{stylesheet}</style>".html_safe
  end
end
