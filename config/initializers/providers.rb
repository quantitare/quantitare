Provider.instance_variable_set('@registry', {}.with_indifferent_access)

Provider.register(
  :foursquare, 'FOURSQUARE_OAUTH_KEY', 'FOURSQUARE_OAUTH_SECRET',
  strategy_class: OmniAuth::Strategies::Foursquare,

  icon_css_class: 'fab fa-foursquare',
  icon_text_color: '#fff',
  icon_bg_color: '#2d5be3'
)

Provider.register(
  :lastfm, 'LASTFM_OAUTH_KEY', 'LASTFM_OAUTH_SECRET',
  strategy_class: OmniAuth::Strategies::Lastfm,

  icon_css_class: 'fab fa-lastfm',
  icon_text_color: '#fff',
  icon_bg_color: '#b90000'
)

Provider.register(
  :withings2, 'WITHINGS_OAUTH_KEY', 'WITHINGS_OAUTH_SECRET',
  strategy_class: OmniAuth::Strategies::Withings2,

  client_id: ENV['WITHINGS_OAUTH_KEY'],

  scope: 'user.activity,user.metrics,user.info',
  redirect_uri: ENV['WITHINGS_REDIRECT_URI'], # TODO: remove this for production purposes

  icon_css_class: 'fas fa-heartbeat',
  icon_text_color: '#fff',
  icon_bg_color: '#22ea9d'
)
