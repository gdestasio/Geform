class City < ActiveRecord::Base
   default_scope { order('name ASC') }
end
