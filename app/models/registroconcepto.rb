class Registroconcepto < ActiveRecord::Base
	belongs_to :persona
	belongs_to :conceptopersonal
end
