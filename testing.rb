require 'matrix'

m = Matrix[[0,2,0,4,5,5],[9,4,4,8,8,8]]

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

	def zero_each_row
		self.rows.each_with_index do |row, row_index|
			min = row.min
			print "row.min returns #{row.min}\n"
			row.each_with_index do |value, col_index|
				self.send( :[]=, row_index, col_index, value-min )
			end
		end
	end

	def max_col_assignment 
		(self.row_count.fdiv(self.column_count)).ceil
	end

	def rows_with_zeros_in_column(column_index)
		rows = []
		self.rows.each_with_index do |row, index|
			if row[column_index] == 0
				rows << index
			end
		end
		return rows
	end

	def zeros_per_column
		result = []
		self.columns.each_with_index do |column, index|
			result << [index, self.column(index).count_with_value(0)]
		end
		return result
	end

	def columns_over_max
		columns_over = []
		self.zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				columns_over << array[0]
			end
		end
		return columns_over
	end

	def rows
		row_index = 0
		rows = []
		while row_index < self.row_count
			rows << self.row(row_index)
			row_index = row_index + 1
		end
		return rows
	end

	def columns
		col_index = 0
		columns = []
		while col_index < self.column_count
			columns << self.column(col_index)
			col_index = col_index + 1
		end
		return columns
	end

end

print "#{m}\n"
print "m.zero_each_row returns #{m.zero_each_row}\n"
print "m.columns returns #{m.columns}\n"
print "m.columns[0] returns #{m.columns[0]}\n"
print "m.rows returns #{m.rows}\n"
print "m.rows[1][0] returns #{m.rows[1][0]}\n"
print "m.rows_with_zeros_in_column(2) returns #{m.rows_with_zeros_in_column(2)}\n"
print "m.max_col_assignment is #{m.max_col_assignment}\n"
print "row(0).count_with_value(5) returns #{m.row(0).count_with_value(5)}\n"
print "m.row(1).count_with_value(8) returns #{m.row(1).count_with_value(8)}\n"
print "m.column(0).count_with_value(1) returns #{m.column(0).count_with_value(1)}\n"
print "m.column(1).count_with_value(4) returns #{m.column(1).count_with_value(4)}\n"
print "m.zeros_per_column returns #{m.zeros_per_column}\n"
print "m.columns_over_max returns #{m.columns_over_max}\n"