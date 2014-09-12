require 'matrix'
require 'pry'
require 'benchmark'



class Array
	# ARRAY FRIENDLY, BUT COULD REFACTOR TO SIMPLIF + TESTED
	# called on Array object, takes column index and value as inputs
	# outputs Array in which the value provided has been added to each zero in the column and subtracted otherwise
	def add_value_if_zero_else_subtract_value_in_columns(col_index, value)
		if !(self.array_columns[col_index] == nil)
			self.array_columns[col_index].each_with_index do |cell_value, row_index|
				if cell_value == 0
					self[row_index][col_index] = value
				else
					self[row_index][col_index] = cell_value - value
				end
			end
		end
		return self
	end

	# ARRAY FRIENDLY + TESTED
	def add_value_if_zero_else_subtract_value_in_rows(row_index, value)
		if !(self[row_index] == nil)
			self[row_index].each_with_index do |cell_value, col_index|
				if cell_value == 0
					self[row_index][col_index] = value
				else
					self[row_index][col_index] = cell_value - value
				end
			end
		end
		return self
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

	# UNTESTED
	# called on array; outputs the number of columns in the array
	def column_count
		return self.transpose.length
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

	# ARRAY FRIENDLY + TESTED
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
						row_array = self[row_id].dup
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
						col_array = self.transpose[col_id].dup
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

	# ARRAY FRIENDL + TESTED
	def get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible
		test_cases = self.every_combination_of_its_members
		problematic_submatrices = []
		min_row_assign = self.min_row_assignment
		max_col = self.max_col_assignment
		test_cases.collect {|x| min_row_assign * x.length > x.max_column_assmts_possible(max_col) ? problematic_submatrices << x : x}
		return problematic_submatrices
	end

	# ARRAY FRIENDLY
	# returns an array containing every combination of members of the array it was called on
	def every_combination_of_its_members
		return self.each_with_index.map {|x,i| self.combination(i+1).to_a}.flatten(1).drop(self.length).uniq
	end

	# ARRAY FRIENDL + TESTED
	def find_matching_row_then_subtract_value(row_to_match, value_to_subtract)
		return self.map! {|row| row==row_to_match ? row.map {|value| value!=0 ? value - value_to_subtract : value}  : row}
	end

	# ARRAY FRIENDLY + TESTED
	def fix_too_many_lonely_zeros_in_columns
		problematic_rows = self.get_problematic_rows_per_problematic_column
		self.zero_fewest_problematic_rows(problematic_rows)
	end

	# ARRAY FRIENDLY + TESTED
	def fix_too_many_lonely_zeros_in_rows
		problematic_columns = self.get_problematic_columns_per_problematic_row
		self.zero_fewest_problematic_columns(problematic_columns)
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# called on Array object; returns an array of coordinates [n,m] of every lonely zero
	# a lonely zero is one which occurs as the sole zero in EITHER its row or its column
	# number of lonely zeros
	def lonely_zeros
		zeros = []
		self.each_with_index do |row, row_index|
			row.each_with_index do |cell, col_index|
				if cell == 0 && (self[row_index].count(0) == 1 || self.transpose[col_index].count(0) == 1)
					zeros << [row_index, col_index]
				end
			end
		end
		return zeros
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# called on Array object; returns an array of arrays [n,m] where n is the row index and m is the number of lonely zeros in the row
	def lonely_zeros_per_row
		zeros = []
		self.map.with_index {|row,i| zeros<<[i, row.find_all.with_index {|value,col_index| value==0 && self.transpose[col_index].count(0)==1}.count]}
		return zeros
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# called on Array object; returns an array of arrays [n,m] where n is the column index and m is the number of lonely 
	# zeros in the column
	def lonely_zeros_per_column
		zeros = []
		self.transpose.map.with_index {|col,i| zeros<<[i, col.find_all.with_index {|value,row_index| value==0 && self[row_index].count(0)==1}.count]}
		return zeros
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# passed an array object (Hungarian.working_matrix); minimally changes the array to return an array which supports complete assignment
	def make_matrix_solveable(working_matrix)
		# the algorithm runs 2 orders of magnitute faster when there are fewer rows than columns
		# so, just transpose the array to create an array with more columns than rows
		dup = working_matrix.dup
		working_matrix = working_matrix.transpose if dup.row_count > dup.column_count

		while working_matrix.solveable? != "true"
			# you want to include the following two methods in case the methods below them change the Matrix in such a way
			# as to remove a lonely zero from a row/column
			if working_matrix.solveable?.include?("no, there are rows without zeros")
				working_matrix = working_matrix.zero_each_row
			end

			while working_matrix.solveable?.include?("no, there are columns without zeros")
				working_matrix = working_matrix.zero_each_column
			end

			while working_matrix.solveable?.include?("no, too many lonely zeros in columns")
				# to fix: isolate the lonely zeros causing the problem, take each row they occur in, 
				# find the lowest member in that row besides the zero, add the value of that member to each zero, 
				# subtract it from every other member (including itworking_matrix)
				working_matrix.fix_too_many_lonely_zeros_in_columns
				# Running the fix method might result in a matrix with the same problem, so run solveable? method again
				# Repeat until the matrix no longer has too many lonely zeros in columns
				# It does not seem possible to get a problematic matrix that will cause this loop to continue infinitely
			end

			while working_matrix.solveable?.include?("no, too many lonely zeros in rows")
				# to fix: isolate the lonely zeros causing the problem, take each column they occur in
				# find the lowest member in that column besides the zero, add the value of that lowest member to each zero,
				# subtract the value of that lowest member from every other member (including itworking_matrix)
				working_matrix.fix_too_many_lonely_zeros_in_rows
				# Running the fix method might result in a matrix with the same problem, so run solveable? method again
				# Repeat until the matrix no longer has too many lonely zeros in rows
				# It does not seem possible to get a problematic matrix that will cause this loop to continue infinitely
			end
			while working_matrix.solveable?.include?("no, min permitted row assignments > max column assignments possible")
				# to fix: if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix
				# find the lowest value-sans-zero in the submatrix, then subtract that value from every member-sans-zero of the row in which it occurs
				# do this only as many times as you need to make min permitted row assignments <= max column assignments possible
				
				working_matrix.make_more_column_assignments_possible
			end
		end

		# tanspose the matrix back into its original form if it was flipped
		working_matrix = working_matrix.transpose if dup.row_count > dup.column_count

		return working_matrix
	end

	# ARRAY FRIENDL + TESTED
	def make_more_column_assignments_possible
		problematic_submatrices = self.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible
		while !problematic_submatrices.empty?
			self.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(problematic_submatrices.first)
			problematic_submatrices = self.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible	
		end
		return self
	end

	# ARRAY FRIENDLY
	# TESTED
	# called on Array object; outputs the maximum number of assignments that could be made in columns given the current 
	# distribution of values and the max permitted column assignment; does not take into account row assignments or loneliness
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

	# ARRAY FRIENDLY
	# UNTESTED
	# CONSTRAINTS----------------------------------------
	# consider allowing the user to set these values eventually, or just making them attribtes of the Hungarian object
	# for now, though, it is easier to be able to call these as if they were attributes of the working_matrix attribute

	def max_col_assignment 
		return (self.row_count/self.column_count.to_f).ceil
	end

	def max_row_assignment
		return (self.column_count/self.row_count.to_f).ceil
	end

	def min_row_assignment
		return 1
	end

	def min_col_assignment
		return 1
	end
	# -----------------------------------------------------


	# UNTESTED
	# called on Array object; returns number of rows in array
	def row_count
		return self.length
	end

	# called on Array object; returns array in Matrix form
	def to_m
		return Matrix.columns(self.transpose)
	end

	# ARRAY FRIENDLY + TESTED
	def solveable?
		failure_code = []

		test_cases = self.every_combination_of_its_members
		test_cases.each do |submatrix|
			min_row_assignments_permitted = self.min_row_assignment * submatrix.length
			if min_row_assignments_permitted > submatrix.max_column_assmts_possible(self.max_col_assignment)
				failure_code.unshift("no, min permitted row assignments > max column assignments possible")
			end
		end

		self.lonely_zeros_per_row.each do |array|
			if array[1] > self.max_row_assignment
				failure_code.unshift("no, too many lonely zeros in rows")
			end
		end

		self.lonely_zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				failure_code.unshift("no, too many lonely zeros in columns")
			end
		end

		failure_code.unshift("no, there are columns without zeros") if self.transpose.collect {|col| col.include?(0)}.include?(false)
		failure_code.unshift("no, there are rows without zeros") if self.collect {|row| row.include?(0)}.include?(false)

		if !failure_code.empty?
			return failure_code
		else
			return "true"
		end

	end

	# ARRAY FRIENDLY + TESTED
	def subtract_min_sans_zero_from_rows_to_add_new_column_assignments(submatrix)
		row_id_plus_row_min = submatrix.get_ids_and_row_mins
		min_row_assignments_permitted = self.min_row_assignment * submatrix.length
		while min_row_assignments_permitted > submatrix.max_column_assmts_possible(self.max_col_assignment)
			row_id = row_id_plus_row_min[0][0]
			value_to_subtract = row_id_plus_row_min[0][1]
			self.find_matching_row_then_subtract_value(submatrix[row_id], value_to_subtract)
			submatrix.subtract_value_from_row_in_array(row_id, value_to_subtract)
			row_id_plus_row_min = submatrix.get_ids_and_row_mins
		end
		return self
	end

	# called on Array; subtracts the value given as second parameter from each member of the row specified, unless zero
	def subtract_value_from_row_in_array(row_id, value_to_subtract)
		raise 'Row does not exist in array' if row_id >= self.length || row_id < 0
		raise 'Would result in negative value' if self[row_id].dup.map {|x| x.zero? ? value_to_subtract : x}.min < value_to_subtract
		self[row_id].map! {|x| !x.zero? ? x-value_to_subtract : x }
		return self
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# called on Array object; subtracts the lowest value in each row from each member of that row, returns correct array
	def zero_each_row
		return self.each.map {|r| r.map {|v| v - r.min}}
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# called on Array object; subtracts the lowest value in each column from each member of that column, returns correct array
	def zero_each_column
		return self.transpose.each.map {|r| r.map {|v| v - r.min}}.transpose
	end

	# ARRAY FRIENDLY + TESTED
	def zero_fewest_problematic_rows(problematic_rows)
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

	# ARRAY FRIENDLY + TESTED
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

	# ARRAY FRIENDLY, TESTED
	# call on Array object; return Array object which has been normalized in rows and in columns
	def zero_rows_and_columns
		new_array = self.dup
		if new_array.row_count >= new_array.column_count
			new_array = new_array.zero_each_row
			new_array = new_array.zero_each_column
		else
			new_array = new_array.zero_each_column
			new_array = new_array.zero_each_row
		end
		return new_array
	end

end


# [[40,10], [10,40]].each do |v|
# 	# create 6x6 matrix filled with random elements
# 	array = Array.new(v[0]){Array.new(v[1]){rand(9)+1}}
# 	print "original array: #{v[0]}x#{v[1]}\n"
# 	# array.print_in_readable_format
# 	print "Time to get solution: %f seconds\n" % Benchmark.realtime { make_matrix_solveable(array) }.to_f
# 	print "solveable array:"
# 	array.print_in_readable_format
# 	print "--------------------------------------------------------\n"
# end