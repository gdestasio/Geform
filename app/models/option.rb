class Option < ActiveRecord::Base
	belongs_to :criterium, :foreign_key => 'criteria_id'
end
