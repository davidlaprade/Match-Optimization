# Modified hungarian algorithm to optimize matches
# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/

# see http://www.tutorialspoint.com/ruby/ruby_modules.html under "Ruby require statement" to see how this works
$LOAD_PATH << '.'
require 'matrix'
require 'matrix_class_additions'

# called on Matrix object, returns an array of coordinates, one for each assignment in the optimal match
def hungarian
	# these assignments are going to pose problems for the following reason: http://stackoverflow.com/questions/6712298/dynamic-constant-assignment
	ORIGINAL_MATRIX = self
	WORKING_MATRIX = self.clone
	ASSIGNING_MATRIX = Matrix.build(self.row_count, self.column_count) {}

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
	while WORKING_MATRIX.solveable? != true
		while WORKING_MATRIX.solveable? == "no, too many lonely zeros in columns"
			# to fix: isolate the lonely zeros causing the problem, take each row they occur in, 
			# find the lowest member in that row besides the zero, add the value of that member to each zero, 
			# subtract it from every other member (including itself)
			WORKING_MATRIX.fix_too_many_lonely_zeros_in_columns
			# Running the fix method might result in a matrix with the same problem, so run solveable? method again
			# Repeat until the matrix no longer has too many lonely zeros in columns
			# It does not seem possible to get a problematic matrix that will cause this loop to continue infinitely
		end

		while WORKING_MATRIX.solveable? == "no, too many lonely zeros in rows"
			# to fix: isolate the lonely zeros causing the problem, take each column they occur in
			# find the lowest member in that column besides the zero, add the value of that lowest member to each zero,
			# subtract the value of that lowest member from every other member (including itself)
			WORKING_MATRIX.fix_too_many_lonely_zeros_in_rows
			# Running the fix method might result in a matrix with the same problem, so run solveable? method again
			# Repeat until the matrix no longer has too many lonely zeros in rows
			# It does not seem possible to get a problematic matrix that will cause this loop to continue infinitely
		end

		while WORKING_MATRIX.solveable? == "no, min permitted row assignments > max column assignments possible"
			# to fix: if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix
			# find the lowest value-sans-zero in the submatrix, then subtract that value from every member-sans-zero of the row in which it occurs
			# do this only as many times as you need to make min permitted row assignments <= max column assignments possible

			1. Find problematic submatrices
				2. In each such submarix, identify the minimum value-sans-zero
				3. Subtract the min-sans-zero from every member-sans-zero of the row in which it occurs
			4. Repeat until min permitted row assignments <= max column assignments possible

			PROBLEM: it could be that running the 

			def make_more_column_assignments_possible
				# checks to see if the minimum allowable row assignments is greater than the maximum number of column assignments
				# if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix, the parent matrix is unsolveable
				# run this test first, as you want to fix it last (the solveable? method will return the failure code of the last test it fails)
				matrix_in_array_format = self.to_a
				test_cases = matrix_in_array_format.every_combination_of_its_members
				# find the problematic submatrices
				problematic_submatrices = []
				test_cases.each do |submatrix_in_array_format|
					min_row_assignments_permitted = self.min_row_assignment * submatrix_in_array_format.length
					if min_row_assignments_permitted > submatrix_in_array_format.max_column_assmts_possible(self.max_col_assignment)
						problematic_submatrices << submatrix_in_array_format
					end
				end
				# In each problematic submarix, identify the minimum value-sans-zero
				problematic_submatrices.each do |submatrix|
					# get min-sans-zero value for each row in submatrix
					row_id_plus_row_min = []
					submatrix.each_with_index do |row, row_id|
						row.delete(0)
						row_id_plus_row_min << [row_id, row.min]
					end
					# order row_id_plus_row_min by increasing row.min value
					row_id_plus_row_min = row_id_plus_row_min.sort { |x,y| x[1] <=> y[1] }
					# Subtract the min-sans-zero from every member-sans-zero of the row in which it occurs
					# Repeat until min permitted row assignments <= max column assignments possible
					min_row_assignments_permitted = self.min_row_assignment * submatrix.length
					i = min_row_assignments_permitted - submatrix.max_column_assmts_possible(self.max_col_assignment)

						PROBLEM: it could be that the find_by_matching_row_then_subtract method will only add zeros in ONE additional column
						(It might be that the min-sans-zero value occurs in the same column in each row of the submatrix)  
						And, if it turns out that the submatrix min_row_assignments is TWO larger than the max_col_assignments possible
						then using a the variable i to monitor this loop will not be enough

					while i > 0
						row_to_match = submatrix[row_id_plus_row_min[0][0]]
						value_to_subtract = row_id_plus_row_min[0][1]
						self.find_matching_row_then_subtract_value(row_to_match, value_to_subtract)
						row_id_plus_row_min.shift
						i = i + 1
					end
				end
				return self
			end


					# called on Matrix; finds all rows matching the row_to_match (data type: array) given as first parameter;
					# subtracts input value from each member of each row matching the row_array, skips over zeros
					def find_matching_row_then_subtract_value(row_to_match, value_to_subtract)
						self.rows.each_with_index do |matrix_row, matrix_row_index|
							if matrix_row == row_to_match
								matrix_row.each_with_index do |cell_value, matrix_column_index|
									if cell_value != 0
										self.send( :[]=, matrix_row_index, matrix_column_index, cell_value - value_to_subtract )
									end
								end
							end
						end
						return self
					end


								self.rows[matrix_row_index].each_with_index do |value, matrix_column_index|
									if value != 0
										self.send( :[]=,matrix_row_index, matrix_column_index, value - row_id_plus_row_min[0][1] )
									end
								end
							end
						end




			4. Repeat until min permitted row assignments <= max column assignments possible


		end

	end

	# fourth step in algorithm
		# make the assignments!




	# returns an array of arrays [n,m] where n is the row index and m is the number of lonely zeros in the row
	def lonely_zeros_per_row
	# returns an array of arrays [n,m] where n is the column index and m is the number of lonely zeros in the column
	def lonely_zeros_per_column
	# returns an array of coordinates [n,m] of every lonely zero in the Matrix it is called on
	# a lonely zero is one which occurs as the sole zero in EITHER its row or its column
	def lonely_zeros
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
	# called on matrix object, for each row specified in params, adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited matrix object it was called on
	def zero_fewest_problematic_rows(problematic_rows)
	# outputs array of arrays [n,m,o] where n is the index of a column with too many lonely zeros
	# m is the number of lonely zero's in column n
	# and o is an ORDERED array that contains arrays [p,q] where p is a row index of a lonely zero in column n, 
	# and q is the min value in that row other than zero, ordered by ascending q value
	def get_problematic_rows_per_problematic_column
	# called on Matrix object, takes row index and value as inputs
	# outputs Matrix in which the value provided has been added to each zero and subtracted otherwise
	def add_value_if_zero_else_subtract_value_in_rows(row_index, value)
	# called on Matrix object, takes column index and value as inputs
	# outputs Matrix in which the value provided has been added to each zero in the column and subtracted otherwise
	def add_value_if_zero_else_subtract_value_in_columns(col_index, value)
	# called on Matrix object; outputs array of arrays [n,m,o] where n is the index of a row with too many lonely zeros
	# m is the number of lonely zero's in row n
	# and o is an ORDERED array that contains arrays [p,q] where p is a column index of a lonely zero in row n, 
	# and q is the min value in that column other than zero, ordered by ascending q value
	def get_problematic_columns_per_problematic_row
	# called on Matrix object; takes as input an array of arrays [n,m,o] where n is a row index, m is the number of lonely zeros in that row
	# and o is an ordered array of arrays [p,q] where p is the column index of a lonely zero in row n, and q is the min value in that column other than zero
	# see method "get_problematic_columns_per_problematic_row" for a convenient way to get a parameter like this
	# for each member of the array passed to this method as a parameter, the method adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited matrix object it was called on
	def zero_fewest_problematic_columns(problematic_columns)
	# self explanatory
	def fix_too_many_lonely_zeros_in_rows



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
	# perhaps allow the user to set these values eventually

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
		rows = self.to_a
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

	# returns an array of arrays [n,m] where n is the row index and m is the number of lonely zeros in the row
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

	# returns failure code if the matrix has no solution in its current state, true if the matrix passes the tests
	def solveable?
		failure_code = true

		# checks to see if the minimum allowable row assignments is greater than the maximum number of column assignments
		# if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix, the parent matrix is unsolveable
		# run this test first, as you want to fix it last (the solveable? method will return the failure code of the last test it fails)
		matrix_in_array_format = self.to_a
		test_cases = matrix_in_array_format.every_combination_of_its_members
		test_cases.each do |submatrix_in_array_format|
			min_row_assignments_permitted = self.min_row_assignment * submatrix_in_array_format.length
			if min_row_assignments_permitted > submatrix_in_array_format.max_column_assmts_possible(self.max_col_assignment)
				failure_code = "no, min permitted row assignments > max column assignments possible"
			end
		end

		# how this works:
			# 	turn matrix into an array
			# 	populate array of every combination of the matrix_array rows
			# 	for each member of the combination array:
			# 		find min row assignments permitted
			# 		find max column assignments possible
			# 		check if min_row_assmts_permitted > max_col_assmts_poss
			# 			return false
		# this seems to catch all of the cases where min allowable column assignments > max num of possible row assignments
		# so I didn't write a corresponding test for that

		# checks to see if there are too many lonely zeros in any row
		self.lonely_zeros_per_row.each do |array|
			if array[1] > self.max_row_assignment
				failure_code = "no, too many lonely zeros in rows"
			end
		end

		# checks to see if there are too many lonely zeros in any column
		self.lonely_zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				failure_code = "no, too many lonely zeros in columns"
			end
		end

		return failure_code

	end

	# called on Matrix object, takes row index and value as inputs
	# outputs Matrix in which the value provided has been added to each zero and subtracted otherwise
	def add_value_if_zero_else_subtract_value_in_rows(row_index, value)
		if !(self.rows[row_index] == nil)
			self.rows[row_index].each_with_index do |cell_value, col_index|
				if cell_value == 0
					self.send( :[]=,row_index, col_index, value )
				else
					self.send( :[]=,row_index, col_index, (cell_value - value) )
				end
			end
		end
		return self
	end

	# called on Matrix object; outputs array of arrays [n,m,o] where n is the index of a column with too many lonely zeros
	# m is the number of lonely zero's in column n
	# and o is an ORDERED array that contains arrays [p,q] where p is a row index of a lonely zero in column n, 
	# and q is the min value in that row other than zero, ordered by ascending q value
	def get_problematic_rows_per_problematic_column
		problematic_rows = []
		self.lonely_zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				col_index = array[0]
				num_lonely_zeros = array[1]
				rows = []
				self.lonely_zeros.each do |lonely_zero_coordinates|
					row_id = lonely_zero_coordinates[0]
					if col_index == lonely_zero_coordinates[1]
						row_array = self.row(row_id).to_a
						row_array.delete(0)
						row_min_sans_zero = row_array.min
						rows << [row_id, row_min_sans_zero]
					end
				end
				rows = rows.sort { |x,y| x[1] <=> y[1] }
				problematic_rows << [col_index, num_lonely_zeros, rows]
			end
		end
		return problematic_rows
	end

	# called on Matrix object, for each row specified in params, adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited matrix object it was called on
	def zero_fewest_problematic_rows(problematic_rows)
		# problematic rows must be an array of arrays [n,m,o], one for each problematic column
		# n is the column index, m is the number of lonely zeros in column n
		# o is an ORDERED array containing all arrays [p,q] where p is the row index of a row containing a lonely zero in column n
		# and q is the minimum value in that row-sans-zero; o is ordered by ascending q value
		# the "get_problematic_rows_per_problematic_column" method returns exactly this array
		problematic_rows.each do |array|
			i = 0
			while array[1] > self.max_col_assignment
				self.add_value_if_zero_else_subtract_value_in_rows(array[2][i][0], array[2][i][1])
				array[1] = array[1] - 1
				i = i + 1
			end
		end
		return self
	end

	def fix_too_many_lonely_zeros_in_columns
		# isolate the columns that are causing the problem, then the rows in those columns that contain their lonely zeros
		# PROBLEM: it could be that there are multiple columns with too many lonely zeros, e.g. one col might have 4, another 2
			# and if the max col assignment were 1, you would want to add_value_if_zero to 3 of the 4 rows in the first group
			# and only 1 of the 2 rows in the second group
			# so you need some way of keeping track of these groups
		problematic_rows = self.get_problematic_rows_per_problematic_column
		# now make the fewest changes necessary to remove the problem, and determine which row to correct based on the other values in that row
		# you want to correct the row with the lowest min value first, then the row with the next lowest, then with the next lowest, and so on
		# point is: you want to minimize the extent to which you have to lower values to get an assignment
		self.zero_fewest_problematic_rows(problematic_rows)
	end

	# called on Matrix object, takes column index and value as inputs
	# outputs Matrix in which the value provided has been added to each zero in the column and subtracted otherwise
	def add_value_if_zero_else_subtract_value_in_columns(col_index, value)
		if !(self.columns[col_index] == nil)
			self.columns[col_index].each_with_index do |cell_value, row_index|
				if cell_value == 0
					self.send( :[]=,row_index, col_index, value )
				else
					self.send( :[]=,row_index, col_index, (cell_value - value) )
				end
			end
		end
		return self
	end

	# called on Matrix object; outputs array of arrays [n,m,o] where n is the index of a row with too many lonely zeros
	# m is the number of lonely zero's in row n
	# and o is an ORDERED array that contains arrays [p,q] where p is a column index of a lonely zero in row n, 
	# and q is the min value in that column other than zero, ordered by ascending q value
	def get_problematic_columns_per_problematic_row
		problematic_columns_per_problematic_row = []
		self.lonely_zeros_per_row.each do |array|
			if array[1] > self.max_row_assignment
				row_index = array[0]
				num_lonely_zeros = array[1]
				columns = []
				self.lonely_zeros.each do |lonely_zero_coordinates|
					col_id = lonely_zero_coordinates[1]
					if row_index == lonely_zero_coordinates[0]
						col_array = self.column(col_id).to_a
						col_array.delete(0)
						column_min_sans_zero = col_array.min
						columns << [col_id, column_min_sans_zero]
					end
				end
				columns = columns.sort { |x,y| x[1] <=> y[1] }
				problematic_columns_per_problematic_row << [row_index, num_lonely_zeros, columns]
			end
		end
		return problematic_columns_per_problematic_row
	end

	# called on Matrix object; takes as input an array of arrays [n,m,o] where n is a row index, m is the number of lonely zeros in that row
	# and o is an ordered array of arrays [p,q] where p is the column index of a lonely zero in row n, and q is the min value in that column other than zero
	# see method "get_problematic_columns_per_problematic_row" for a convenient way to get a parameter like this
	# for each member of the array passed to this method as a parameter, the method adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited matrix object it was called on
	def zero_fewest_problematic_columns(problematic_columns)
		problematic_columns.each do |array|
			i = 0
			while array[1] > self.max_row_assignment
				self.add_value_if_zero_else_subtract_value_in_columns(array[2][i][0], array[2][i][1])
				array[1] = array[1] - 1
				i = i + 1
			end
		end
		return self
	end

	def fix_too_many_lonely_zeros_in_rows
		# isolate the rows that are causing the problem, then the columns in those rows that contain their lonely zeros
		# PROBLEM: it could be that there are multiple rows with too many lonely zeros, e.g. one row might have 4, another 2
			# and if the max row assignment were 1, you would want to add_value_if_zero to 3 of the 4 columns in the first group
			# and only 1 of the 2 columnss in the second group; so you need some way of keeping track of these groups
		problematic_columns = self.get_problematic_columns_per_problematic_row
		# now make the fewest changes necessary to remove the problem, and determine which column to correct based on the other values in that column
		# you want to correct the column with the lowest min value first, then the column with the next lowest, then with the next lowest, and so on
		# point is: you want to minimize the extent to which you have to lower values to get an assignment
		self.zero_fewest_problematic_columns(problematic_columns)
	end

end

