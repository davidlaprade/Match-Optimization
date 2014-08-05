require 'matrix'

m = Matrix[[0,2,0,4,5,5],[0,4,6,8,8,8]]

max_row_assignment = 1
min_row_assignment = 1
min_col_assignment = 1

class Vector
def count_with_value(value)
	count = 0
		self.each do |cell|
			count = (count + 1) unless (cell != value)
		end
	return count
end
end

class Matrix

	def max_col_assignment 
		(self.row_count/self.column_count).ceil
	end

	def zeros_per_column
		i = 0
		result = []
		while i < self.column_count
			result << [i, self.column(i).count_with_value(0)]
			i = i + 1
		end
		return result
	end

	def columns_over_max
		i = 0
		columns_over = []
		while i < self.column_count
			# adds each column over the max number of zeros to the columns_over array
			self.zeros_per_column.each do |array|
				if array[1] > self.max_col_assignment
					columns_over_max << array[0]
				end
			end
			i = i + 1
		end
		return columns_over
	end
end

print "#{m}\n"
print "max_col_assignment is #{max_col_assignment}\n"
print "row(0).count_with_value(5) returns #{m.row(0).count_with_value(5)}\n"
print "m.row(1).count_with_value(8) returns #{m.row(1).count_with_value(8)}\n"
print "m.column(0).count_with_value(1) returns #{m.column(0).count_with_value(1)}\n"
print "m.column(1).count_with_value(4) returns #{m.column(1).count_with_value(4)}\n"
print "m.columns_over_max returns #{m.columns_over_max}\n"