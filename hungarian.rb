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

	# constraints
	# ceil rounds a float up to the nearest integer
	max_row_assignment = 1
	min_row_assignment = 1
	max_col_assignment = (rows/columns).ceil
	min_col_assignment = 1

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
		

		# outputs array of column indexes such that each column contains more zeros than could be assigned in that column
		def columns_over_max
			i = 0
			columns_over = []
			while i < self.column_count
				# adds each column over the max number of zeros to the columns_over array
				self.column(i).zeros_per_column.each do |index, num_zeros|
					if num_zeros > max_col_assignment
						columns_over_max << index
					end
				end
				i = i + 1
			end
			return columns_over
		end


			You only have to look at columns that contain more zeros than max_col_assignment
			Then check those columns to see if any of the rows that have zeros in them have no other zeros (more complicated...)


		min_assignments = min_row_assignment * WORKING_MATRIX.row_count





		# resolve problematic rows if they exist



	# counts number of cells with the given value in a row or column, must call on Vector
	def count_with_value(value)
	# subtracts the lowest value in each row from each member of that row, must call on Matrix
	def zero_each_row
	# subtracts the lowest value in each column from each member of that column, must call on Matrix
	def zero_each_column





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

	#returns an array of arrays [n, m] where n is the column index and m is the number of zeros
	def zeros_per_column
		i = 0
		result = []
		while i < self.column_count
			result << [i, self.column(i).count_with_value(0)]
			i = i + 1
		end
		return result
	end

	# outputs array of column indexes for whatever columns contain more zeros than could be assigned in that column
	def columns_over_max
		i = 0
		columns_over = []
		while i < self.column_count
			# adds each column over the max number of zeros to the columns_over array
			self.column(i).zeros_per_column.each do |index, num_zeros|
				if num_zeros > max_col_assignment
					columns_over_max << index
				end
			end
			i = i + 1
		end
		return columns_over
	end

	# subtracts the lowest value in each row from each member of that row
	def zero_each_row
		i = 0
		rows = self.row_count
		while i < rows do
			min = self.row(i).min
			self.row(i).each_with_index do |value, index|
				self.send( :[]=, i, index, value-min )
			end
			i = i + 1
		end
	end

	# subtracts the lowest value in each column from each member of that column
	def zero_each_column
		i = 0
		columns = self.column_count
		while i < columns do
			min = self.column(i).min
			self.column(i).each_with_index do |value, index|
				self.send( :[]=, index, i, value-min )
			end
			i = i + 1
		end
	end
end


