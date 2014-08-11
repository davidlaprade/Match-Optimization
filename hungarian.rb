# Modified hungarian algorithm to optimize matches
# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/

# see http://www.tutorialspoint.com/ruby/ruby_modules.html under "Ruby require statement" to see how this works
$LOAD_PATH << '.'
require 'matrix'
require 'matrix_class_additions'


def hungarian
	# these assignments are going to pose problems for the following reason: http://stackoverflow.com/questions/6712298/dynamic-constant-assignment
	ORIGINAL_MATRIX = self
	WORKING_MATRIX = self.clone
	ASSIGNING_MATRIX = Matrix.build(self.row_count, self.column_count) {}

	# ensure self matrix has same number of elements in each row...
	# ensure self matrix has only integers in each row, and that each row contains each integer...

	# first two steps of algorithm
	if WORKING_MATRIX.row_count >= WORKING_MATRIX.column_count
		WORKING_MATRIX.zero_each_row
		WORKING_MATRIX.zero_each_column
	else
		WORKING_MATRIX.zero_each_column
		WORKING_MATRIX.zero_each_row
	end

	# third step in algorithm
		# is the Working Matrix solvable?
		if WORKING_MATRIX.solveable? == 1
			# if it fails test 1, need to fix the matrix accordingly
			# TEST1 - checks to see if there are too many lonely zeros in any column
				# to fix: isolate the lonely zeros causing the problem, take each row they occur in, 
				# find the lowest member in that row besides the zero, add the value of that member to each zero, 
				# subtract it from every other member (including itself)
		elsif WORKING_MATRIX.solveable? == 2
			# if it fails test 2, need to fix the matrix accordingly
			# TEST2 - checks to see if there are too many lonely zeros in any row
		elsif WORKING_MATRIX.solveable? == 3
			# if it fails test 3, need to fix the matrix accordingly
			# TEST3 - checks to see if the minimum allowable row assignments is greater than the maximum number of column assignments
				# if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix, the parent matrix is unsolveable
		
		else
			# is solveable
		end











	# returns an array containing coordinates of each zero that lies in a row with the minimum number of assinable zeros
	def lonely_zeros_in_rows
	# returns an array containing coordinates of each zero that lies in a column with the minimum number of assinable zeros
	def lonely_zeros_in_columns
	# returns false if the matrix has no solution in its current state, nil if the matrix passes the test
	def solveable?
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


	first count min row assignments allowable, e.g. num_rows x min_row_assignment



	second, count max column assignemnts possible
		count zeros in each column, assign up to the max_col_assignment
	if the first number is greater than the second, the matrix isnt solveable

	then look for the inverse property for rows




# JUST USE MATRICES! Tells you how to access matrix values, AND change them: http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
# 	matrix.clone = creates a new matrix identical to the old one, not just a new name
# 	matrix.row_count = number of rows
# 	matrix.column_count = number of columns
# 	matrix.row(j) = outputs j-th row in matrix
# 	matrix.row(j)[k] = outputs the k-th element in the j-th row, i.e. row j column k
# 	matrix[j,k] = outputs element in the j-th row, in the kth column
# 	matrix.column(k) = outputs k-th column
# 	matrix.to_a = converts matrix into an array of arrays
# 	matrix.send( :[]=,j,k,m) = saves value m to the cell in row j, column k
# 	matrix.row(k).min = returns the minimum value in the kth row; use the same method on columns
# 	matrix.row(k).max = returns the max value in the kth row; use the same method on columns
# 	m.row(k).each_with_index do |value, index| = iterates through each index/value pair in row k, index must be listed second



end


#--------------------- HELPER METHODS-----------------------------------------------------
class Array
	# returns an array containing just the rows of the target array that are specified in the rows argument
	# rows argument is an array of row indexs
	# def create_new_array_using_rows(rows)
	# 	new_array = []
	# 	self.each_with_index do |row, index|
	# 		if rows.include?(index) == true
	# 			new_array << row
	# 		end
	# 	end
	# 	return new_array
	# end

	# returns an array containing every combination of members of the array it was called on
	def every_combination_of_its_members
		combination_class = []
		i = 2
		while i <= self.length do
			new_members = self.combination(i).to_a
			new_members.each do |member|
				combination_class << member
			end
			i = i + 1
		end
		return combination_class
	end

	# outputs the maximum number of assignments that could be made in columns given the current distribution of values and the max permitted column assignment
	# does not take into account row assignments or loneliness; must be called on an array
	def max_column_assmts_possible(max_col_assignment)
		number_of_max_assignments = 0
		self.array_columns.each do |column|
			if column.array_count_with_value(0) > max_col_assignment
				number_of_max_assignments = number_of_max_assignments + max_col_assignment
			else 
				number_of_max_assignments = number_of_max_assignments + column.array_count_with_value(0)
			end
		end
		return number_of_max_assignments
	end

	# counts number of cells with the given value in an array
	def array_count_with_value(value)
		count = 0
			self.each do |cell|
				count = (count + 1) unless (cell != value)
			end
		return count
	end

	# outputs an ordered array of arrays, each of which containing a column from the array it is called on
	# column and row indexes were preserved: array_columns[0][2] returns the cell in the 1st column in the 3rd row 
	def array_columns
		columns = []
		i = 0
		while i < self[0].length
			column_i = []
			self.each do |row|
				column_i << row[i]
			end
			columns << column_i
			i = i + 1
		end
		return columns
	end

end

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

# Eventually you're going to want to add this to a new document titled "matrix_class_additions"
class Matrix
	# allows you to change values in matrix, see http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
	def []=(row, column, value)
		@rows[row][column] = value
	end

	# CONSTRAINTS----------------------------------------
	def max_col_assignment 
		# ceil rounds a float up to the nearest integer
		(self.row_count.fdiv(self.column_count)).ceil
	end

	def max_row_assignment
		# ceil rounds a float up to the nearest integer
		(self.column_count.fdiv(self.row_count)).ceil
	end

	def min_row_assignment
		return 1
	end

	def min_col_assignment
		return 1
	end
	# -----------------------------------------------------

	# returns an array of the rows (data type: vectors) in the Matrix it's called on
	def rows
		row_index = 0
		rows = []
		while row_index < self.row_count
			rows << self.row(row_index)
			row_index = row_index + 1
		end
		return rows
	end

	# returns an array of the columns (data type: vectors) in the Matrix it's called on
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

	# returns an array of coordinates [n,m] of every lonely zero
	# a lonely zero is one which occurs as the sole zero in EITHER its row or its column
	# number of lonely zeros
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

	# returns an array of arrays [n,m] where n is the column index and m is the number of lonely zeros in the column
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

	# returns an array of arrays [n,m] where n is the column index and m is the number of lonely zeros in the column
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

	# outputs the lowest permitted number of row assignments
	def min_row_assmts_permitted
		self.min_row_assignment * self.row_count
	end

	# outputs the lowest permitted number of column assignments
	def min_column_assmts_permitted
		self.min_col_assignment * self.column_count
	end

	# outputs the maximum number of assignments that could be made in columns given the current distribution of values 
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

	# outputs the maximum number of assignments that could be made in rows given the current distribution of values 
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

		# checks to see if the minimum allowable row assignments is greater than the maximum number of column assignments
		# if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix, the parent matrix is unsolveable
		matrix_in_array_format = self.to_a
		test_cases = matrix_in_array_format.every_combination_of_its_members
		test_cases.each do |submatrix_in_array_format|
			min_row_assignments_permitted = self.min_row_assignment * submatrix_in_array_format.length
			if min_row_assignments_permitted > submatrix_in_array_format.max_column_assmts_possible(self.max_col_assignment)
				return false
			end
		end

			# how this is going to work:
			# 	turn matrix into an array
			# 	populate array of every combination of the matrix_array rows
			# 	for each member of the combination array:
			# 		find min row assignments permitted
			# 		find max column assignments possible
			# 		check if min_row_assmts_permitted > max_col_assmts_poss
			# 			return false

		# Now do the same thing for columns!!!



		# to be effective, this needs to check isolated parts of the matrix
		# checks to see if the minimum allowable row assignments is greater than the maximum number of column assignments
		if self.min_column_assmts_permitted > self.max_row_assmts_possible
			return false
		end

	end



end

