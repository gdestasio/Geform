class Criterium < ActiveRecord::Base
	enum operator: { "add" => 0, "mult" => 1 }
	has_many :options, :foreign_key => :criteria_id
end
