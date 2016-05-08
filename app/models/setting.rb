# RailsSettings Model
class Setting < RailsSettings::CachedSettings
  resourcify
  source Rails.root.join("config/app.yml")
  namespace Rails.env
end
