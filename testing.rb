require 'matrix'
require 'pry'
require 'benchmark'

# passed mask Array object; assigns to lonely zeros and extended extra-lonely zeros in the mask, then returns the mask
def assign_lonely_zeros(mask)
	# make sure that the method is passed an array object
	raise "Wrong kind of argument, requires an array" if mask.class != Array
	# make sure the argument has Matrix-like dimensions
	Matrix.columns(mask.transpose)

	# Assign to all needy zeros; a zero is needy iff it occurs in a needy row/column; a row/column is "needy" iff every zero in it 
	# must be assigned in order for it to reach its minimum allowable value. The class of needy zeros includes the class of lonely
	# zeros and thus also the class of extra-lonely zeros. And the checking algorithm has already ensured that there are enough zeros
	# in columns and rows to reach the minimum assignments
	# 

	# you can get the coordinates with array.lonely_zeros, replace them with "!"s
	mask.lonely_zeros.each {|coord| mask[coord[0]][coord[1]] = "!" }

	# use this style of loop ( with a "break if...") because you want the first two commands to run at least once
	loop do
		# Making assignments to lonely zeros will often prevent you from making assignments to other zeros. When there are enough lonely zeros
		# in a row/column to reach the maximum number of assignments for that row/column, then other zeros which occur in that row/column cannot
		# be assigned. So, since these zeros can't be assigned, replace them with "X"s in the mask.(Remember, a zero is "lonely" iff it is the only zero in its
		# row OR column; so a zero that's lonely, say, because of its column might well have other zeros in its row.)

		# first check to see if there are zeros in ROWS with the max number of assignments; add Xs accordingly
		mask.map! {|row| row.count("!") == mask.max_row_assignment ?
			row.map {|value| value == 0 ? "X":value} : row
		}

		# now do the same thing for COLUMNS
		mask.replace(
			mask.transpose.map {|col| col.count("!") == mask.max_col_assignment ?
				col.map {|value| value == 0 ? "X":value} : col
			}.transpose
		)

		# Getting rid of the zeros just described might reveal new "extended" lonely zeros, or lonely zeros "by extension"--i.e. zeros which end up being lonely
		# when the previous two classes of zeros are removed. Such zeros will have to be assigned, so repeat this process.
		break if mask.extra_lonely_zeros.empty?

		# Actually, you don't want to assign to zeros that are merely lonely by extension, they should be "extra" lonely by extension--i.e. 
		# they should be the sole zero in their row AND column. Why? Consider [[0,0,0],[4,0,0],[5,5,5]]. Assigning lonely zeros gives: 
		# [[!,0,0],[4,0,0],[5,5,5]]. Next, eliminating unassignables we get: [[!,x,x],[4,0,0],[5,5,5]]. But now notice: both zeros in row 1 are 
		# lonely by extension, since both occur in a column in which they are the sole zero. But it's not the case that both zeros should be 
		# assigned! That would leave row 1 with too many assignments. So, which zero in row 1 should be selected? That's not obvious. 
		# Moreover, the conditions on which you would choose which to assign are the complex conditions that shape assignment generally, 
		# so there's no point to to code that into the algorithm here. It will be coded elsewhere, and thus will be taken care of then.
		# Just assign to zeros that are extra lonely by extension. There's no question that these need to be assigned. Here is the code to do it:
		# mask.extra_lonely_zeros.each {|coord| mask[coord[0]][coord[1]] = "!" }

		# CONCERN: extra lonely is not the only property that you want to assign to; you want to assign to any zero that is in a
		# row/col that needs it to be assigned in order to reach the minimum allowable assignment. Zeros that are extra lonely by extension
		# are just one species of the latter--that is, they are if the check/correct method has succeeded up to this point! 
		
		needy = mask.needy_zeros
		break if needy.empty?

		# assign to each zero that is in a needy column/row; where a row/column is "needy" iff every assignable zero in it must be assigned
		# in order for it to reach its minimum allowable value
		needy.each {|coord| mask[coord[0]][coord[1]] = "!" }

	end
	return mask
end

		# UNTESTED!! Belongs in Class ARRAY
		# call on mask Array object; outputs coordinates of any zeros that are in "needy" rows/columns, where a row/column is needy iff every 
		# assignable zero in it must be assigned in order for it to reach its minimum allowable value
		def needy_zeros
			# first find zeros in needy rows
			row_coordinates = mask.each.with_index.with_object([]) {|(row,row_id), obj| 
				row.each_index {|col_id| 
					obj << [row_id, col_id] if row[col_id]==0 && (row.count("!")+row.count(0) <= mask.min_row_assignment)

				}
			}

			# now do the same for needy columns
			# run .uniq in case the coordinates for a zero were put in twice: once here and once above
			return mask.transpose.each.with_index.with_object(row_coordinates) {|(column, column_id), obj|
				column.each_index {|row_id|
					obj << [row_id, column_id] if column[row_id]==0 && (column.count("!")+column.count(0) <= mask.min_col_assignment)
				}
			}.uniq
		end


# ARRAY FRIENDLY + TESTED
def make_matrix_solveable(working_matrix)
	working_matrix = working_matrix.zero_rows_and_columns
	dup = working_matrix.dup
	working_matrix = working_matrix.transpose if dup.row_count > dup.column_count

	while working_matrix.solveable? != "true"
		while working_matrix.solveable? == "no, there are rows without zeros"
			working_matrix = working_matrix.zero_each_row
		end

		while working_matrix.solveable? == "no, there are columns without zeros"
			working_matrix = working_matrix.zero_each_column
		end

		while working_matrix.solveable? == "no, too many lonely zeros in columns"
			working_matrix.fix_too_many_lonely_zeros_in_columns
		end

		while working_matrix.solveable? == "no, too many lonely zeros in rows"
			working_matrix.fix_too_many_lonely_zeros_in_rows
		end

		while working_matrix.solveable? == "no, min permitted row assignments > max column assignments possible"
			working_matrix.make_more_column_assignments_possible
		end
	end

	working_matrix = working_matrix.transpose if dup.row_count > dup.column_count
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

	def solveable?
		if self.collect {|row| row.include?(0)}.include?(false)
			return "no, there are rows without zeros"
		elsif self.transpose.collect {|col| col.include?(0)}.include?(false)
			return "no, there are columns without zeros"
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

	def print_readable
		print "\n"
		self.each do |row|
			print "#{row}\n"
		end
		print "\n"
	end

end



# [[5,5],[5,10],[5,15],[5,25],[5,40],[10,5],[10,10],[10,15],[10,25],[10,40],[15,5],[25,5],[40,5]]
# [[5,5],[7,7],[10,10],[12,12],[15,15],[16,16],[17,17],[18,18],[19,19],[20,20]]

# [[5,5],[5,10],[5,15],[5,25],[5,40],[10,5],[10,10],[10,15],[10,25],[10,40],[15,5],[25,5],[40,5],
# [40,10],[7,7],[10,10],[12,12],[15,15],[16,16],[17,17],[18,18],[19,19],[20,20]]

# [[40,10]].each do |v|
# 	array = Array.new(v[0]){Array.new(v[1]){rand(9)+1}}
# 	# print "%f\n" % Benchmark.realtime { make_matrix_solveable(array) }.to_f
# 	print "original array: #{v[0]}x#{v[1]}\n"
# 	array.print_readable
# 	print "solveable array:"
# 	solution = make_matrix_solveable(array)
# 	solution.print_readable
# 	print "Time to get solution: %f seconds\n" % Benchmark.realtime { make_matrix_solveable(array) }.to_f
# 	print "degree of difference: #{(array.to_m - solution.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+) * 100 / array.flatten(1).inject(:+).to_f}\n"

# 	assign_lonely_zeros(solution)
# 	print "assigned lonely zeros:\n"
# 	solution.print_readable

# # calculate degree of difference
	
# 	# print "--------------------------------------------------------\n"
# end