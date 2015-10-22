class TrainingPlan < ActiveRecord::Base

	enum status: { "Inattivo" => 0, "Attivo" => 1}
end
