# Modified hungarian algorithm to find matches
# array_to_solve.hungarian == solution_array
# array_to_solve is an array of arrays--i.e. a matrix in array form
# solution_array is a set of ordered pairs (n, m) such that n is the number of a row in matrix_to_solve and m is the assignment in that row
# solution_array.measure will add all of the values of the assignments in the solution

# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
require 'matrix'


def hungarian
	ORIGINAL_MATRIX = self
	# makes a copy of the input matrix
	WORKING_MATRIX = self.clone

	# ensure self matrix has same number of elements in each row...
	# ensure self matrix has only integers in each row, and that each row contains each integer...

	# creates an empty matrix the same size as the original
	columns = ORIGINAL_MATRIX.column_count
	rows = ORIGINAL_MATRIX.row_count
	ASSIGNING_MATRIX = Matrix.build(rows, columns) {}

	# first two steps of algorithm
	if max_row_assignment <= max_col_assignment
		WORKING_MATRIX.zero_each_row
		WORKING_MATRIX.zero_each_column
	else
		WORKING_MATRIX.zero_each_column
		WORKING_MATRIX.zero_each_row
	end

	# third step in algorithm
		# find problematic rows if they exist
		other_zeros = []
		WORKING_MATRIX.columns_over_max.each do |col_index|
			WORKING_MATRIX.rows_with_zeros_in_column(col_index).each do |row_index|
				zero_columns = []
				WORKING_MATRIX.row(row_index).each_with_index do |value, index|
					if (value == 0) && (index != col_index)
						zero_columns << index
					end
				end
				other_zeros << [col_index row_index, zero_columns]
			end
		end

		def	min_row_assignments_possible 
			return self.row_count * self.min_row_assignment
		end

		def max_column_assignments_possible
			possible_assignments = 0
			self.columns.each do |column|
				if column.count_with_value(0) >= self.max_col_assignment
					possible_assignments = possible_assignments + self.max_col_assignment
				else
					possible_assignments = possible_assignments + column.count_with_value(0)
				end
			end
			return possible_assignments
		end
		
		def solveable?
			if self.min_row_assignments_possible > self.max_column_assignments_possible
				return false
			else
				return true
			end
		end

		min_col_assignments_possible > self.max_row_assingments_possible

		first count rows with just the min zeros in them
			# returns an array containing coordinates of each zero that lies in a row with the minimum number of assinable zeros
			def minimum_zeros_in_rows
				zeros_of_interest = []
				self.rows.each_with_index do |row, row_index|
					if row.count_with_value(0) = self.min_row_assignment
						row.each_with_index do |cell, col_index|
							if cell == 0
								zeros_of_interest << [row_index, col_index]
							end
						end
					end
				end
				return zeros_of_interest
			end	

		then count columns with just the min zeros in them
			# returns an array containing coordinates of each zero that lies in a column with the minimum number of assinable zeros
			def minimum_zeros_in_columns
				zeros_of_interest = []
				self.columns.each_with_index do |column, col_index|
					if column.count_with_value(0) = self.min_col_assignment
						column.each_with_index do |cell, row_index|
							if cell == 0
								zeros_of_interest << [row_index, col_index]
							end
						end
					end
				end
				return zeros_of_interest
			end	

		if count all of the unique cells in those two collections; if that number is more than the max assignments possible
			then you have a problem

			def solveable?
				required_zeros = WORKING_MATRIX.minimum_zeros_in_columns | WORKING_MATRIX.minimum_zeros_in_rows

					




		
		# resolve problematic rows if they exist

	# returns an array of indices of rows with zeros in the specified column index
	def rows_with_zeros_in_column(column_index)
	# outputs array of column indexes such that each column contains more zeros than could be assigned in that column
	def columns_over_max
	# counts number of cells with the given value in a row or column, must call on Vector
	def count_with_value(value)
	# subtracts the lowest value in each row from each member of that row, must call on Matrix
	def zero_each_row
	# subtracts the lowest value in each column from each member of that column, must call on Matrix
	def zero_each_column
	# returns an array of the rows in the Matrix it's called on
	def rows
	# returns an array of the columns in the Matrix it's called on
	def columns




JUST USE MATRICES! Tells you how to access matrix values, AND change them: http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
	matrix.clone = creates a new matrix identical to the old one, not just a new name
	matrix.row_count = number of rows
	matrix.column_count = number of columns
	matrix.row(j) = outputs j-th row in matrix
	matrix.row(j)[k] = outputs the k-th element in the j-th row, i.e. row j column k
	matrix[j,k] = outputs element in the j-th row, in the kth column
	matrix.column(k) = outputs k-th column
	matrix.to_a = converts matrix into an array of arrays
	matrix.send( :[]=,j,k,m) = saves value m to the cell in row j, column k
	matrix.row(k).min = returns the minimum value in the kth row; use the same method on columns
	matrix.row(k).max = returns the max value in the kth row; use the same method on columns
	m.row(k).each_with_index do |value, index| = iterates through each index/value pair in row k, index must be listed second



end


# HELPER METHODS




class Vector
	# counts number of cells with the given value in a row or column
	def count_with_value(value)
		count = 0
			self.each do |cell|
				count = (count + 1) unless (cell != value)
			end
		return count
	end

end

class Matrix
	# allows you to change values in matrix
	# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
	def []=(row, column, value)
		@rows[row][column] = value
	end

	# CONSTRAINTS
	# ceil rounds a float up to the nearest integer
	def max_col_assignment 
		(self.row_count.fdiv(self.column_count)).ceil
	end

	def max_row_assignment
		return 1
	end

	def min_row_assignment
		return 1
	end

	def min_col_assignment
		return 1
	end

	# returns an array of the rows in the Matrix it's called on
	def rows
		row_index = 0
		rows = []
		while row_index < self.row_count
			rows << self.row(row_index)
			row_index = row_index + 1
		end
		return rows
	end

	# returns an array of the columns in the Matrix it's called on
	def columns
		col_index = 0
		columns = []
		while col_index < self.column_count
			columns << self.column(col_index)
			col_index = col_index + 1
		end
		return columns
	end


	# returns an array of indices of rows with zeros in the specified column index
	def rows_with_zeros_in_column(column_index)
		rows = []
		self.rows.each_with_index do |row, index|
			if row[column_index] == 0
				rows << index
			end
		end
		return rows
	end

	#returns an array of arrays [n, m] where n is the column index and m is the number of zeros
	def zeros_per_column
		result = []
		self.columns.each_with_index do |column, index|
			result << [index, self.column(index).count_with_value(0)]
		end
		return result
	end

	# outputs array of column indexes for whatever columns contain more zeros than could be assigned in that column
	def columns_over_max
		columns_over = []
		self.zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				columns_over << array[0]
			end
		end
		return columns_over
	end

	# subtracts the lowest value in each row from each member of that row
	def zero_each_row
		self.rows.each_with_index do |row, row_index|
			min = row.min
			row.each_with_index do |value, col_index|
				self.send( :[]=,row_index,col_index,value-min )
			end
		end
		return self
	end

	# subtracts the lowest value in each column from each member of that column
	def zero_each_column
		self.columns.each_with_index do |column, column_index|
			min = column.min
			column.each_with_index do |value, row_index|
				self.send( :[]=,row_index,col_index,value-min )
			end
		end
		return self
	end

end

