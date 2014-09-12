# to use: navigate to the directory of this file in the terminal, then type "rspec <file name here>"

$LOAD_PATH << '.'
require 'testing'

# //////////////////////////////////////////////////////////////////////////////////////////////////////
# THE OVERALL CHECKING ALGORITHM HAS TO PASS THIS TEST
# [1,1,1,1,1,1]
# [1,4,5,6,3,1]
# [1,9,3,8,5,1]
# [1,5,8,7,3,1]
# [1,3,9,5,7,1]
# [1,1,1,1,1,1]
# After rows and columns are zeroed, this becomes:
# [0,0,0,0,0,0]
# [0,3,4,5,2,0]
# [0,8,2,7,4,0]
# [0,4,7,6,2,0]
# [0,2,8,4,6,0]
# [0,0,0,0,0,0]
# Now, none of these zeros is lonely, so the first two steps in the algorithm should pass it.
# Moreover, the third step in the algorithm should pass it as well, since 
# min_row_assmts_permitted = 6 and max_col_assignments_possible=6! But this matrix is plainly unsolveable
# in its current state.
# ///////////////////////////////////////////////////////////////////////////////////////////////////////////


describe Array, "max_column_assmts_possible(max_col_assignment)" do
	it "returns 2 when called on [[0,4,0],[0,9,0],[0,2,0]] and passed 1" do
		array = [[0,4,0],[0,9,0],[0,2,0]]
		expect(array.max_column_assmts_possible(1)).to eq(2)
	end

	it "returns 4 when called on [[0,4,0],[0,9,0],[0,2,0]] and passed 2" do
		array = [[0,4,0],[0,9,0],[0,2,0]]
		expect(array.max_column_assmts_possible(2)).to eq(4)
	end

	it "returns 0 when called on [[5,4,5],[5,9,5],[5,2,5]] and passed anything" do
		array = [[5,4,5],[5,9,5],[5,2,5]]
		anything = rand * 10
		expect(array.max_column_assmts_possible(anything)).to eq(0)
	end
end


describe Array, "array_count_with_value(value)" do
	it "returns 0 when called on [1,2,3,4,5] and passed 6" do
		array = [1,2,3,4,5]
		expect(array.array_count_with_value(6)).to eq(0)
	end

	it "returns 0 when called on [] and passed anything" do
		array = []
		anything = rand * 10
		expect(array.array_count_with_value(anything)).to eq(0)
	end

	it "returns 9 when called on [1,1,1,1,1,1,1,1,1,2] and passed 1" do
		array = [1,1,1,1,1,1,1,1,1,2]
		expect(array.array_count_with_value(1)).to eq(9)
	end

end


describe Array, "every_combination_of_its_members" do
	it "returns [[1,2]] when called on [1,2]" do
		array = [1,2]
		expect(array.every_combination_of_its_members).to eq([[1,2]])
	end

	it "returns [[1,2],[1,3],[2,3],[1,2,3]] when called on [1,2,3]" do
		array = [1,2,3]
		expect(array.every_combination_of_its_members).to eq([[1,2],[1,3],[2,3],[1,2,3]])
	end

end

describe Array, "array_columns" do
	it "returns [[9,6,3],[8,6,2],[7,4,1]] when called on [[9,8,7],[6,5,4],[3,2,1]]" do
		array = [[9,8,7],[6,5,4],[3,2,1]]
		expect(array.array_columns).to eq([[9,6,3],[8,5,2],[7,4,1]])
	end

	it "returns [[1]] when called on [[1]]" do
		array = [[1]]
		expect(array.array_columns).to eq([[1]])
	end

end

describe Array, ".subtract_value_from_row_in_array" do
	# def subtract_value_from_row_in_array(row_id, value_to_subtract)
	# called on Array; subtracts the value given as second parameter from each member of the row specified, unless zero

	# raises error when passed a non-existent row_id that is too high
	it "returns RuntimeError when called on [[9,6,3],[8,6,2],[7,4,1]] and passed 4, 23" do
		array = [[9,6,3],[8,6,2],[7,4,1]]
		expect {array.subtract_value_from_row_in_array(4,23)}.to raise_error(RuntimeError, 'Row does not exist in array')
	end

	# raises error when passed a non-existent row_id that is too low
	it "returns RuntimeError when called on [[9,6,3],[8,6,2],[7,4,1]] and passed -4, 23" do
		array = [[9,6,3],[8,6,2],[7,4,1]]
		expect {array.subtract_value_from_row_in_array(-4,23)}.to raise_error(RuntimeError, 'Row does not exist in array')
	end

	# changes nothing when passed existing row ID and value_to_subtract of zero
	it "returns [[19,16,13],[8,6,2],[7,4,1]] when called on [[19,16,13],[8,6,2],[7,4,1]] and passed 1, 0" do
		array = [[19,16,13],[8,6,2],[7,4,1]]
		expect(array.subtract_value_from_row_in_array(1,0)).to eq([[19,16,13],[8,6,2],[7,4,1]])
	end

	# changes nothing when row only includes zeros
	it "returns [[19,16,13],[0,0,0],[7,4,1]] when called on [[19,16,13],[0,0,0],[7,4,1]] and passed 1, 5" do
		array = [[19,16,13],[0,0,0],[7,4,1]]
		expect(array.subtract_value_from_row_in_array(1,5)).to eq([[19,16,13],[0,0,0],[7,4,1]])
	end

	# changes everything when row includes no zeros
	it "returns [[6,3,0],[8,6,2],[7,4,1]] when called on [[19,16,13],[8,6,2],[7,4,1]] and passed 0, 13" do
		array = [[19,16,13],[8,6,2],[7,4,1]]
		expect(array.subtract_value_from_row_in_array(0,13)).to eq([[6,3,0],[8,6,2],[7,4,1]])
	end

	# raises error when result of subtracting is negative
	it "returns RuntimeError when called on [[9,6,3],[8,6,2],[7,4,1]] and passed 1, 3" do
		array = [[9,6,3],[8,6,2],[7,4,1]]
		expect {array.subtract_value_from_row_in_array(1,3)}.to raise_error(RuntimeError, 'Would result in negative value')
	end

end

describe Array, ".get_ids_and_row_mins" do
	# called on submatrix Array; finds columns that do not contain zeros; outputs an ordered array of ALL arrays [p,q] where 
	# p is the index of a row in the submatrix, and q is a value in that row such that no zeros occur in that value's column
	# in the submatrix; the arrays are ordered by increasing q value, then by increasing row index

	it "works with no zeros in any columns, elements already in order" do
		submatrix = [[1,3,5],[2,4,6]]
		expect(submatrix.get_ids_and_row_mins).to eq([[0,1],[1,2],[0,3],[1,4],[0,5],[1,6]])
	end

	it "works with no zeros in any columns, elements not in order" do
		submatrix = [[1,2,3],[4,5,6]]
		expect(submatrix.get_ids_and_row_mins).to eq([[0,1],[0,2],[0,3],[1,4],[1,5],[1,6]])
	end

	it "does not include elements in columns which contain zeros, when there is only one zero" do
		submatrix = [[10,0,3],[4,15,6]]
		expect(submatrix.get_ids_and_row_mins).to eq([[0,3],[1,4],[1,6],[0,10]])
	end

	it "does not include elements in columns which contain zeros, when there are multiple zeros" do
		submatrix = [[10,21,0],[0,15,6]]
		expect(submatrix.get_ids_and_row_mins).to eq([[1,15],[0,21]])
	end

	it "only outputs unique elements of columns without zero, rows do not share values" do
		submatrix = [[1,2,5],[4,4,0]]
		expect(submatrix.get_ids_and_row_mins).to eq([[0,1],[0,2],[1,4]])
	end

	it "only outputs unique elements per row, rows share values" do
		submatrix = [[1,2,4],[4,0,4]]
		expect(submatrix.get_ids_and_row_mins).to eq([[0,1],[0,4],[1,4]])
	end

	it "works on a big array" do
		submatrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[9,3,0,4,0,7,10],[8,8,0,9,0,9,4],[10,4,0,5,0,4,9]]
		expect(submatrix.get_ids_and_row_mins).to eq([[0,1],[2,1],[3,2],[5,4],[1,6],[2,6],[5,8],[0,9],[4,9],[6,9],[4,10],[6,10],[1,23]])
	end

	it "works when there is only one row" do
		submatrix = [[23,5,0,7,8,9]]
		expect(submatrix.get_ids_and_row_mins).to eq([[0,5],[0,7],[0,8],[0,9],[0,23]])
	end

	it "works when there is only one column, contains zeros" do
		submatrix = [[23],[0],[4],[0],[15]]
		expect(submatrix.get_ids_and_row_mins).to eq([])
	end

	it "works when there is only one column, no zeros" do
		submatrix = [[23],[1],[4],[1],[15]]
		expect(submatrix.get_ids_and_row_mins).to eq([[1,1],[3,1],[2,4],[4,15],[0,23]])
	end



end

describe Matrix, "zero_rows_and_columns" do
	# call on Matrix object; return Matrix object which has been normalized in rows and in columns

	# generates array of arrays N rows by M columns filled with random integers from 1-P inclusive
	# Array.new(N) {Array.new(M) {rand(P)+1}}

	# normalizes rows and then columns:
	# .each.map {|r| r.map {|v| v - r.min}}.transpose.each.map {|r| r.map {|v| v - r.min}}.transpose

	# normalizes columns and then rows:
	# .transpose.each.map {|r| r.map {|v| v - r.min}}.transpose.each.map {|r| r.map {|v| v - r.min}}


	it "works when # of columns = # of rows" do
		matrix = Matrix[[4,11,9,7,4,6,3,3],[12,5,11,11,12,9,2,14],[3,14,14,11,2,4,7,3],[14,3,12,1,2,15,0,1],
				[0,11,9,3,5,7,5,14],[13,9,15,7,3,5,3,1],[3,2,15,11,2,12,12,14],[14,8,6,14,7,7,2,4]]
		expect(matrix.zero_rows_and_columns).to eq(Matrix[[1, 8, 2,  3, 1,  1,  0, 0], [10, 3, 5,  8, 10, 5,  0, 12], [1, 12, 8,  8, 0,  0,  5, 1], [14, 3, 8,  0, 2,  13, 0, 1], 
				[0, 11, 5,  2, 5,  5,  5, 14], [12, 8, 10, 5, 2,  2,  2,  0], [1,  0, 9,  8, 0,  8,  10, 12], [12, 6, 0, 11, 5,  3,  0,  2]])
	end

	it "works when # of rows > # of columns" do
		rand_array = Array.new(40) {Array.new(10) {rand(11)}}
		solution = rand_array.each.map {|r| r.map {|v| v - r.min}}.transpose.each.map {|r| r.map {|v| v - r.min}}.transpose
		matrix = Matrix.columns(rand_array.transpose)
		solution_matrix = Matrix.columns(solution.transpose)
		expect(matrix.zero_rows_and_columns).to eq(solution_matrix)
	end

	it "works when # of columns > # of rows" do
		rand_array = Array.new(20) {Array.new(80) {rand(11)}}
		solution = rand_array.transpose.each.map {|r| r.map {|v| v - r.min}}.transpose.each.map {|r| r.map {|v| v - r.min}}
		matrix = Matrix.columns(rand_array.transpose)
		solution_matrix = Matrix.columns(solution.transpose)
		expect(matrix.zero_rows_and_columns).to eq(solution_matrix)
	end

	it "changes nothing when called on a Matrix that is already normalized" do
		rand_array = Array.new(20) {Array.new(80) {rand(11)}}
		solution = rand_array.transpose.each.map {|r| r.map {|v| v - r.min}}.transpose.each.map {|r| r.map {|v| v - r.min}}
		matrix = Matrix.columns(rand_array.transpose)
		solution_matrix = Matrix.columns(solution.transpose)
		expect(solution_matrix.zero_rows_and_columns).to eq(solution_matrix)
	end

	it "changes nothing in problem case" do
		matrix = Matrix[[1,1,1,1,1,1],[1,4,5,6,3,1],[1,9,3,8,5,1],[1,5,8,7,3,1],[1,3,9,5,7,1],[1,1,1,1,1,1]]
		solution_matrix = Matrix[[0,0,0,0,0,0],[0,3,4,5,2,0],[0,8,2,7,4,0],[0,4,7,6,2,0],[0,2,8,4,6,0],[0,0,0,0,0,0]]	
		expect(matrix.zero_rows_and_columns).to eq(solution_matrix)
	end
end

describe Matrix, '.make_matrix_solveable' do
	# caled on Matrix object; changes the Matrix (if need be) to return a Matrix object which supports complete assignment

end

describe Matrix, '.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(submatrix)' do
	# called on Matrix object, passed array that is a submatrix of the Matrix
	# makes changes to the Matrix it's called on, subtracting the min-sans-zero value in the submatrix from every
	# member in the corresponding row in the Matrix with the exception of zeros
	# repeats the process until min_row_permitted <= max_col_assignments_possible
	# returns the corrected Matrix object it was called on

	it "fixes the matrix minimally when submatrix passed in is only problematic submatrix" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		argument = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2]]
		matrix.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(argument)
		expect(matrix).to eq(Matrix[[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],
			[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

	it "fixes the matrix minimally when submatrix passed in is only one of several problematic submatrices" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		argument = [[2,6,1,0,1,8,2],[8,3,9,0,2,7,1]]
		matrix.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(argument)
		expect(matrix).to eq(Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],
			[1,0,3,9,1,0,6],[1,5,0,0,0,7,1],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

	# this test case is interesting for several reasons: first, multiple changes have to be made; second, the first few changes that will be made
	# create zeros in the same column, so they don't really add new column assignments; third, when one change is made, this changes the values in
	# other rows, meaning that the min values for the rows are constantly changing
	# NOTE: the result of running this method need NOT result in a matrix that is solveable, since it's not being passed the series of minimally
 	# problematic submatrices it contains; it's just being passed a rather large problematic submatrix; when this method is going to be called in the
	# actual algorithm it's first going to be called on all of the smaller submatrices first; and in that case should return a solveable array
	it "fixes the matrix minimally when more than one value has to be changed" do
		matrix = Matrix[[1,9,7,0,5,6,9],[2,7,7,0,7,9,23],[7,3,3,0,4,9,6],[2,6,7,0,7,8,4],[8,3,9,0,8,7,4],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		argument = [[1,9,7,0,5,6,9],[2,7,7,0,7,9,23],[7,3,3,0,4,9,6],[2,6,7,0,7,8,4],[8,3,9,0,8,7,4]]
		matrix.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(argument)
		expect(matrix).to eq(Matrix[[0,8,6,0,4,5,8],[2,7,7,0,7,9,23],[3,0,0,0,0,5,2],[2,6,7,0,7,8,4],
			[8,3,9,0,8,7,4],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

end

describe Matrix, ".make_more_column_assignments_possible" do
	# called on Matrix object; returns Matrix corrected such that min permitted row assignments <= max column assignments possible
		# HOW THIS IS GOING TO WORK
		# 1. Find problematic submatrices
		# 	2. In each such submarix, identify the minimum value-sans-zero in each row
		# 	3. Identify the smallest such min-sans-zero
		# 		4. Subtract the min-sans-zero from every member-sans-zero of the row in which it occurs
		# 5. Repeat step 1 until min permitted row assignments <= max column assignments possible

	it "works when the smallest problematic submmatrix is all that has to be changed" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		expect(matrix.make_more_column_assignments_possible).to eq(Matrix[[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],
			[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

	# should work when there are many problematic submatrices built off the same elements (i.e. which share the same elements)
	it "works when two overlapping problematic submatrices have to be changed" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[8,3,9,0,2,7,1],
			[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		expect(matrix.make_more_column_assignments_possible).to eq(Matrix[[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],
				[1,0,3,9,1,0,6],[1,5,0,0,0,7,1],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

	# should work when there are two distinct problematic submatrices (i.e. which do not share any elements)
	it "works when two distinct problematic submatrices have to be changed" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[4,3,0,4,0,7,4],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]]
		expect(matrix.make_more_column_assignments_possible).to eq(Matrix[[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],[0,0,2,8,0,0,5],[2,6,1,0,1,8,2],
			[0,0,0,0,0,3,0],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]])
	end

	# original algorithm does not handle this case correctly; it changes [2,6,1,0,1,8,2] into [1,6,0,0,0,8,1] and then into [0,4,0,0,0,6,0]
	# to resolve the conflict, when it could have changed [1,0,0,1,0,4,1] into [0,0,0,0,0,3,0] to resolve the conflict;
	# the former change requires changing values by 2, the latter only by 1; by the principle of minimal mutilation, the second should be
	# preferred
	it "works when two distinct problematic submatrices have to be changed, hard case" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[4,3,0,4,0,7,4],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]]
		expect(matrix.make_more_column_assignments_possible).to eq(Matrix[[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],[0,0,2,8,0,0,5],[2,6,1,0,1,8,2],
			[0,0,0,0,0,3,0],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]])
	end

end

describe Matrix, ".get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible" do
	# Call on Matrix object; returns array of submatrices (in array format) for which the number of minimum row assignments permitted
	# is greater than then number of possible column assignments
	# def get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible

	# returns nothing when there are no such submatrices
	it "returns [] when called on Matrix[[1,2,0],[0,3,9]]" do
		matrix = Matrix[[1,2,0],[0,3,9]]
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible).to eq([])
	end

	# should work when there is exactly one problematic submatrix
	it "returns one submatrix when called on Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],
		[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible.count).to eq(1)
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible).to eq([ [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],
			[1,0,3,9,1,0,6],[2,6,1,0,1,8,2]]])
	end

	# should work when there are many problematic submatrices built off the same elements (i.e. which share the same elements)
	it "returns nine submatrices when called on Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],
		[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible.count).to eq(9)
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible).to eq([
			[[2, 6, 1, 0, 1, 8, 2], [8, 3, 9, 0, 2, 7, 1]], 
			[[1, 0, 1, 0, 5, 6, 9], [2, 6, 1, 0, 1, 8, 2], [8, 3, 9, 0, 2, 7, 1]], 
			[[6, 7, 1, 0, 1, 0, 23], [2, 6, 1, 0, 1, 8, 2], [8, 3, 9, 0, 2, 7, 1]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [8, 3, 9, 0, 2, 7, 1]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [2, 6, 1, 0, 1, 8, 2], [8, 3, 9, 0, 2, 7, 1]], 
			[[1, 0, 1, 0, 5, 6, 9], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [8, 3, 9, 0, 2, 7, 1]], 
			[[6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [8, 3, 9, 0, 2, 7, 1]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [8, 3, 9, 0, 2, 7, 1]]
			])
	end

	# should work when there are two distinct problematic submatrices (i.e. which do not share any elements)
	# it should identify the minimal distinct problematic submatrices first, then combine any parts of them which are problematic
	it "returns one submatrix when called on Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],
		[2,6,1,0,1,8,2],[4,3,0,4,0,7,4],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]]" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[4,3,0,4,0,7,4],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]]
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible.count).to eq(13)
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible).to eq([
			[[4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2]], 
			[[2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[1, 0, 1, 0, 5, 6, 9], [2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[6, 7, 1, 0, 1, 0, 23], [2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[1, 0, 1, 0, 5, 6, 9], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]], 
			[[1, 0, 1, 0, 5, 6, 9], [6, 7, 1, 0, 1, 0, 23], [1, 0, 3, 9, 1, 0, 6], [2, 6, 1, 0, 1, 8, 2], [4, 3, 0, 4, 0, 7, 4], [4, 8, 0, 9, 0, 9, 4], [4, 4, 0, 5, 0, 4, 9]]])
	end

end


describe Matrix, ".find_matching_row_then_subtract_value" do

	# called on Matrix; finds all rows matching the row_to_match (data type: array) given as first parameter;
	# subtracts input value from each member of each row matching the row_array, skips over zeros
	# returns corrected Matrix object
	# PARAMETERS (row_to_match, value_to_subtract)

	# it should work when passed a Matrix with just one row
	it "returns Matrix[[0,0,0,2]] when called on Matrix[[2,2,0,4]] and passed [2,2,0,4] and 2" do
		matrix = Matrix[[2,2,0,4]]
		matrix.find_matching_row_then_subtract_value([2,2,0,4],2)
		expect(matrix).to eq(Matrix[[0,0,0,2]])
	end

	# it should work when passed the same row in a larger Matrix
	it "returns Matrix[[0,0,0,4],[7,8,9,2],[3,3,1,9]] when called on Matrix[[2,2,0,4],[7,8,9,2],[3,3,1,9]] and passed [2,2,0,4] and 2" do
		matrix = Matrix[[2,2,0,4],[7,8,9,2],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,2,0,4],2)
		expect(matrix).to eq(Matrix[[0,0,0,2],[7,8,9,2],[3,3,1,9]])
	end

	# it should work when the row isn't the first row in a larger Matrix
	it "returns Matrix[[7,8,9,2],[0,0,0,4],[3,3,1,9]] when called on Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]] and passed [2,2,0,4] and 2" do
		matrix = Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,2,0,4],2)
		expect(matrix).to eq(Matrix[[7,8,9,2],[0,0,0,2],[3,3,1,9]])
	end

	# it shouldn't change anything when passed a row it doesn't contain, but is passed a row CLOSE to a row it contains
	it "returns Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]] when called on Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]] and passed [2,0,4] and 2" do
		matrix = Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,0,4],2)
		expect(matrix).to eq(Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]])
	end

	# it shouldn't change anything when passed a row it doesn't contain, but is passed a row CLOSE to a row it contains
	it "returns Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]] when called on Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]] and passed [2,2,0,4,1] and 2" do
		matrix = Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,0,4],2)
		expect(matrix).to eq(Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]])
	end

	# it shouldn't change anything when passed a value of zero, along with a row it does contain
	it "returns Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]] when called on Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]] and passed [2,2,0,4] and 0" do
		matrix = Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,0,4],2)
		expect(matrix).to eq(Matrix[[7,8,9,2],[2,2,0,4],[3,3,1,9]])
	end

end

describe Matrix, ".add_value_if_zero_else_subtract_value_in_columns" do

	# called on Matrix object, takes column index and value as inputs
	# outputs Matrix in which the value provided has been added to each zero in the column and subtracted otherwise
		# def add_value_if_zero_else_subtract_value_in_columns(col_index, value)

	# it should add the value to each member of a column that contains only zeros
	it "returns Matrix[[2,2,9,5,6,8],[2,4,6,8,1,0],[2,2,4,7,8,0],[2,9,8,4,6,3],[2,6,4,9,2,4]] when called on 
		Matrix[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]] and passed 0, 2" do
		matrix = Matrix[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(0,2)).to eq(Matrix[[2,2,9,5,6,8],[2,4,6,8,1,0],[2,2,4,7,8,0],[2,9,8,4,6,3],[2,6,4,9,2,4]])
	end

	# it should add the value to each member of a column that contains many zeros
	it "returns Matrix[[0,2,9,5,6,8],[0,4,6,8,1,9],[0,2,4,7,8,9],[0,9,8,4,6,3],[0,6,4,9,2,4]] when called on 
		Matrix[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]] and passed 5, 9" do
		matrix = Matrix[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(5,9)).to eq(Matrix[[0,2,9,5,6,-1],[0,4,6,8,1,9],[0,2,4,7,8,9],[0,9,8,4,6,-6],[0,6,4,9,2,-5]])
	end

	# it should add the value even if it is very large
	it "returns Matrix[[1,4,1000006],[8,11,1000013]] when called on 
		Matrix[[1,4,6],[8,11,13]] and passed 1, 6" do
		matrix = Matrix[[1,4,0],[8,11,0]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(2,1000000)).to eq(Matrix[[1,4,1000000],[8,11,1000000]])
	end

	# it should subtract the value to each member of a column that contains no zeros
	it "returns Matrix[[0,3,9,5,6,8],[0,3,6,8,1,0],[0,3,4,7,8,0],[0,3,8,4,6,3],[0,0,4,9,2,4],[2,1,7,3,6,3]] when called on 
		Matrix[[0,9,9,5,6,8],[0,9,6,8,1,0],[0,9,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4],[2,7,7,3,6,3]] and passed 1, 6" do
		matrix = Matrix[[0,9,9,5,6,8],[0,9,6,8,1,0],[0,9,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4],[2,7,7,3,6,3]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(1,6)).to eq(Matrix[[0,3,9,5,6,8],[0,3,6,8,1,0],[0,3,4,7,8,0],[0,3,8,4,6,3],[0,0,4,9,2,4],[2,1,7,3,6,3]])
	end

	# it should leave the column unchanged if it is passed a value of zero
	it "returns Matrix[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]] when called on 
		Matrix[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]] and passed anything with 0" do
		matrix = Matrix[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]]
		anything = (rand*10).ceil
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(anything,0)).to eq(Matrix[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]])
	end

	# it should throw an error if passed a column index for a column that doesn't exist

	# it should throw an error if passed a non-integer

	# it should throw an error if passed a non-number

	# it should throw an error if passed a negative value
end

describe Matrix, ".get_problematic_columns_per_problematic_row" do
		# called on Matrix object; outputs array of arrays [n,m,o] where n is the index of a row with too many lonely zeros
		# m is the number of lonely zero's in row n
		# and o is an ORDERED array that contains arrays [p,q] where p is a column index of a lonely zero in row n, 
		# and q is the min value in that column other than zero, ordered by ascending q value

	# multiple rows have too many lonely zeros, but columns are already ordered by ascending min-sans-zero value
	it "returns [[1,2,[[1,1],[2,7]]],[3,2,[[0,1],[4,3]]]] when called on Matrix[[3,3,9,0,7],[5,0,0,0,2],[6,6,7,0,3],[0,1,7,6,0],[1,6,8,0,3]]" do
		matrix = Matrix[[3,3,9,0,7],[5,0,0,0,2],[6,6,7,0,3],[0,1,7,6,0],[1,6,8,0,3]]
		expect(matrix.get_problematic_columns_per_problematic_row).to eq([[1,2,[[1,1],[2,7]]],[3,2,[[0,1],[4,2]]]])
	end

	# multiple rows have too many lonely zeros, but columns are NOT ordered by ascending min-sans-zero value
	it "returns [[1,2,[[2,1],[1,7]]],[3,2,[[4,1],[0,3]]]] when called on Matrix[[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]" do
		matrix = Matrix[[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]
		expect(matrix.get_problematic_columns_per_problematic_row).to eq([[1,2,[[2,1],[1,7]]],[3,2,[[4,1],[0,3]]]])
	end

	# no rows have too many lonely zeros
	it "returns [] when called on Matrix[[1,2,0],[3,0,9],[0,5,4]]" do
		matrix = Matrix[[1,2,0],[3,0,9],[0,5,4]]
		expect(matrix.get_problematic_columns_per_problematic_row).to eq([])
	end

end

describe Matrix, ".zero_fewest_problematic_columns" do
	# called on Matrix object; takes as input an array of arrays [n,m,o] where n is a row index, m is the number of lonely zeros in that row
	# and o is an ordered array of arrays [p,q] where p is the column index of a lonely zero in row n, and q is the min value in that column other than zero
	# see method "get_problematic_columns_per_problematic_row" for a convenient way to get a parameter like this
	# for each member of the array passed to this method as a parameter, the method adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited matrix object it was called on
	# def zero_fewest_problematic_columns(problematic_columns)

	# corrects minimum number of columns, and only those with the lowest min-sans-zero values
	it "returns Matrix[[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]] when called on
			    Matrix[[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]] and passed [[1,2,[[2,1],[1,7]]],[3,2,[[4,1],[0,3]]]]" do
		matrix = Matrix[[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]
		expect(matrix.zero_fewest_problematic_columns([[1,2,[[2,1],[1,7]]],[3,2,[[4,1],[0,3]]]])).to eq(Matrix[[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]])
	end

	# corrects minimum number of columns, and only those with the lowest min-sans-zero values
	it "returns Matrix[[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]] when called on
			    Matrix[[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]] and passed result of get_problematic_columns_per_problematic_row" do
		matrix = Matrix[[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]
		expect(matrix.zero_fewest_problematic_columns(matrix.get_problematic_columns_per_problematic_row)).to eq(Matrix[[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]])
	end

	# already vigorously tested the method that this method was written from, i.e. zero_fewest_problematic_rows
	# if this test passes, I'm satisfied this is going to work...

end

describe Matrix, ".fix_too_many_lonely_zeros_in_rows" do
	# corrects minimum number of columns, and only those with the lowest min-sans-zero values
	it "returns Matrix[[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]] when called on
			    Matrix[[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]" do
		matrix = Matrix[[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]
		expect(matrix.fix_too_many_lonely_zeros_in_rows).to eq(Matrix[[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]])
	end

	# already vigorously tested the method that this method was written from, i.e. fix_too_many_lonely_zeros_in_columns
	# if this test passes, I'm satisfied this is going to work...
end

describe Matrix, ".zero_fewest_problematic_rows" do
	# called on matrix object, for each row specified in params, adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns editted matrix object it was called on
		# problematic rows must be an array of arrays [n,m,o], one for each problematic column
		# n is the column index, m is the number of lonely zeros in column n
		# o is an ORDERED array containing all arrays [p,q] where p is the row index of a row containing a lonely zero in column n
		# and q is the minimum value in that row-sans-zero; o is ordered by ascending q value
		# the "get_problematic_rows_per_problematic_column" method returns exactly this array

	# it shouldn't change the Matrix if passed an empty array
	it "returns Matrix[[0,1,4],[5,7,0],[9,0,9]] when called on Matrix[[0,1,4],[5,7,0],[9,0,9]] and passed []" do
		matrix = Matrix[[0,1,4],[5,7,0],[9,0,9]]
		expect(matrix.zero_fewest_problematic_rows([])).to eq(Matrix[[0,1,4],[5,7,0],[9,0,9]])
	end

	# a possible big problem: if (1) fixing a matrix leads to an unsolveable matrix,
	# and (2) running the method again on the problematic matrix it generates just brings it back to the original problematic array
	# the following scenario almost fits the bill here

			# does it work when passed a small problematic array?
			it "returns Matrix[[0,5,6],[1,0,2],[9,0,4]] when called on Matrix[[0,5,6],[0,1,3],[9,0,4]] 
				and passed [[0,2,[[1,1],[0,5]]]" do
				matrix = Matrix[[0,5,6],[0,1,3],[9,0,4]]
				expect(matrix.zero_fewest_problematic_rows([[0,2,[[1,1],[0,5]]]])).to eq(Matrix[[0,5,6],[1,0,2],[9,0,4]])
			end

			# does it work on the array it produces in the previous example?
			it "returns Matrix[[0,5,6],[0,1,3],[9,0,4]] when called on Matrix[[0,5,6],[1,0,2],[9,0,4]] 
				and passed [[1,2,[[1,1],[2,4]]]" do
				matrix = Matrix[[0,5,6],[1,0,2],[9,0,4]]
				expect(matrix.zero_fewest_problematic_rows([[1,2,[[1,1],[2,4]]]])).to eq(Matrix[[0,5,6],[0,1,1],[9,0,4]])
			end

			# does it work on the array it produces in the previous example?
			it "returns Matrix[[0,5,6],[1,0,0],[9,0,4]] when called on Matrix[[0,5,6],[0,1,1],[9,0,4]] 
				and passed [[0,2,[[1,1],[0,5]]]]" do
				matrix = Matrix[[0,5,6],[0,1,1],[9,0,4]]
				expect(matrix.zero_fewest_problematic_rows([[0,2,[[1,1],[0,5]]]])).to eq(Matrix[[0,5,6],[1,0,0],[9,0,4]])
			end

			# ---------------------------------------------
			# second attempt to produce the vicious loop
				# it "returns Matrix[[1,0,0,1],[0,2,2,0],[8,0,0,8]] when called on matrix = Matrix[[0,1,1,0],[0,2,2,0],[8,0,0,8]] and 
				# passed matrix.get_problematic_rows_per_problematic_column" do
					# this doesn't work either! none of these zeros is lonely!

	# does it work when passed problematic_rows directly when there are multiple columns with too many lonely zeros, and those zeros occur in rows with differing min-sans-zero values?
	it "returns Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]]
		when called on Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]],
			and passed [[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]]" do
		matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.zero_fewest_problematic_rows([[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]])).to eq(Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],
			[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]])
	end

	# does it work with the get_problematic_rows_per_problematic_column method when there are multiple columns with too many lonely zeros, and those zeros occur in rows with differing min-sans-zero values?
	it "returns Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]]
		when called on matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]],
			and passed matrix.get_problematic_rows_per_problematic_column" do
		matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.zero_fewest_problematic_rows(matrix.get_problematic_rows_per_problematic_column)).to eq(Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],
			[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]])
	end
end


describe Matrix, ".fix_too_many_lonely_zeros_in_columns" do
		# isolate the columns that are causing the problem, then the rows in those columns that contain their lonely zeros
		# PROBLEM: it could be that there are multiple columns with too many lonely zeros, e.g. one col might have 4, another 2
			# and if the max col assignment were 1, you would want to add_value_if_zero to 3 of the 4 rows in the first group
			# and only 1 of the 2 rows in the second group
			# so you need some way of keeping track of these groups

		# now make the fewest changes necessary to remove the problem, and determine which row to correct based on the other values in that row
		# you want to correct the row with the lowest min value first, then the row with the next lowest, then with the next lowest, and so on
		# point is: you want to minimize the extent to which you have to lower values to get an assignment

	# does it work when there are multiple columns with too many lonely zeros, and those zeros occur in rows with differing min-sans-zero values?
	it "returns Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]]
		when called on matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]" do
		matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq(Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],
			[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]])
	end

	# does it work when passed a small problematic array?
	it "returns Matrix[[0,5,6],[1,0,2],[9,0,4]] when called on Matrix[[0,5,6],[0,1,3],[9,0,4]]" do
		matrix = Matrix[[0,5,6],[0,1,3],[9,0,4]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq(Matrix[[0,5,6],[1,0,2],[9,0,4]])
	end

	# does it work on the array it produces in the previous example?
	it "returns Matrix[[0,5,6],[0,1,3],[9,0,4]] when called on Matrix[[0,5,6],[1,0,2],[9,0,4]]" do
		matrix = Matrix[[0,5,6],[1,0,2],[9,0,4]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq(Matrix[[0,5,6],[0,1,1],[9,0,4]])
	end

	# does it work on the array it produces in the previous example?
	it "returns Matrix[[0,5,6],[1,0,0],[9,0,4]] when called on Matrix[[0,5,6],[0,1,1],[9,0,4]]" do
		matrix = Matrix[[0,5,6],[0,1,1],[9,0,4]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq(Matrix[[0,5,6],[1,0,0],[9,0,4]])
	end

	# does it leave an unproblematic array unchanged?
	it "returns Matrix[[0,3,4],[7,0,9],[3,3,0]] when called on Matrix[[0,3,4],[7,0,9],[3,3,0]]" do
		matrix = Matrix[[0,3,4],[7,0,9],[3,3,0]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq(Matrix[[0,3,4],[7,0,9],[3,3,0]])
	end

	# does it work when there are many rows to fix?
	it "returns	Matrix[[0,7],[0,9],[2,0],[1,0],[1,0],[0,35],[0,23],[0,9],[4,0]] when called on 
		Matrix[[0,7],[0,9],[0,2],[0,1],[0,1],[0,35],[0,23],[0,9],[0,4]]" do
		matrix = Matrix[[0,7],[0,9],[0,2],[0,1],[0,1],[0,35],[0,23],[0,9],[0,4]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq(Matrix[[0,7],[0,9],[2,0],[1,0],[1,0],[0,35],[0,23],[0,9],[4,0]])
	end

end

describe Matrix, ".get_problematic_rows_per_problematic_column" do
	# outputs array of arrays [n,m,o] where n is the index of a column with too many lonely zeros
	# m is the number of lonely zero's in column n
	# and o is an ORDERED array that contains arrays [p,q] where p is a row index of a lonely zero in column n, 
	# and q is the min value in that row other than zero, ordered by ascending q value
	
	# test with one problematic column, when rows are in order of min-sans-zero
	it "returns [[0,2,[[0,1],[1,3]]] when called on Matrix[[0,1,9],[0,3,3],[0,6,0]]" do
		matrix = Matrix[[0,1,9],[0,3,3],[0,6,0]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([[0,2,[[0,1],[1,3]]]])
	end

	# test same array as above, but add a row to increase the max_col_assignment for the array
	# this will eliminate all the previously problematic columns
	it "returns [] when called on Matrix[[0,1,9],[0,3,3],[0,6,0],[4,5,6]]" do
		matrix = Matrix[[0,1,9],[0,3,3],[0,6,0],[4,5,6]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([])
	end

	# test it on an array that is solveable
	it "returns [] when called on Matrix[[0,1,4],[5,7,0],[9,0,9]]" do
		matrix = Matrix[[0,1,4],[5,7,0],[9,0,9]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([])
	end

	# case where there are no lonely zeros in the matrix at all
	it "returns [] when called on Matrix[[0,1,0],[0,7,0],[0,7,0]]" do
		matrix = Matrix[[0,1,0],[0,7,0],[0,7,0]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([])
	end

	# case where multiple columns have too many lonely zeros, order is not being checked yet
	it "returns [[[0,2,[[0,2],[2,5]]],[3,3,[[1,3],[3,7],[4,8]]] when called on 
		Matrix[[0,5,4,3,2,9,10,17],[8,9,3,0,4,4,44,49],[0,5,5,5,5,5,55,52],[7,7,7,0,7,7,88,81],[8,8,8,0,8,8,8,777]]" do
		matrix = Matrix[[0,5,4,3,2,9,10,17],[8,9,3,0,4,4,44,49],[0,5,5,5,5,5,55,52],[7,7,7,0,7,7,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([[0,2,[[0,2],[2,5]]],[3,3,[[1,3],[3,7],[4,8]]]])
	end

	# case where multiple columns have too many lonely zeros, checking for correct matrix order
	it "returns [[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]] when called on 
		Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]" do
		matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]])
	end

end

describe Matrix, ".add_value_if_zero_else_subtract_value_in_rows" do
	it "returns Matrix[[3,3,0,1,2,6]] when run on Matrix[[0,0,3,4,5,9]] and passed 0 and 3" do
		matrix = Matrix[[0,0,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(0, 3)).to eq(Matrix[[3,3,0,1,2,6]])
	end

	it "returns Matrix[[5,0,2,3,4,8]] when run on Matrix[[6,1,3,4,5,9]] and passed 0 and 1" do
		matrix = Matrix[[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(0, 1)).to eq(Matrix[[5,0,2,3,4,8]])
	end

	it "returns Matrix[[6,1,3,4,5,9]] when run on Matrix[[6,1,3,4,5,9]] and passed 1 and 1" do
		matrix = Matrix[[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(1, 1)).to eq(Matrix[[6,1,3,4,5,9]])
	end

	it "returns Matrix[[6,1,3,4,5,9]] when run on Matrix[[6,1,3,4,5,9]] and passed 100 and 1" do
		matrix = Matrix[[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(100, 1)).to eq(Matrix[[6,1,3,4,5,9]])
	end

	it "returns Matrix[[6,1,3,4,5,9],[1,0,4,5,0,4]] when run on Matrix[[6,1,3,4,5,9],[5,4,0,9,4,0]] and passed 1 and 4" do
		matrix = Matrix[[6,1,3,4,5,9],[5,4,0,9,4,0]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(1, 4)).to eq(Matrix[[6,1,3,4,5,9],[1,0,4,5,0,4]])
	end

	it "returns Matrix[[6,1,3,4,5,9],[0,4,1,4,4,4],[5,4,0,9,4,0]] when run on Matrix[[6,1,3,4,5,9],[4,0,5,0,0,0],[5,4,0,9,4,0]] and passed 1 and 4" do
		matrix = Matrix[[6,1,3,4,5,9],[4,0,5,0,0,0],[5,4,0,9,4,0]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(1, 4)).to eq(Matrix[[6,1,3,4,5,9],[0,4,1,4,4,4],[5,4,0,9,4,0]])
	end
end

describe Matrix, ".rows" do
	it "returns an array containing Vectors of each row in the matrix it is called on" do
		matrix = Matrix[[1,2,3],[9,7,6]]
		expect(matrix.rows).to eq([Vector[1,2,3],Vector[9,7,6]])
	end

	it "returns an array of nil Vectors when called on an empty matrix" do
		matrix = Matrix.build(1, 2) {}
		expect(matrix.rows).to eq([Vector[nil, nil]])
	end
end

describe Matrix, ".solveable?" do
	it "returns failure code when run on Matrix[[1,2],[1,2]]" do
		matrix = Matrix[[1,2],[1,2]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns true when run on Matrix[[0,0,0],[0,9,0],[0,7,8]]" do
		matrix = Matrix[[0,0,0],[0,9,0],[0,7,8]]
		expect(matrix.solveable?).to eq(true)
	end

	it "returns failure code when run on Matrix[[0,3,0],[0,5,0],[0,1,0]]" do
		matrix = Matrix[[0,3,0],[0,5,0],[0,1,0]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns failure code when run on Matrix[[5,0,3],[4,0,2],[8,0,8]]" do
		matrix = Matrix[[5,0,3],[4,0,2],[8,0,8]]
		expect(matrix.solveable?).to eq("no, too many lonely zeros in columns")
	end

	# this is an interesting case, it has too many loney zeros in column 1, and too many lonely zeros in row 1
	it "returns failure code when run on Matrix[[4,0,1],[0,7,0],[9,0,2]]" do
		matrix = Matrix[[4,0,1],[0,7,0],[9,0,2]]
		expect(matrix.solveable?).to eq("no, too many lonely zeros in columns")
	end

	it "returns true when run on Matrix[[0,0,0],[4,0,6],[0,0,0]]" do
		matrix = Matrix[[0,0,0],[4,5,6],[0,0,0]]
		expect(matrix.solveable?).to eq(true)
	end

	it "returns failure code when run on Matrix[[1,0,1,0,5,6],[6,7,1,0,1,0],[1,0,3,9,1,0],[2,6,1,0,1,8]]" do
		matrix = Matrix[[1,0,1,0,5,6],[6,7,1,0,1,0],[1,0,3,9,1,0],[2,6,1,0,1,8]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns failure code when run on Matrix[[1,0,1,9,5,6,9],[6,7,1,0,1,9,23],[1,9,3,0,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]" do
		matrix = Matrix[[1,0,1,9,5,6,9],[6,7,1,0,1,9,23],[1,9,3,0,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]
		expect(matrix.solveable?).to eq("no, too many lonely zeros in columns")
	end

	it "returns failure code when run on Matrix[[1,7,1,3,5,6,9],[6,7,1,5,1,5,23],[1,3,3,9,1,9,6],[2,6,1,9,1,8,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = Matrix[[1,0,1,7,5,6,9],[6,7,1,0,1,0,23],[1,7,3,9,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns failure code when run on Matrix[[1,6,1,2,0,0,0],[0,7,0,6,3,8,4],[1,1,3,1,0,0,0],[0,0,9,0,4,9,5],
				[5,1,1,1,0,0,0],[6,0,0,8,7,9,4],[9,23,6,2,0,0,9]]" do
		matrix = Matrix[[1,6,1,2,0,0,0],[0,7,0,6,3,8,4],[1,1,3,1,0,0,0],[0,0,9,0,4,9,5],
				[5,1,1,1,0,0,0],[6,0,0,8,7,9,4],[9,23,6,2,0,0,9]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns failure code when run on Matrix[[1,6,1,2],[0,7,0,6],[1,1,3,1],[0,0,9,0],[5,1,1,1],[6,0,0,8],[9,23,6,2]]" do
		matrix = Matrix[[1,6,1,2],[0,7,0,6],[1,1,3,1],[0,0,9,0],[5,1,1,1],[6,0,0,8],[9,23,6,2]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end	

	# min_row_assmts_permitted > max_column_assmts_possible for any submatrix

# next test some matrices that will allow for multiple assignments in rows, then in columns

end
