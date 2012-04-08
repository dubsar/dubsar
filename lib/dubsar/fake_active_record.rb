# Class to override some basic Activerecord methods so we can "fake" an AR model
# # and get all the good stuff (i.e. validations) without having to make a table.
# # Use the +column+ class method to define fields in your model.
module Fake
	class  Table < ActiveRecord::Base
		def self.columns
			@columns ||= [];
		end

		def self.column(name, sql_type = nil, default = nil, null = true)
			columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
		end

		def save(validate = true)
			validate ? valid? : true
		end
	end
end
