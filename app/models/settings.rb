# RailsSettings Model
class Settings < RailsSettings::CachedSettings
  #source Rails.root.join("config/app.yml")
  namespace Rails.env
  resourcify
end
