Provider.instance_variable_set('@registry', {}.with_indifferent_access)

Provider.register(
  :foursquare, 'FOURSQUARE_OAUTH_KEY', 'FOURSQUARE_OAUTH_SECRET',
  strategy_class: OmniAuth::Strategies::Foursquare,

  icon_css_class: 'fab fa-foursquare',
  icon_text_color: '#fff',
  icon_bg_color: '#2d5be3'
)
