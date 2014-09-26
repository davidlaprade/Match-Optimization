require 'matrix'
require 'pry'
require 'benchmark'

# passed mask Array object; assigns to needy zeros and extended needy zeros in the mask, then returns the mask
def assign_needy_zeros(mask)
	raise "Wrong kind of argument, requires an array" if mask.class != Array
	Matrix.columns(mask.transpose)
	while !mask.needy_zeros.empty?
		mask.needy_zeros.each {|coord| mask[coord[0]][coord[1]] = "!" }
		mask.cover_unassignables
	end
	return mask
end

# ARRAY FRIENDLY + MANUALLY TESTED
def make_matrix_solveable(working_matrix)

	working_matrix = working_matrix.zero_rows_and_columns

	solveable = working_matrix.solveable?
	
	while solveable != "true"
	
		while solveable == "no, not enough zeros in rows"
			working_matrix = working_matrix.zero_each_row
			solveable = working_matrix.solveable?
		end
	
		while solveable == "no, not enough zeros in columns"
			working_matrix = working_matrix.zero_each_column
			solveable = working_matrix.solveable?
		end
	
		while solveable == "no, too many lonely zeros in columns"
			working_matrix.fix_too_many_lonely_zeros_in_columns
			solveable = working_matrix.solveable?
		end
	
		while solveable == "no, too many lonely zeros in rows"
			working_matrix.fix_too_many_lonely_zeros_in_rows
			solveable = working_matrix.solveable?
		end

		while solveable == "no, min permitted row assignments > max column assignments possible"
			working_matrix.make_more_column_assignments_possible
			solveable = working_matrix.solveable?
		end
	
	end

	return working_matrix
end

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

	# called on array; outputs an ordered array of arrays, each of which containing a column from the array it is called on
	# column and row indexes were preserved: array_columns[0][2] returns the cell in the 1st column in the 3rd row 
	def array_columns
		return self.transpose
	end

	# UNTESTED
	# called on array; outputs the number of columns in the array
	def column_count
		return self.first.length
	end

	# UNTESTED
	# called on mask Array object; replaces unassignable zeros with "X"s, returns corrected array;
	def cover_unassignables
		# The idea is this: when there are enough assignments in a row/column to reach the maximum permissible, then other zeros 
		# which occur in that row/column cannot be assigned. So, since these zeros can't be assigned, replace them with "X"s

		# first check to see if there are zeros in ROWS with the max number of assignments; add Xs accordingly
		self.map! {|row| row.count("!") == self.max_row_assignment ?
			row.map {|value| value == 0 ? "X":value} : row
		}

		# now do the same thing for COLUMNS
		self.replace(
			self.transpose.map {|col| col.count("!") == self.max_col_assignment ?
				col.map {|value| value == 0 ? "X":value} : col
			}.transpose
		)

		return self
	end

	# called on array object; returns array of coordinates [p,q] such that each self[p][q] is an extra-lonely zero
	# an "extra lonely" zero is one which occurs as the only zero in both its row AND column
	def extra_lonely_zeros
		columns = self.transpose
		return self.lonely_zeros.select {|coord| self[coord[0]].count(0)==1 && columns[coord[1]].count(0)==1}
	end

	# ARRAY FRIENDLY + TESTED
	def get_ids_and_row_mins
		col_wo_zeros = []
		self.array_columns.find_all {|column| !column.include?(0)}.each {|col| col.each_with_index {|v,i| col_wo_zeros << [i, v]} }
		return col_wo_zeros.uniq.sort_by {|x| [x[1],x[0]]}
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

	# ARRAY FRIENDLY + TESTED
	# called on Array object; returns an array of coordinates [n,m] of every lonely zero
	# a lonely zero is one which occurs as the sole zero in EITHER its row or its column
	def lonely_zeros
		columns = self.transpose
		return self.each.with_index.with_object([]) {|(row, row_id), obj| 
			row.each.with_index {|value, col_id| obj<<[row_id,col_id] if value==0 && (self[row_id].count(0)==1 || columns[col_id].count(0)==1)
			}
		}
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
			if column.count(0) > max_col_assignment
				number_of_max_assignments = number_of_max_assignments + max_col_assignment
			else 
				number_of_max_assignments = number_of_max_assignments + column.count(0)
			end
		end
		return number_of_max_assignments
	end


	# CONSTRAINTS----------------------------------------
	# leave these as Array methods, don't set them to the hungarian object; you need to be able to access these values for the
	# array and each of its submatrices

	# every object on the x axis gets mapped to at least one object on the y
	# axis, and vice versa; perhaps sometimes the most optimal match is one in which an individual doesn't get matched; if so, 
	# then my algorithm won't catch it; I have to start somewhere

	# Formerly, I had just set min_row and min_col_assignment to 1 automatically. But it's not clear why I should have. If what
	# these values are supposed to be are the minimum/maximum number of assignments in an optimal match for the relevant array, 
	# then the minimums will seldom if ever be 1. In a square array, the min row/col assignments should be equal to the max row/col
	# assignments
	def max_col_assignment 
		return (self.row_count/self.column_count.to_f).ceil
	end

	def max_row_assignment
		return (self.column_count/self.row_count.to_f).ceil
	end

	def min_row_assignment
		assgn = (self.column_count/self.row_count.to_f).floor
		return assgn unless assgn < 1
		return 1
	end

	def min_col_assignment
		assgn = (self.row_count/self.column_count.to_f).floor
		return assgn unless assgn < 1
		return 1
	end
	# -----------------------------------------------------

	# TESTED
	def needy_zeros
		row_coordinates = self.each.with_index.with_object([]) {|(row,row_id), obj| 
			row.each_index {|col_id| 
				obj << [row_id, col_id] if row[col_id]==0 && (row.count("!")+row.count(0) <= self.min_row_assignment)

			}
		}

		return self.transpose.each.with_index.with_object(row_coordinates) {|(column, column_id), obj|
			column.each_index {|row_id|
				obj << [row_id, column_id] if column[row_id]==0 && (column.count("!")+column.count(0) <= self.min_col_assignment)
			}
		}.uniq.sort_by {|x| [x[0],x[1]]}
	end


	# UNTESTED
	# called on Array object; returns number of rows in array
	def row_count
		return self.length
	end

	# called on Array object; returns array in Matrix form
	def to_m
		return Matrix.columns(self.transpose)
	end

	# TESTED
	def reduce_problem
		columns = self.transpose.unshift(Array.new(self[0].length))
		# otherwise array.unshift will change the row values of the self array
		copy = self.map {|r| r.dup}

		# add array [p,q] to first member of each row, where p is the row_id, q is the # assignments needed to reach the minimum in that row
		copy.map.with_index {|row, row_id| 
			row.unshift([row_id, self.min_row_assignment - row.count("!")])
		}

		# add array [p,q] to top of each column, where p is the col_id, q is the # assignments needed to reach the minimum in that col
		copy.unshift(copy.transpose.each.with_index.with_object(["X"]) { |(col, col_id), new_col|
			new_col << [col_id-1, self.min_col_assignment - col.count("!")] if col_id > 0
		})

		# now strip off all the rows that already have met the max-assignment limit
		return copy.select {|row| row.count("!") < self.max_row_assignment
			# now strip off columns that have met the max_col_assignment
			}.transpose.select.with_index {|col, col_index| 
				columns[col_index].count("!") < self.max_col_assignment
					# getting rid of the columns might have left rows without zeros, get rid of them
					}.transpose.select.with_index {|row, row_id| row.include?(0) || row_id == 0
						# getting rid of the rows might have left cols without zeros, get rid of them
						}.transpose.select.with_index {|col, col_id| 
							col.include?(0) || col_id == 0 }.transpose
	end

	# TESTED
	# call on mask Array object; returns true if the mask represents a complete, acceptable assignment, false otherwise
	def solution?
		# complete assigns are those that have >= min row/col assignment, <= max row/col assignment
		# is that it???

		# so that you don't have to repeatedly call these methods within the select scripts below
		min_row_assignment = self.min_row_assignment
		max_row_assignment = self.max_row_assignment
		min_col_assignment = self.min_col_assignment
		max_col_assignment = self.max_col_assignment

		return self.select {|row| 
			row.count("!") < min_row_assignment || row.count("!") > max_row_assignment
		}.empty? && self.transpose.select {|col|
			col.count("!") < min_col_assignment || col.count("!") > max_col_assignment
		}.empty?
	end

	def solveable?
		if !self.select {|row| row.count(0) < self.min_row_assignment}.empty?
			return "no, not enough zeros in rows"
		elsif !self.transpose.select {|col| col.count(0) < self.min_col_assignment}.empty?
			return "no, not enough zeros in columns"
		end

		self.lonely_zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				return ("no, too many lonely zeros in columns")
			end
		end

		self.lonely_zeros_per_row.each do |array|
			if array[1] > self.max_row_assignment
				return "no, too many lonely zeros in rows"
			end
		end

		test_cases = self.every_combination_of_its_members
		test_cases.each do |submatrix|
			min_row_assignments_permitted = self.min_row_assignment * submatrix.length
			if min_row_assignments_permitted > submatrix.max_column_assmts_possible(self.max_col_assignment)
				return ("no, min permitted row assignments > max column assignments possible")
			end
		end
		return "true"
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

	# UNTESTED
	# called on Array object; checks to see if there are zeros in rows/columns that already have reached the max allowable assignments;
	# if there are, it replaces those zeros with "X"s in the array, then returns the changed array object
	def x_unassignables
		# first check to see if there are zeros in ROWS with the max number of assignments; add Xs accordingly
		self.map! {|row| row.count("!") == self.max_row_assignment ?
			row.map {|value| value == 0 ? "X":value} : row
		}

		# now do the same thing for COLUMNS
		self.replace(
			self.transpose.map {|col| col.count("!") == self.max_col_assignment ?
				col.map {|value| value == 0 ? "X":value} : col
			}.transpose
		)

		return self
	end

	# ARRAY FRIENDLY
	def zero_each_row
		while !self.select {|row| row.count(0) < self.min_row_assignment}.empty?
			self.map! {|row| 
				row.count(0) < self.min_row_assignment ? row.map {|v| v > 0 ? (v - (row-[0]).min) : v} : row
			}
		end
		return self
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# called on Array object; subtracts the lowest value in each column from each member of that column, repeats process until each
	# column contains at least enough zeros to support a minimum_column_assignment; then it returns the corrected array
	def zero_each_column
		return self.replace(self.transpose.zero_each_row.transpose)
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
		# find out which method will change the original array the least, then employ that method
		zero_rows_first = self.dup
		zero_cols_first = self.dup

		zero_rows_first.zero_each_row.zero_each_column
		diff_rows_first = (self.to_m - zero_rows_first.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+)

		zero_cols_first.zero_each_column.zero_each_row
		diff_cols_first = (self.to_m - zero_cols_first.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+)

		if diff_rows_first <= diff_cols_first
			self.zero_each_row.zero_each_column
		else
			self.zero_each_column.zero_each_row
		end

		return self
	end

	def print_readable
		print "\n"
		self.each do |row|
			print "#{row}\n"
		end
		print "\n"
	end


	# UNTESTED
	# called on mask array object AFTER calling assign_needy_zeros on it; reduces problem, assigns to mask based on reduction, 
	# returns finished mask assignment object; changes mask array
	def finish_assignment
		# repeat until there are no more zeros in the mask array
		while self.flatten(1).include?(0) == true
			self.make_next_assignment

			# making the assignment might have revealed new needy zeros, assign to them
			assign_needy_zeros(self)
		end
	end


	# TESTED
	# call on mask Array object; run reduce_problem on the object; use result to get
	# row/col with most assignments needed to reach min, in event of tie choice is random;
	# outputs array [p,q] where p is the row/col ID and q is the number of needed assignments; 
	# I don't care if there are multiple arrays that are identical to [p,q]
	def next_assignment
		# reduce problem places arrays [p,q] where p is a row/col index, q is number of assignments needed to reach max
		# we sort these arrays by descending q value

		array = self.reduce_problem.map {|row| 
			row.select {|value| value.class == Array}
		}.flatten(1).sort { |x,y| y[1] <=> x[1] }
		return array.select {|x| x[1] == array.first[1]}.sort_by {|x| x[0]}.first
	end

	# UNTESTED
	# called on mask Array object; gets array [p,q] from next_assignment, where p is a row/col ID and q is the number of needed assignments; finds that value first in row 0 of
	# the reduction array, and if not there then in col 0 of the reduction array; once found, it assigns to the zero with the fewest
	# other zeros in its respective row/col, in event of tie it assigns to zero closest to the top/left; then it makes the corresponding
	# assignment to the mask; then it reruns assign to needy zeros (abstract sub-methods from the assign_needy_zeros method)
	# returns array it was called on
	def make_next_assignment
		# exit the method if reduce_problem can find no issues
		reduction = self.reduce_problem
		return self if reduction == [["X"]]

		reduction_cols = reduction.transpose
		next_assignment = self.next_assignment
		check = self.dup

		# first try to find the assignment in rows
		reduction_cols.first.each.with_index do |value, row_id|
			if value == next_assignment
				# find each zero in the target row; output array of arrays [p,q] where p is the column ID of a zero in the
				# target row and q is the number of other zeros in its column; the [p,q] arrays are then sorted by 
				# ascending number of zeros in column
				zeros_in_row = reduction[row_id].each.with_index.with_object([]) {|(val,col_id), obj| 
					obj << [col_id, reduction_cols[col_id].count(0) - 1] if val == 0
				}.sort_by {|x| x[1]}

				# now get the coordinates of the zero in the mask array
				x = reduction[row_id][0][0]
				y = reduction[0][zeros_in_row.first[0]][0]

				# now assign the zero in the mask array
				rep = self.dup
				rep[x][y] = "!"
				self.replace(rep)

				# once you've made a change you want this loop to end
				break
			end
		end

		# if you've changed something in the self array, you want to skip this part, since you want to x_unassignables and repeat
		# before you make another assignment
		if check == self
			reduction.first.each.with_index do |value, col_id|
				if value == next_assignment
					# find each zero in the target column; output array of arrays [p,q] where p is the row ID of a zero in the
					# target column and q is the number of other zeros in its row; the [p,q] arrays are then sorted by 
					# ascending number of zeros in row
					zeros_in_column = reduction_cols[col_id].each.with_index.with_object([]) {|(val,row_id), obj| 
						obj << [row_id, reduction[row_id].count(0) - 1] if val == 0
					}.sort_by {|x| x[1]}

					# now get the coordinates of the zero in the mask array
					x = reduction[zeros_in_column.first[0]][0][0]
					y = reduction[0][col_id][0]

					# now assign the zero in the mask array
					rep = self.dup
					rep[x][y] = "!"
					self.replace(rep)

					# once you've made a change you want this loop to end
					break
				end
			end
		end

		# making an assignment above may have rendered some zeros unassignable, replace those zeros with x's
		self.x_unassignables

		return self
	end


end


# rows_first_wins = 0
# cols_first_wins = 0
# method_works = 0

# 10000.times do
# 	num_rows = rand(7)+3
# 	num_columns = num_rows + (rand(7)+3)
# 	a = Array.new(num_rows) {Array.new(num_columns) {rand(9)+1}}
# 	original = a.dup
# 	b = a.dup
# 	c = a.dup

# 	solutionA = a.zero_each_row.zero_each_column
# 	diffA = (original.to_m - solutionA.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+)
# 	# print "degree of difference when rows are zeroed first: #{diffA}\n"

# 	solutionB = b.zero_each_column.zero_each_row
# 	diffB = (original.to_m - solutionB.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+)
# 	# print "degree of difference when columns are zeroed first: #{diffB}\n"
# 	# print "--------------\n"

# 	# solutionC = c.zero_rows_and_columns
# 	# diffC = (original.to_m - solutionC.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+)

# 	rows_first_wins = rows_first_wins + 1 if diffA < diffB
# 	cols_first_wins = cols_first_wins +1 if diffB < diffA
# 	# method_works = method_works + 1 if diffC <= diffA && diffC <= diffB

# end

# print "When there are more columns than rows:\n"
# print "zeroing rows first wins #{100*rows_first_wins/10000}% of the time\n"
# print "zeroing columns first wins #{100*cols_first_wins/10000}% of the time\n"
# print "the two tie #{(100*(10000-rows_first_wins-cols_first_wins)/10000)}% of the time\n"
# print "my combined method works #{100*method_works/10000}% of the time\n"

# array = [[6,0,0,0,0,0],[0,5,6,7,9,3],[4,0,0,0,0,0]]
# array.print_readable
# solution = make_matrix_solveable(array)
# solution.print_readable

# [[5,5],[5,10],[5,15],[5,25],[5,40],[10,5],[10,10],[10,15],[10,25],[10,40],[15,5],[25,5],[40,5]]
# [[5,5],[7,7],[10,10],[12,12],[15,15],[16,16],[17,17],[18,18],[19,19],[20,20]]

# [[5,5],[5,10],[5,15],[5,25],[5,40],[10,5],[10,10],[10,15],[10,25],[10,40],[15,5],[25,5],[40,5],
# [40,10],[7,7],[10,10],[12,12],[15,15],[16,16],[17,17],[18,18],[19,19],[20,20]]

# [[5,6],[7,5],[4,7],[9,5],[10,12]]



# print [[4,0,0,4,1,5,1],[0,4,4,4,6,0,3],[5,1,3,0,0,2,0],[0,4,5,4,6,1,4],[1,2,0,7,7,0,4],[0,8,3,7,5,6,1],
# 			[2,3,6,5,5,3,0],[6,0,5,6,4,5,0],[3,2,0,6,5,0,0],[1,0,3,7,2,4,1],[6,2,0,7,7,4,5],[8,6,0,0,2,8,7],[8,4,2,7,3,0,5]].solveable?

# array = [[5, 5, 2, 4, 4, 0, 0, 5, 1],[7, 6, 8, 0, 9, 9, 4, 7, 5],[5, 3, 2, 9, 1, 0, 7, 1, 9],[5, 1, 5, 0, 0, 4, 8, 6, 5],
# [6, 2, 4, 2, 0, 4, 5, 6, 9],[7, 7, 7, 0, 5, 3, 3, 7, 3],[3, 1, 6, 8, 3, 5, 9, 9, 1],[0, 5, 8, 4, 7, 5, 0, 2, 7],
# [0, 9, 8, 8, 0, 2, 2, 1, 8],[7, 4, 4, 7, 8, 8, 2, 5, 9],[6, 5, 9, 1, 8, 1, 1, 7, 9],[4, 3, 4, 6, 6, 7, 9, 9, 3],
# [5, 6, 6, 5, 4, 3, 0, 6, 5],[6, 7, 1, 9, 4, 0, 8, 2, 7],[1, 2, 2, 7, 8, 7, 5, 2, 3],[9, 6, 6, 9, 4, 3, 0, 5, 2],
# [7, 9, 4, 8, 1, 8, 9, 5, 7],[2, 4, 7, 2, 9, 2, 8, 7, 3],[8, 3, 3, 1, 9, 1, 0, 5, 2]]
# array.print_readable
# make_matrix_solveable(array)
# array.print_readable
# print array.solveable?

	# 1000.times do

	# 		cols = rand(7)+1
	# 		rows = (2*cols)+rand(4)
	# 		matrix = Array.new(rows) {Array.new(cols) {rand(10)}}
	# 		matrix.print_readable
	# 		print "#{make_matrix_solveable(matrix).solveable?}\n"

	# end

# [[5,8],[13,7],[4,9],[8,8],[10,10],[9,13],[10,42]].each do |v|
# 	array = Array.new(v[0]){Array.new(v[1]){rand(9)+1}}
# 	# print "%f\n" % Benchmark.realtime { make_matrix_solveable(array) }.to_f
# 	print "original array: #{v[0]}x#{v[1]}\n"
# 	array.print_readable
# 	print "solveable array:"
# 	solution = make_matrix_solveable(array)
# 	solution.print_readable
# 	print "Time to get solution: %f seconds\n" % Benchmark.realtime { make_matrix_solveable(array) }.to_f
# 	print "degree of difference: #{(array.to_m - solution.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+) * 100 / array.flatten(1).inject(:+).to_f}\n"

# 	assign_needy_zeros(solution)
# 	print "assigned lonely zeros:"
# 	solution.print_readable

# 	print "solution?: #{solution.solution?}\n"

# 	print "problem reduced:"
# 	solution.reduce_problem.print_readable

# 	print "--------------------------------------------------------\n"
# end

