class MapZoom < Settingslogic
  source "#{Rails.root}/config/map_zoom.yml"
  namespace Rails.env
end
