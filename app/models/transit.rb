class Transit < ActiveRecord::Base
	belongs_to :user
	belongs_to :event
	enum operation: {'I' => 0, 'U' => 1}
end
