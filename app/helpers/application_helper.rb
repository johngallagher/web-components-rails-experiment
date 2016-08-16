module ApplicationHelper
  def stylesheet_for_component(name)
    stylesheet = (Rails.application.assets || ::Sprockets::Railtie.build_environment(Rails.application)).find_asset("#{name}/#{name}.css").to_s
    "<style>#{stylesheet}</style>".html_safe
  end

  def javascript_for_component(name)
    javascript = (Rails.application.assets || ::Sprockets::Railtie.build_environment(Rails.application)).find_asset("#{name}/#{name}.js").to_s
    "<script>#{javascript}</script>".html_safe
  end
end
