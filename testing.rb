require 'matrix'


# new challenge for solveablility: the following matrix does not have too many lonely zeros in any column or row
	# m = Matrix[[0,3,0],[0,5,0],[0,1,0]]
# m = Matrix[[1,1,7,0,4,5,6,3],[7,4,2,0,6,3,7,1],[6,1,7,0,4,7,1,2]]
# m = Matrix[[1,5],[1,5],[1,4]]
# m = Matrix[[1,2],[2,1]]
# m = Matrix[[0,2,0,4,5,5],[0,4,0,8,8,8]]
m = Matrix[[8,3,5,2,7,1,6,4], [1,6,5,4,2,8,3,7], [2,3,8,1,5,6,7,4], [7,3,6,4,1,8,5,2],
              [3,7,2,8,1,6,4,5], [7,2,1,3,4,6,8,5], [8,7,2,3,4,1,5,6]]
# m = Matrix[[5,0,3],[4,0,2],[8,0,8]]


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
		(self.row_count.fdiv(self.column_count)).ceil
	end

	def max_row_assignment
		(self.column_count.fdiv(self.row_count)).ceil
	end

	def min_row_assignment
		return 1
	end

	def min_col_assignment
		return 1
	end


	def lonely_zeros
		zeros = []
		self.rows.each_with_index do |row, row_index|
			row.each_with_index do |cell, col_index|
				if cell == 0 && (self.row(row_index).count_with_value(0) == 1 || self.column(col_index).count_with_value(0) == 1)
					zeros << [row_index, col_index]
				end
			end
		end
		return zeros
	end

	def lonely_zeros_per_column
		zeros_per_column = []
		self.columns.each_with_index do |column, col_index|
			zeros = 0
			self.lonely_zeros.each do |array|
				if array[1] == col_index
					zeros = zeros + 1
				end
			end
			zeros_per_column << [col_index, zeros]
		end
		return zeros_per_column
	end

	def lonely_zeros_per_row
		zeros_per_row = []
		self.rows.each_with_index do |row, row_index|
			zeros = 0
			self.lonely_zeros.each do |array|
				if array[0] == row_index
					zeros = zeros + 1
				end
			end
			zeros_per_row << [row_index, zeros]
		end
		return zeros_per_row
	end

	def min_row_assmts_permitted
		self.min_row_assignment * self.row_count
	end

	def min_column_assmts_permitted
		self.min_col_assignment * self.column_count
	end

	def max_column_assmts_possible
		number_of_max_assignments = 0
		self.columns.each do |column|
			if column.count_with_value(0) > self.max_col_assignment
				number_of_max_assignments = number_of_max_assignments + self.max_col_assignment
			else 
				number_of_max_assignments = number_of_max_assignments + column.count_with_value(0)
			end
		end
		return number_of_max_assignments
	end

	def max_row_assmts_possible
		number_of_max_assignments = 0
		self.rows.each do |row|
			if row.count_with_value(0) > self.max_row_assignment
				number_of_max_assignments = number_of_max_assignments + self.max_row_assignment
			else 
				number_of_max_assignments = number_of_max_assignments + row.count_with_value(0)
			end
		end
		return number_of_max_assignments
	end

	# returns false if the matrix has no solution in its current state, nil if the matrix passes the tests
	def solveable?
		# checks to see if there are too many lonely zeros in any column
		self.lonely_zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				return false
			end
		end

		# checks to see if there are too many lonely zeros in any row
		self.lonely_zeros_per_row.each do |array|
			if array[1] > self.max_row_assignment
				return false
			end
		end

		if self.min_row_assmts_permitted > self.max_column_assmts_possible
			return false
		end

		if self.min_column_assmts_permitted > self.max_row_assmts_possible
			return false
		end

	end

	def print_in_readable_format
		print "\n\n"
		self.rows.each do |row|
			print "#{row.to_a}\n"
		end
		print "\n\n"
	end

	def zero_each_row
		self.rows.each_with_index do |row, row_index|
			min = row.min
			row.each_with_index do |value, col_index|
				self.send( :[]=,row_index,col_index,value-min )
			end
		end
		return self
	end

	def zero_each_column
		self.columns.each_with_index do |column, column_index|
			min = column.min
			column.each_with_index do |value, row_index|
				self.send( :[]=,row_index,col_index,value-min )
			end
		end
		return self
	end

	def zero_each_column
		self.columns.each_with_index do |column, col_index|
			min = column.min
			column.each_with_index do |value, row_index|
				self.send( :[]=,row_index,col_index,value-min )
			end
		end
		return self
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



# m.print_in_readable_format
# m.zero_each_row
# print "m.zero_each_row returns:"
# m.print_in_readable_format
# m.zero_each_column
# print "m.zero_each_column returns:"
# m.print_in_readable_format

# print "m.max_col_assignment returns #{m.max_col_assignment}\n"
# print "m.max_row_assignment returns #{m.max_row_assignment}\n"

# print "m.solvable? #{m.solveable?}\n\n"
# print "m.lonely_zeros returns #{m.lonely_zeros}\n\n"
# print "m.lonely_zeros_per_column returns #{m.lonely_zeros_per_column}\n\n"
# print "m.lonely_zeros_per_row returns #{m.lonely_zeros_per_row}\n\n"

# print "m.columns returns #{m.columns}\n"
# print "m.columns[0] returns #{m.columns[0]}\n"
# print "m.rows returns #{m.rows}\n"
# print "m.rows[1][0] returns #{m.rows[1][0]}\n"
# print "m.rows_with_zeros_in_column(2) returns #{m.rows_with_zeros_in_column(2)}\n"
# print "m.max_col_assignment is #{m.max_col_assignment}\n"
# print "row(0).count_with_value(5) returns #{m.row(0).count_with_value(5)}\n"
# print "m.row(1).count_with_value(8) returns #{m.row(1).count_with_value(8)}\n"
# print "m.column(0).count_with_value(1) returns #{m.column(0).count_with_value(1)}\n"
# print "m.column(1).count_with_value(4) returns #{m.column(1).count_with_value(4)}\n"
# print "m.zeros_per_column returns #{m.zeros_per_column}\n"
# print "m.columns_over_max returns #{m.columns_over_max}\n"