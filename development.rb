# Modified hungarian algorithm to optimize matches
# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/

# see http://www.tutorialspoint.com/ruby/ruby_modules.html under "Ruby require statement" to see how this works
$LOAD_PATH << '.'
require 'matrix'
require 'matrix_class_additions'

class Hungarian

	def intitialize(matrix, min_row_assignment, min_col_assignment)
		# this is the matrix that will be modified as the algorithm runs
		@working_matrix = matrix
		# keep a copy of the original, unchanged matrix in array form
		@original_form = matrix.to_a
		# quantifies the difference between the working matrix and its original form
		@degree_of_diff = 0
		# solution array: will contain coordinates of each assignment in the optimal match
		@solution = []
		attr_accessor :working_matrix, :original_form, :degree_of_diff, :solution

		@min_row_assignment = min_row_assignment unless min_row_assignment <= 0
		@min_col_assignment = min_col_assignment unless min_col_assignment <= 0
		@max_col_assignment = (matrix.row_count/matrix.column_count.to_f).ceil
		@max_row_assignment = (matrix.column_count/matrix.row_count.to_f).ceil
		attr_reader :min_row_assignment, :min_col_assignment, :max_col_assignment, :max_row_assignment

	end

	# call on Hungarian object; refreshes its degree_of_diff attribute; returns the updated Hungarian object
	def calc_degree_of_diff
		self.degree_of_diff = self.original_form.flatten.inject(:+) - self.working.to_a.flatten.inject(:+)
		return self
	end

	# call on Hungarian object; returns solution array containing coordinates of each assignment in the optimal match
	def solve
		# first two steps of algorithm
		# perform following opererations on working_matrix, save the result
			# if there are more rows than columns, or the same number, normalize (i.e. "zero") each row, then zero each column
			# if there are more columns than than rows, zero each column then zero each row
			# whatever gets zeroed first (rows, or columns) will end up with more zeros
		self.working_matrix = self.working_matrix.zero_rows_and_columns

		# third step in algorithm
			# check to see if the working matrix currently supports a complete assignment
			# if it doesn't, fix it so that it does, then calculate how much you've had to change the matrix to generate the solution
		self.working_matrix = self.working_matrix.make_matrix_solveable
		self.calc_degree_of_diff

		# fourth step in algorithm
			# the working matrix is solveable; so make the assignments!

	end




end


#--------------------- HELPER METHODS-----------------------------------------------------
class Array
	# returns an array containing every combination of members of the array it was called on
	def every_combination_of_its_members
		return self.each_with_index.map {|x,i| self.combination(i+1).to_a}.flatten(1).drop(self.length).uniq
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

	# called on array; outputs an ordered array of arrays, each of which containing a column from the array it is called on
	# column and row indexes were preserved: array_columns[0][2] returns the cell in the 1st column in the 3rd row 
	def array_columns
		return self.transpose
	end

	# called on submatrix Array; finds columns that do not contain zeros; outputs an ordered array of ALL arrays [p,q] where 
	# p is the index of a row in the submatrix, and q is a value in that row such that no zeros occur in that value's column
	# in the submatrix; the arrays are ordered by increasing q value, then by increasing row index
	def get_ids_and_row_mins
		col_wo_zeros = []
		self.array_columns.find_all {|column| !column.include?(0)}.each {|col| col.each_with_index {|v,i| col_wo_zeros << [i, v]} }
		return col_wo_zeros.uniq.sort_by {|x| [x[1],x[0]]}

		# PREVIOUS VERSION--TESTED
		# called on submatrix Array; outputs an ordered array of ALL arrays [p,q] where p is the index of a row in the submatrix
		# and q is a value in that row; the arrays are ordered by increasing q value, then by increasing row index
		# return self.collect.with_index {|x,i| x.collect{|y| !y.zero? ? [i,y] : y}-[0] }.flatten(1).uniq.sort_by {|x| [x[1],x[0]]}
	end

	# called on Array; subtracts the value given as second parameter from each member of the row specified, unless zero
	def subtract_value_from_row_in_array(row_id, value_to_subtract)
		raise 'Row does not exist in array' if row_id >= self.length || row_id < 0
		raise 'Would result in negative value' if self[row_id].dup.map {|x| x.zero? ? value_to_subtract : x}.min < value_to_subtract
		self[row_id].map! {|x| !x.zero? ? x-value_to_subtract : x }
		return self
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
	# better idea: just make hungarian a class, then set these as attributes

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
		return self.row_vectors
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

	# called on Matrix object; returns Matrix corrected such that min permitted row assignments <= max column assignments possible
	def make_more_column_assignments_possible
		# see commit f533448e9cec3ceedd for additional (and extensive) comments on the issues that went into developing this
		# //////////////////////////////////////////////
		# HOW THIS IS GOING TO WORK
		# 1. Find problematic submatrices
		# 	2. In each such submarix, identify the minimum value-sans-zero in each column that doesn't contain a zero
		# 	3. Identify the smallest such min-sans-zero
		# 		4. Subtract the smallest min-sans-zero from every member-sans-zero of the row in which it occurs
		# 5. Repeat step 1 until min permitted row assignments <= max column assignments possible
		# ////////////////////////////////////////////

		problematic_submatrices = self.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible
		# repeat the following until there are no problematic submatrices
		while !problematic_submatrices.empty?

			# fix the problem in the first submatrix
				# Subtract the min-sans-zero from every member-sans-zero of the row in which it occurs
				# Repeat until min permitted row assignments <= max column assignments possible
			self.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(problematic_submatrices.first)

			# run get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible again to see if the changes made fixed the issues
			problematic_submatrices = self.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible	
		end
		return self
	end

	# called on Matrix object, passed array that is a submatrix of the Matrix
	# makes changes to the Matrix it's called on, subtracting the smallest min-sans-zero value that resides in a column
	# that does not contain a zero in the submatrix from every
	# member in its row with the exception of zeros; changes the corresponding values in the Matrix;
	# repeats the process until min_row_permitted <= max_col_assignments_possible
	# returns the corrected Matrix object it was called on
	def subtract_min_sans_zero_from_rows_to_add_new_column_assignments(submatrix)

		# identify the minimum-sans-zero values for each row
		row_id_plus_row_min = submatrix.get_ids_and_row_mins

		min_row_assignments_permitted = self.min_row_assignment * submatrix.length
		while min_row_assignments_permitted > submatrix.max_column_assmts_possible(self.max_col_assignment)

			# edit the Matrix accordingly
			row_id = row_id_plus_row_min[0][0]
			value_to_subtract = row_id_plus_row_min[0][1]
			self.find_matching_row_then_subtract_value(submatrix[row_id], value_to_subtract)
			
			# edit the submatrix to check to see if the problem is fixed
			submatrix.subtract_value_from_row_in_array(row_id, value_to_subtract)

			# remove the first member of the array, it's been taken care of; move to second
			# the method has to be run again, since when you alter the submatrix you alter the values in its rows
			row_id_plus_row_min = submatrix.get_ids_and_row_mins

		end
		return self
	end

	# Call on Matrix object; returns array of submatrices (in array format) for which the number of minimum row assignments permitted
	# is greater than then number of possible column assignments
	def get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible
		# get every possible submatrix
		matrix_in_array_format = self.to_a
		test_cases = matrix_in_array_format.every_combination_of_its_members
		# find the problematic submatrices
		problematic_submatrices = []
		min_row_assign = self.min_row_assignment
		max_col = self.max_col_assignment
		test_cases.collect {|x| min_row_assign * x.length > x.max_column_assmts_possible(max_col) ? problematic_submatrices << x : x}
		# return result
		return problematic_submatrices
	end

	
	# called on Matrix; finds all rows matching the row_to_match (data type: array) given as first parameter;
	# subtracts input value from each member of each row matching the row_array, skips over zeros
	# returns corrected Matrix object
	def find_matching_row_then_subtract_value(row_to_match, value_to_subtract)
		self.to_a.each_with_index do |matrix_row, matrix_row_index|
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

	# UNTESTED
	# call on Matrix object; return Matrix object which has been normalized in rows and in columns
	def zero_rows_and_columns
		if self.row_count >= self.column_count
			self.zero_each_row
			self.zero_each_column
		else
			self.zero_each_column
			self.zero_each_row
		end
		return self
	end

	# UNTESTED
	# caled on Matrix object; changes the Matrix (if need be) to return a Matrix object which supports complete assignment
	def make_matrix_solveable
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
				WORKING_MATRIX.make_more_column_assignments_possible
			end
		end
		return self
	end

end

