# Modified hungarian algorithm to optimize matches
# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/

# see http://www.tutorialspoint.com/ruby/ruby_modules.html under "Ruby require statement" to see how this works
$LOAD_PATH << '.'
require 'matrix'
require 'matrix_class_additions'

class Hungarian

	# ARRAY FRIENDLY
	# passed an Array object; consider also passing in min_row_assignment, min_col_assignment
	def intitialize(matrix_array)
		# ensure that matrix_array is in matrix format
		# will throw an ExceptionForMatrix::ErrDimensionMismatch error if it is not
		matrix_array.to_m

		# this is the matrix that will be modified as the algorithm runs
		@working_matrix = matrix_array
		# keep a copy of the original, unchanged matrix in array form
		@original_matrix = matrix_array
		# quantifies the difference between the working matrix and its original form
		@degree_of_diff = 0
		# solution array: will contain coordinates of each assignment in the optimal match
		@solution = []
		attr_accessor :working_matrix, :original_form, :degree_of_diff, :solution

	end

	# UNTESTED
	# call on Hungarian object; refreshes its degree_of_diff attribute; returns the updated Hungarian object
	def calc_degree_of_diff
		# first get difference between corresponding members of the array, sum the differences, then divide by the sum of all the original members
		self.degree_of_diff = (original_matrix.to_m - working_matrix.to_m).collect{|e| 
			e.abs}.to_a.flatten(1).inject(:+) * 100 / original_matrix.flatten(1).inject(:+).to_f
		return self
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# call on Hungarian object; returns solution array containing coordinates of each assignment in the optimal match
	def solve
		# first step in algorithm
			# check to see if the working matrix currently supports a complete assignment
			# if it doesn't, fix whatever is preventing it from supporting an assignment, then check again for new issues
			# once there are no issues, calculate how much you've had to change the matrix to generate the solution
		self.working_matrix = make_matrix_solveable(self.working_matrix)
		self.calc_degree_of_diff

		# second step in algorithm
			# the working matrix is solveable; so make the assignments!

		TO SPEED UP ALGORITHM:
		To speed up the algorithm you had formerly inverted matrices with more rows than columns just for ONE of the fix
		methods associated with "solveable?" But this caused you problems with "make_matrix_solveable", which was returning
		unsolveable arrays. But there is no reason why the general strategy of inverting matrices shouldnt work. Evidence: its
		not as though when you normally run "make_matrix_solveable" on matrices with more columns than rows you get problems. 
		Rather, algorithm basically always hands you a solveable array. But such matrices surely are equivalent to matrices 
		with more rows than columns that have been inverted. So, why arent you getting problems with the non-inverted matrices?
		Suggestion: simply because the entirety of "make_matrix_solveable" is being run on them, not just a single part of it.
		Thats what you need to do: run ALL of "make_matrix_solveable" on your inverted arrays.


			PROBLEM
			How will I represent assignments?
				Answer: make a duplicate of the working array, called MASK, then designate assignments with "!"
				So, when I assign a zero, I will replace it with "!" in the mask array

				Here is how you get the coordinates of each assignment represented by a "!"
				mask.map.with_index {|row,row_index| row.map.with_index {|v,col_index| v=="!" ? [row_index,col_index] : v}}.flatten(1).find_all {|x| x.class==Array}

				Better, use this:

				# call on Array object, returns an array of coordinates [row_id,col_id]: one for each value in the object that equals the
				# value passed in as an argument 
				def find_with_value(value)
					return self.each.with_index.with_object([]) {|(row, row_id), obj| 
						row.each.with_index {|val, col_id| 
							obj<<[row_id, col_id] if val == value
						}
					}
				end


			Step 1: assign to needy zeros, remove unassignable zeros, assign to extended needy zeros
			Step 2: check to see if youve got a solution
			Step 3: create a new array from the old one; get rid of all rows/columns which have reached
					the max assignments, then get rid of all rows/columns with no zeros in them, then the
					resulting array is all that needs to be solved to solve the larger array

			Step 4: 
				collect array of coordinates of each remaining zero
				create a new class Zero object with attribute ".coordinate" the coordinates
				put all the Zero objects created in this way in an array
				now add the other relevant Zero attributes that you used in your algorithm before









	end




end


#--------------------- HELPER METHODS----IN-ALPHABETICAL-ORDER----------------------------------------------------

# TESTED
# passed mask Array object; assigns to needy zeros and extended needy zeros in the mask, then returns the mask
def assign_needy_zeros(mask)
	# make sure that the method is passed an array object
	raise "Wrong kind of argument, requires an array" if mask.class != Array
	# make sure the argument has Matrix-like dimensions
	Matrix.columns(mask.transpose)

	while !mask.needy_zeros.empty?
	# ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	# Assign to all needy zeros; a zero is needy iff it occurs in a needy row/column; a row/column is "needy" iff every zero in it 
	# must be assigned in order for it to reach its minimum allowable value. The class of needy zeros includes the class of lonely
	# zeros and thus also the class of extra-lonely zeros. And the make_matrix_solveable method has already ensured that there are 
	# at least enough zeros in columns and rows to reach the minimum assignments; moreover the solveable method gaurantees that there
	# aren't too many needy zeros in either rows or columns; consider an example: suppose there is an array that is 3 rows x 9 col,
	# given the array's dimensions, the min_row_assignment is 3; hence, for a zero to be needy for its row there can be no more than 
	# 3 zeros in that row; thus suppose that two rows are needy and all of their zeros occupy the same columns; this would result
	# in an unsolveable array; but, if all the zeros occupy the same columns then at most they occupy just 3 columns; so what about
	# the other 6 columns? there are three options: (1) none have zeros in the thrid row, (2) some but not all have zeros in the third
	# row, and (3) all have zeros in the third row; but if (1) and (2) then there are columns that lack zeros; and if (3) then there
	# are too many lonely zeros in the third row; hence, the solveable? method will catch the issue; the point is: needy zeros only 
	# cause a problem problem if they occur in multiple rows/columns, and they only overlap in multiple rows/columns if there are 
	# other problems elsewhere in the array (e.g. columns/rows without zeros, or too many lonely zeros) that solveable? catches
		mask.needy_zeros.each {|coord| mask[coord[0]][coord[1]] = "!" }

		# Making assignments to needy zeros will often prevent you from making assignments to other zeros. When there are enough needy zeros
		# in a row/column to reach the maximum number of assignments for that row/column, then other zeros which occur in that row/column cannot
		# be assigned. So, since these zeros can't be assigned, replace them with "X"s in the mask.
		mask.x_unassignables

		# Getting rid of the zeros just described might reveal new "extended" needy zeros, AKA needy zeros "by extension"--i.e. zeros which end up being needy
		# when the previous two classes of zeros are removed. Such zeros will have to be assigned, so repeat this process.
	end
	return mask
end


# ARRAY FRIENDLY + MANUALLY TESTED
# passed an array object (Hungarian.working_matrix); minimally changes the array to return an array which supports complete assignment
def make_matrix_solveable(working_matrix)
	# first normalize the rows and columns, in the appropriate order
	working_matrix = working_matrix.zero_rows_and_columns

	# the remaining algorithm runs up to 2 orders of magnitute faster when there are fewer rows than columns
	# so, just transpose the array to create an array with more columns than rows
	# Unfortunately, this sometimes (1/50 times) results in arrays that are not solveable!
	# dup = working_matrix.dup
	# working_matrix = working_matrix.transpose if dup.row_count > dup.column_count

	# this will prevent the algorithm from having to run the .solveable? method uncessarily between tests
	solveable = working_matrix.solveable?

	while solveable != "true"
		# you want to include the following two methods in case the methods below them change the Matrix in such a way
		# as to remove a lonely zero from a row/column

		while solveable == "no, not enough zeros in rows"
			working_matrix = working_matrix.zero_each_row
			solveable = working_matrix.solveable?
		end

		while solveable == "no, not enough zeros in columns"
			working_matrix = working_matrix.zero_each_column
			solveable = working_matrix.solveable?
		end

		while solveable == "no, too many lonely zeros in columns"
			# to fix: isolate the lonely zeros causing the problem, take each row they occur in, 
			# find the lowest member in that row besides the zero, add the value of that member to each zero, 
			# subtract it from every other member (including itworking_matrix)
			working_matrix.fix_too_many_lonely_zeros_in_columns
			# Running the fix method might result in a matrix with the same problem, so run solveable? method again
			# Repeat until the matrix no longer has too many lonely zeros in columns
			# It does not seem possible to get a problematic matrix that will cause this loop to continue infinitely
			solveable = working_matrix.solveable?
		end

		while solveable == "no, too many lonely zeros in rows"
			# to fix: isolate the lonely zeros causing the problem, take each column they occur in
			# find the lowest member in that column besides the zero, add the value of that lowest member to each zero,
			# subtract the value of that lowest member from every other member (including itworking_matrix)
			working_matrix.fix_too_many_lonely_zeros_in_rows
			# Running the fix method might result in a matrix with the same problem, so run solveable? method again
			# Repeat until the matrix no longer has too many lonely zeros in rows
			# It does not seem possible to get a problematic matrix that will cause this loop to continue infinitely
			solveable = working_matrix.solveable?
		end


		while solveable == "no, assignments can't be made in rows"
			# to fix: create duplicate mask array, then assign needy zeros in the mask; get the row ids of any rows that lack zeros 
			# in the assigned mask; if a row lacks zeros in the mask, create a new zero in that row in the working matrix by subtracting
			# the min-sans-zero

			# create duplicate mask array, then assign needy zeros in the mask
			mask = working_matrix.map {|row| row.dup}
			assign_needy_zeros(mask)

			# get the row ids of any rows that lack zeros in the assigned mask
			rows_wo_assignable = mask.each.with_index.with_object([]) {|(row, row_id), obj| 
				obj << row_id if !row.include?(0)}

			# if a row lacks zeros in the mask, create a new zero in that row by subtracting the min-sans-zero
			while !rows_wo_assignable.empty?
				# fix the first problematic row
				# remember, the row WILL contain zeros (zero_each_row ensures it above), those zeros are just unassignable
				working_matrix.map!.with_index {|row, row_id| 
					row_id == rows_wo_assignable.first ? row.map {|v| !v.zero? ? v - (row - [0]).min : v} : row
				}

				# run assign_needy_zeros again to see if the problem is resolved
				mask = working_matrix.map {|row| row.dup}
				assign_needy_zeros(mask)

				# now check to see if this has fixed the problem
				rows_wo_assignable = mask.each.with_index.with_object([]) {|(row, row_id), obj| 
					obj << row_id if !row.include?(0)}
			end

			solveable = working_matrix.solveable?
		end


		while solveable == "no, assignments can't be made in columns"
			# to fix: create duplicate mask array, then assign needy zeros in the mask; get the column ids of any columns that lack zeros 
			# in the assigned mask; if a column lacks zeros in the mask, create a new zero in that column in the working matrix
			# by subtracting the min-sans-zero

			# create duplicate mask array, then assign needy zeros in the mask
			mask = self.map {|row| row.dup}
			assign_needy_zeros(mask)
			mask_cols = mask.transpose

			# get the column and row ids of any columns/rows that lack zeros in the assigned mask
			cols_wo_assignable = mask_cols.each.with_index.with_object([]) {|(col, col_id), obj| 
				obj << col_id if !col.include?(0)}

			# if a column lacks zeros in the mask, create a new zero in that column by subtracting the min-sans-zero
			while !cols_wo_assignable.empty?
				# fix the first problematic col
				# remember, the col WILL contain zeros (zero_each_col ensures it above), those zeros are just unassignable
				working_matrix.replace(working_matrix.transpose.map.with_index {|col, col_id| 
					col_id == cols_wo_assignable.first ? col.map {|v| !v.zero? ? v - (col - [0]).min : v} : col
				}.transpose)

				# run assign_needy_zeros again to see if the problem is resolved
				mask = working_matrix.map {|row| row.dup}
				assign_needy_zeros(mask)
				mask_cols = mask.transpose

				# now check to see if this has fixed the problem
				cols_wo_assignable = mask_cols.each.with_index.with_object([]) {|(col, col_id), obj| 
					obj << col_id if !col.include?(0)}
			end

			solveable = working_matrix.solveable?
		end
			

		while solveable == "no, too many cols with max assignments"
			# to fix: create mask array, then assign to needy zeros in mask; then find the number of
			# columns in the mask that have reached the max_col_assignment value; then find the assigned zeros in those
			# columns; then rank those zeros by increasing row_min_sans_zero_value; then, for the zero with the lowest
			# min_sans_zero value in its row, subtract the min_sans_zero value from each non-zero in the row of the 
			# original array, and add it to each zero
			working_matrix.fix_too_many_max_assignments_in_cols
			solveable = working_matrix.solveable?
		end

		while solveable == "no, too many rows with max assignments"
			# to fix: create mask array, then assign to needy zeros in mask; then find the number of
			# rows in the mask that have reached the max_row_assignment value; then find the assigned zeros in those
			# rows; then rank those zeros by increasing col_min_sans_zero_value; then, for the zero with the lowest
			# min_sans_zero value in its column, subtract the min_sans_zero value from each non-zero in that column of the 
			# original array, and add it to each zero
			working_matrix.fix_too_many_max_assignments_in_rows
			solveable = working_matrix.solveable?
		end

		
		while solveable == "no, min permitted row assignments > max column assignments possible"
			# to fix: if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix
			# find the lowest value-sans-zero in the submatrix, then subtract that value from every member-sans-zero of the row in which it occurs
			# do this only as many times as you need to make min permitted row assignments <= max column assignments possible
			
			working_matrix.make_more_column_assignments_possible
			solveable = working_matrix.solveable?
		end
	end

	# tanspose the matrix back into its original form if it was flipped
	# working_matrix = working_matrix.transpose if dup.row_count > dup.column_count

	return working_matrix
end

class Array
	# ARRAY FRIENDLY, BUT COULD REFACTOR TO SIMPLIFY + TESTED
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

	# ARRAY FRIENDLY + TESTED, BUT COULD BE REFACTORED
	# called on Array object, takes row index and value as inputs
	# outputs Array in which the value provided has been added to each zero and subtracted otherwise
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
		return self.transpose.length
	end

	# call on Array object; returns "fail" if there are fewer column assignments possible than would be permitted in a complete
	# assignment; returns "pass" otherwise; checks to see if the minimum allowable row assignments is greater than the maximum number of column assignments
	# if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix, the parent matrix is unsolveable
	# run this test last, since calculating every_combination_of_its_members takes a long time for big arrays
	def combinatorial_test
		# how this works:
			# 	populate array of every combination of the matrix_array rows
			# 	for each member of the combination array:
			# 		find min row assignments permitted
			# 		find max column assignments possible
			# 		check if min_row_assmts_permitted > max_col_assmts_poss
			# 			return false
		# this seems to catch all of the cases where min allowable column assignments > max num of possible row assignments
		# so I didn't write a corresponding test for that

		test_cases = self.every_combination_of_its_members
		test_cases.each do |submatrix|
			min_row_assignments_permitted = self.min_row_assignment * submatrix.length
			if min_row_assignments_permitted > submatrix.max_column_assmts_possible(self.max_col_assignment)
				return "fail"
			end
		end
		return "pass"
	end

	# called on array object; returns array of coordinates [p,q] such that each self[p][q] is an extra-lonely zero
	# an "extra lonely" zero is one which occurs as the only zero in both its row AND column
	def extra_lonely_zeros
		columns = self.transpose
		return self.lonely_zeros.select {|coord| self[coord[0]].count(0)==1 && columns[coord[1]].count(0)==1}
	end

	# UNTESTED
	# called on mask array object AFTER calling assign_needy_zeros on it; reduces problem, assigns to mask based on reduction, 
	# returns finished mask assignment object; changes mask array
	def finish_assignment
		# repeat until there are no more zeros in the mask array
		while self.flatten(1).include?(0) == true
			self.make_assignment(self.next_assignment)

			# making the assignment might have revealed new needy zeros, assign to them
			assign_needy_zeros(self)
		end
	end


	# UNTESTED
	# call on mask Array object; run reduce_problem on the object; use result to get
	# row/col with most assignments needed to reach min, in event of tie choice is random;
	# outputs array [p,q] where p is the row/col ID and q is the number of needed assignments; 
	# I don't care if there are multiple arrays that are identical to [p,q]
	def next_assignment
		# reduce problem places arrays [p,q] where p is a row/col index, q is number of assignments needed to reach max
		# we sort these arrays by descending q value
		return self.reduce_problem.map {|row| 
			row.select {|value| value.class == Array}
		}.flatten(1).sort { |x,y| y[1] <=> x[1] }.first
	end

	# UNTESTED
	# called on mask Array object; gets array [p,q] from next_assignment, where p is a row/col ID and q is the number of needed assignments; finds that value first in row 0 of
	# the reduction array, and if not there then in col 0 of the reduction array; once found, it assigns to the zero with the fewest
	# other zeros in its respective row/col, in event of tie it assigns to zero closest to the top/left; then it makes the corresponding
	# assignment to the mask; then it reruns assign to needy zeros (abstract sub-methods from the assign_needy_zeros method)
	# returns array it was called on
	def make_next_assignment
		# ///////////////////////////////////////////////////////////////////
		# PROBLEM
		# once the target row/col has been selected, it should rank zeros by: (i) number of assignments needed in opposite dimension,
		# (ii) number of zeros, (iii) nearness to top/left.
		# Otherwise what can happen is you can end up filling columns/rows to the max, thereby x-ing out crucial zeros too fast
		# ///////////////////////////////////////////////////////////////////////////


		# exit the method if reduce_problem can find no issues
		reduction = self.reduce_problem
		return self if reduction == [["X"]]

		reduction_cols = reduction.transpose
		next_assignment = self.next_assignment
		check = self.map {|row| row.dup}

		# first try to find the assignment in rows
		reduction_cols.first.each.with_index do |value, row_id|
			if value == next_assignment
				# find each zero in the target row; output array of arrays [p,q,r] where p is the column ID of a zero in the
				# target row, q is the number of other zeros in its column, and r is the number of needed assignments in that col; 
				# the [p,q,r] arrays are then sorted by ascending q value, then descending r value, then ascending p value
				zeros_in_row = reduction[row_id].each.with_index.with_object([]) {|(val,col_id), obj| 
					obj << [col_id, reduction_cols[col_id].count(0) - 1, reduction[0][col_id][1]] if val == 0
				}.sort_by {|x| x[1]}

				zeros_in_row = zeros_in_row.select {|x| x[1] == zeros_in_row.first[1]}.sort {|x,y| y[2]<=>x[2]}

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
					
					# find each zero in the target column; output array of arrays [p,q,r] where p is the row ID of a zero in the
					# target column, q is the number of other zeros in its row, and r is the number of needed assignments in that row; 
					# the [p,q,r] arrays are then sorted by ascending q value, then descending r value, then ascending p value
					zeros_in_column = reduction_cols[col_id].each.with_index.with_object([]) {|(val,row_id), obj| 
						obj << [row_id, reduction[row_id].count(0) - 1, reduction[row_id][0][1]] if val == 0
					}.sort_by {|x| x[1]}
					
					zeros_in_column = zeros_in_column.select {|x| x[1] == zeros_in_column.first[1]}.sort {|x,y| y[2]<=>x[2]}

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

	# ARRAY FRIENDLY, BUT COULD BE REFACTORED TO SIMPLIFY + TESTED
	# called on Array object; outputs array of arrays [n,m,o] where n is the index of a column with too many lonely zeros
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

	# ARRAY FRIENDLY - COULD BE REFACTORED TO SIMPLIFY + TESTED
	# called on Array object; outputs array of arrays [n,m,o] where n is the index of a row with too many lonely zeros
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

	# ARRAY FRIENDLY
	# UNTESTED
	# Call on Matrix object; returns array of submatrices (in array format) for which the number of minimum row assignments permitted
	# is greater than then number of possible column assignments
	def get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible
		# get every possible submatrix
		test_cases = self.every_combination_of_its_members
		# find the problematic submatrices
		problematic_submatrices = []
		min_row_assign = self.min_row_assignment
		max_col = self.max_col_assignment
		test_cases.collect {|x| min_row_assign * x.length > x.max_column_assmts_possible(max_col) ? problematic_submatrices << x : x}
		# return result
		return problematic_submatrices
	end

	# ARRAY FRIENDLY
	# returns an array containing every combination of members of the array it was called on
	def every_combination_of_its_members
		return self.each_with_index.map {|x,i| self.combination(i+1).to_a}.flatten(1).drop(self.length).uniq
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# called on Array; finds all rows matching the row_to_match (data type: array) given as first parameter;
	# subtracts input value from each member of each row matching the row_array, skips over zeros
	# returns corrected Array object
	def find_matching_row_then_subtract_value(row_to_match, value_to_subtract)
		return self.map! {|row| row==row_to_match ? row.map {|value| value!=0 ? value - value_to_subtract : value}  : row}
	end

	# ARRAY FRIENDLY + TESTED
	# called on Array object; finds columns that have too many lonely zeros, then the rows in those columns that contain the lonely zeros
	# changes the values in the fewest rows possible to remove the problem
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

	# ARRAY FRIENDLY + TESTED
	# called on Array object; finds rows that have too many lonely zeros, then the columnss in those rows that contain the lonely zeros
	# changes the values in the fewest columns possible to remove the problem
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

	# UNTESTED
	# call on Array object; creates mask array, then assigns to needy zeros in mask; then finds the number of
	# rows in the mask that have reached the max_row_assignment value; then it finds the assigned zeros in those
	# rows; then it ranks those zeros by increasing col_min_sans_zero_value; then, for the zero with the lowest
	# min_sans_zero value in its column, it subtracts the min_sans_zero value from each non-zero in that column of the 
	# original array, and adds it to each zero; returns the changed array object it was called on
	def fix_too_many_max_assignments_in_rows
		# step 0: create mask and make assignments to needy zeros
		mask = self.map {|row| row.dup}
		assign_needy_zeros(mask)
		mask_cols = mask.transpose

		# step 1: find rows with max assignments in mask
		# step 2: find assigned zeros in those rows
		# step 3: rank those zeros by: increasing col_min_sans_zero value
		problem_zeros = mask.each.with_index.with_object([]) {|(row, row_id), obj| 
			obj << row_id if row.count("!") >= self.max_row_assignment
		}.each.with_object([]) {|row_id,obj| mask[row_id].each.with_index {|value, col_id|
				obj << [row_id, col_id, (self.transpose[col_id]-[0]).min] if value == "!"
			}
		}.sort_by {|x| [x[2],x[0],x[1]]}


		# step 4: fix first zero identified in problem_zeros; subtract min sans zero from from each member of its column,
		# add to zeros; replace result with the self array
		sub = problem_zeros.first[2]
		self.replace(self.transpose.map.with_index {|col, col_id| 
			col_id == problem_zeros.first[1] ? col.map {|value| value - sub
				}.map {|value| value < 0 ? value + 2*sub : value} : col }.transpose)
	end

	# UNTESTED
	# call on Array object; creates mask array, then assigns to needy zeros in mask; then finds the number of
	# columns in the mask that have reached the max_col_assignment value; then it finds the assigned zeros in those
	# columns; then it ranks those zeros by increasing row_min_sans_zero_value; then, for the zero with the lowest
	# min_sans_zero value in its row, it subtracts the min_sans_zero value from each non-zero in the row of the 
	# original array, and adds it to each zero; returns the changed array object it was called on
	def fix_too_many_max_assignments_in_cols
		# step 0: create mask to make assignments to needy zeros
		mask = self.map {|row| row.dup}
		assign_needy_zeros(mask)
		mask_cols = mask.transpose

		# step 1: find columns with max assignments in mask
		# step 2: find assigned zeros in those columns
		# step 3: rank those zeros by: increasing row_min_sans_zero value
		problem_zeros = mask_cols.each.with_index.with_object([]) {|(col, col_id), obj| 
			obj << col_id if col.count("!") >= self.max_col_assignment
		}
		.each.with_object([]) {|col_id,obj| mask_cols[col_id].each.with_index {|value, row_id|
				obj << [row_id, col_id, (self[row_id]-[0]).min] if value == "!"
			}
		}.sort_by {|x| [x[2],x[0],x[1]]}


		# step 4: fix first zero identified in problem_zeros; subtract min sans zero from from each member of its row,
		# add to zeros; replace result with the self array
		sub = problem_zeros.first[2]
		self.map!.with_index {|row, row_id| 
			row_id == problem_zeros.first[0] ? row.map {|value| value - sub
				}.map {|value| value < 0 ? value + 2*sub : value} : row }
	end

	# ARRAY FRIENDLY + TESTED
	# called on Array object; returns an array of coordinates [n,m] of every lonely zero; a "lonely" zero is one which occurs as the 
	# sole zero in EITHER its row or its column
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
		self.map.with_index {|row,i| 
			zeros<<[i, row.find_all.with_index {|value,col_index| value==0 && self.transpose[col_index].count(0)==1}.count]
		}
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
	# called on Array object; returns Array corrected such that min permitted row assignments <= max column assignments possible
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

	# CONSTRAINTS--------------------------------------------------------------------------------------------------
	# leave these as Array methods, don't set them to the hungarian object; you need to be able to access these values for the
	# array and each of its submatrices, and also when you transpose arrays and then perform operations on them, e.g. in assign_needy
	
	# ASUMPTIONS: (1) an optimal match is one in which every object on the x axis will get mapped to at least one object on the y axis, 
	# and vice versa; (2) an optimal match is one in which the mapping is as even as possible, i.e. every row has the same number of 
	# assignments (+/- 1) as any other row, and similarly for columns.
	
	# Perhaps sometimes the most optimal match will be one in which an individual just doesn't get matched at all; if so, 
	# then my algorithm won't catch it. I have to start somewhere.

	# Formerly, I had just set min_row and min_col_assignment to 1 automatically. But it's not clear why I should have. If what
	# these values are supposed to be are the minimum/maximum number of assignments in an optimal match for the relevant array, 
	# then given my assumptions the minimums will seldom if ever be 1. In a square array, the min row/col assignments should be 
	# equal to the max row/col assignments

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
	# -----------------------------------------------------------------------------------------------------------------

	# TESTED
	# call on mask Array object; outputs coordinates of any zeros that are in "needy" rows/columns, where a row/column is needy iff every 
	# assignable zero in it must be assigned in order for it to reach its minimum allowable value
	def needy_zeros
		# first find zeros in needy rows
		row_coordinates = self.each.with_index.with_object([]) {|(row,row_id), obj| 
			row.each_index {|col_id| 
				obj << [row_id, col_id] if row[col_id]==0 && (row.count("!")+row.count(0) <= self.min_row_assignment)

			}
		}

		# now do the same for needy columns
		# run .uniq in case the coordinates for a zero were put in twice: once here and once above
		# sort then sorts the coordinates by increasing x value, then by increasing y value
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
	# call on mask Array object, does NOT change the mask, returns minimal array that needs to be assigned in order to finish
	# assigning to the mask object the method was called on
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

	# ARRAY FRIENDLY + TESTED
	# called on Array object; returns failure code if the matrix-array has no solution in its current state, 
	# returns true if the matrix-array passes the tests
	def solveable?
		# checks to see if any columns or rows lack enough zeros to make the requisite minimum assignments
		if !self.select {|row| row.count(0) < self.min_row_assignment}.empty?
			return "no, not enough zeros in rows"
		elsif !self.transpose.select {|col| col.count(0) < self.min_col_assignment}.empty?
			return "no, not enough zeros in columns"
		end

		# REALLY THIS SHOULD BE TOO MANY NEEDY ZEROS IN COLUMNS; THAT'S THE MORE GENERAL PROBLEM, LONELY ZEROS AND EVEN
		# EXTRA-LONELY ZEROS ARE JUST SPECIFIC INSTANCES OF THIS WIDER ISSUE
		# checks to see if there are too many lonely zeros in any column
		self.lonely_zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				return ("no, too many lonely zeros in columns")
			end
		end

		# checks to see if there are too many lonely zeros in any row
		self.lonely_zeros_per_row.each do |array|
			if array[1] > self.max_row_assignment
				return "no, too many lonely zeros in rows"
			end
		end

		# checks to make sure assigning needy zeros doesn't prevent columns/rows from having any assignments
		# create a mask, assign to needy zeros in mask
		mask = self.map {|row| row.dup}
		assign_needy_zeros(mask)
		return "no, assignments can't be made in rows" if !mask.select {|row| row.include?(0)}.empty?
		return "no, assignments can't be made in columns" if !mask.transpose.select {|col| col.include?(0)}.empty?

		# ///////////////////////////////////////////////////
		# PROBLEM
		# You aren't checking to make sure that needy zeros and/or needy zeros by extension don't
		# result in there being too many required assignments in a row/col; specifically, that the needy zeros and those
		# by extension don't force there to be too many rows/col with the max
		# ////////////////////////////////////////////////////////////////
		# UNTESTED
		num_columns = self[0].count
		num_rows = self.count
		if num_columns != num_rows
			# create a mask, assign to needy zeros in mask
			mask = self.map {|row| row.dup}
			assign_needy_zeros(mask)

			# now, find out how many columns and rows should be at the max in a complete assignment
			if num_columns > num_rows
				max_cols_at_max = num_columns
				# see corresponding note below for max_cols_at_max to see why this is done
				max_rows_at_max = num_columns % num_rows
				max_rows_at_max = num_rows if max_rows_at_max == 0
			elsif num_rows > num_columns
				max_rows_at_max = num_rows
				# suppose there are 5 rows and 1 column, then the 1 column will reach the max_col_assignment;
				# hence, there should be 1 column at the max; but num_rows % num_cols (5%1) == 0; you need to
				# build in a condition here so that when the num_cols evenly divides the num_rows the max_cols_at_max
				# is correct
				max_cols_at_max = num_rows % num_columns
				max_cols_at_max = num_columns if max_cols_at_max == 0
			end

			# now see if there are too many rows at the max assignment
			if mask.select {|row| row.count("!") >= mask.max_row_assignment}.count > max_rows_at_max
				return "no, too many rows with max assignments"
			elsif mask.transpose.select {|col| col.count("!") >= self.max_col_assignment}.count > max_cols_at_max
				return "no, too many cols with max assignments"
			end
		end

		# checks to see if the minimum allowable row assignments is greater than the maximum number of column assignments
		# if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix, the parent matrix is unsolveable
		# run this test last, since calculating every_combination_of_its_members takes a long time for big arrays
		return "no, min permitted row assignments > max column assignments possible" if self.combinatorial_test == "fail"

		# if the program hasn't stopped by now
		return "true"
	end

	# ARRAY FRIENDLY
	# UNTESTED
	# called on Array object, passed array that is a submatrix (Array format) of the Array-matrix
	# makes changes to the Array it's called on, subtracting the smallest min-sans-zero value that resides in a column
	# (that does not contain a zero in the submatrix) from every member in its row with the exception of zeros; changes 
	# the corresponding values in the Array; repeats the process until min_row_permitted <= max_col_assignments_possible
	# returns the corrected Array object it was called on
	def subtract_min_sans_zero_from_rows_to_add_new_column_assignments(submatrix)
		# ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		# PROBLEM: find the value to subtract based on the contents of the columns, but then subtract the value in the row;
		# this has a danger: what if the min in the col is larger than the min in the row? in that case, you will
		# end up with negative values; so why subtract in the row rather than the column?--because the issue at hand is that
		# there are not enough columns with zeros in the submatrix, so making subtractions in the column would
		# at best produce new zeros in a single column, and that's not what we want; alternatively, creating a mess of zeros
		# in a single row is not what is wanted either, since at most only a couple of them can be assigned
		# SOLUTION: if the first check to see which dimension is bigger, rows or columns, then change values in the smaller
		# dimension, making sure to first reduce all values lower than the value to subtract to zero
		# ////////////////////////////////////////////////////////////////////////////////////////////////////////////////


		min_row_assignments_permitted = self.min_row_assignment * submatrix.length
		while min_row_assignments_permitted > submatrix.max_column_assmts_possible(self.max_col_assignment)

			# outputs ordered array of arrays [p,q,r,s,t] such that p is a row_id in the submatrix, s is the row in the submatrix, 
			# q is a col_id in the submatrix, t is the column in the submatrix, and
			# r is the value at those coordinates such that r is the min value in its column in the submatrix and there are no zeros
			# in r's column in the submatrix; the arrays are ordered by increasing r value
			min_vals = submatrix.transpose.each.with_index.with_object([]) {|(col, col_id), obj| 
				obj << [col.index(col.min), col_id, col.min, submatrix[col.index(col.min)]] if !col.include?(0)
			}.sort_by {|x| x[2]}

			# edit the Matrix accordingly
				# if there are more values in columns columns than rows, minimum mutilation has you subtract values in the row
				if submatrix.length > submatrix.first.length
					target_id = self.index(min_vals.first[3])
					val = min_vals.first[2]
					self.map!.with_index {|row, row_id|
						row_id == target_id ? row.map {|x| x <= val ? 0 : x
							}.map {|x| !x.zero? ? x - val : x} : row
					}
				# if there are as many or more rows than columns, min mutilation has you subtract values in the column
				else
					# this is more difficult, since you only want to change the values in the self array that correspond to
					# the values in the column in the submatrix array, and by definition that won't include every member of the
					# column

					# finds the corresponding self row_id of every row in the submatrix, ouputs them in an array
					row_ids = submatrix.each.with_object([]) {|sub_row, obj|
						self.each.with_index {|self_row, row_id| 
							obj << row_id if self_row == sub_row
						}
					}.sort.uniq

					# now find the col_id that values need to be subtracted from
					target_col = min_vals.first[1]
					val = min_vals.first[2]

					# now do the subtracting
					row_ids.each do |row_id|
						# create a duplicate, since you can't change self
						dup = self.dup
						if dup[row_id][target_col] <= val 
							dup[row_id][target_col] = 0
						else
							dup[row_id][target_col] = dup[row_id][target_col] - val
						end
						# now replace self with the changed duplicate
						self.replace(dup)
					end
				end

			# throw an error if the method has put a negative value in the self array
			raise 'Results in negative value in self' if !self.flatten(1).select {|val| val < 0}.empty?

			# edit the submatrix to check to see if the problem is fixed
				# if there are more values in columns columns than rows, minimum mutilation has you subtract values in the row
				if submatrix.length > submatrix.first.length
					target_id = min_vals.first[0]
					val = min_vals.first[2]
					submatrix[target_id].map! {|x| x <= val ? 0 : x}.map! {|x| x != 0 ? x - val : x}
				# if there are as many or more rows than columns, min mutilation has you subtract values in the column
				else
					# find the col_id that values need to be subtracted from
					target_col = min_vals.first[1]
					val = min_vals.first[2]

					submatrix = submatrix.transpose.map.with_index {|col, col_id|
						col_id == target_col ? col.map {|x| x <= val ? 0 : x}.map {|x| x != 0 ? x - val : x} : col
					}.transpose

				end	

			# throw an error if the method has put a negative value in the submatrix array
			raise 'Results in negative value in submatrix' if !submatrix.flatten(1).select {|val| val < 0}.empty?


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

	# ARRAY FRIENDLY + TESTED
	# called on Array object; subtracts the lowest value in each row from each member of that row, repeats process until each
	# row contains at least enough zeros to support a minimum_row_assignment; then it returns the corrected array
	def zero_each_row
		while !self.select {|row| row.count(0) < self.min_row_assignment}.empty?
			self.map! {|row| 
				row.count(0) < self.min_row_assignment ? row.map {|v| v > 0 ? (v - (row-[0]).min) : v} : row
			}
		end
		return self
	end

	# ARRAY FRIENDLY + TESTED
	# called on Array object; subtracts the lowest value in each column from each member of that column, repeats process until each
	# column contains at least enough zeros to support a minimum_column_assignment; then it returns the corrected array
	def zero_each_column
		return self.replace(self.transpose.zero_each_row.transpose)
	end

	# ARRAY FRIENDLY + TESTED
	# called on Array object, for each row specified in params, adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited Array object it was called on
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

	# ARRAY FRIENDLY, BUT COULD REFACTOR TO SIMPLIFY + TESTED
	# called on Array object; takes as input an array of arrays [n,m,o] where n is a row index, m is the number of lonely zeros in that row
	# and o is an ordered array of arrays [p,q] where p is the column index of a lonely zero in row n, and q is the min value in that column other than zero
	# see method "get_problematic_columns_per_problematic_row" for a convenient way to get a parameter like this
	# for each member of the array passed to this method as a parameter, the method adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited Array object it was called on
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
		# if there are more rows than columns, zeroing rows first will produce many zeros in columns, making it likely
		# that additional changes won't have to be made once the columns are zeroed; the same holds the other way around
		# in the case in which there are more columns than rows; thus it accords with the principle of minimal mutilation
		# to run these steps based on the number of rows vs the number of columns

		# when I tested these methods and compared the results after 10,000 tries, zeroing the smaller dimension first changed fewer
		# values in the array than zeroing the larger dimension 20% of the time; so it's not obvious that this should be
		# automatically decided in advance; thankfully, these methods run fast enough that it's not crazy to just try each of them
		# and then go with the one that changes the least in the given case; so, that's what I've done here

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


end
