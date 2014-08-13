# to use: navigate to the directory of this file in the terminal, then type "rspec <file name here>"

$LOAD_PATH << '.'
require 'testing'

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
	it "returns [[9,6,3],[8,6,2],[7,4,1] when called on [[9,8,7],[6,5,4],[3,2,1]]" do
		array = [[9,8,7],[6,5,4],[3,2,1]]
		expect(array.array_columns).to eq([[9,6,3],[8,5,2],[7,4,1]])
	end

	it "returns [[1]] when called on [[1]]" do
		array = [[1]]
		expect(array.array_columns).to eq([[1]])
	end
end

describe Matrix, "zero_fewest_problematic_rows" do
	# called on matrix object, for each row specified in params, adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns editted matrix object it was called on
		# problematic rows must be an array of arrays [n,m,o], one for each problematic column
		# n is the column index, m is the number of lonely zeros in column n
		# o is an ORDERED array containing all arrays [p,q] where p is the row index of a row containing a lonely zero in column n
		# and q is the minimum value in that row-sans-zero; o is ordered by ascending q value
		# the "get_problematic_rows" method returns exactly this array

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
				# passed matrix.get_problematic_rows" do
					# this doesn't work either! none of these zeros is lonely!

	# does it work when passed problematic_rows directly when there are multiple columns with too many lonely zeros, and those zeros occur in rows with differing min-sans-zero values?
	it "returns Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]]
		when called on Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]],
			and passed [[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]]" do
		matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.zero_fewest_problematic_rows([[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]])).to eq(Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],
			[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]])
	end

	# does it work with the get_problematic_rows method when there are multiple columns with too many lonely zeros, and those zeros occur in rows with differing min-sans-zero values?
	it "returns Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]]
		when called on matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]],
			and passed matrix.get_problematic_rows" do
		matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.zero_fewest_problematic_rows(matrix.get_problematic_rows)).to eq(Matrix[[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],
			[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]])
	end
end


describe Matrix, "fix_too_many_lonely_zeros_in_columns" do
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
	


end

describe Matrix, "get_problematic_rows" do
	# outputs array of arrays [n,m,o] where n is the index of a column with too many lonely zeros
	# m is the number of lonely zero's in column n
	# and o is an ORDERED array that contains arrays [p,q] where p is a row index of a lonely zero in column n, 
	# and q is the min value in that row other than zero, ordered by ascending q value
	
	# test with one problematic column, when rows are in order of min-sans-zero
	it "returns [[0,2,[[0,1],[1,3]]] when called on Matrix[[0,1,9],[0,3,3],[0,6,0]]" do
		matrix = Matrix[[0,1,9],[0,3,3],[0,6,0]]
		expect(matrix.get_problematic_rows).to eq([[0,2,[[0,1],[1,3]]]])
	end

	# test same array as above, but add a row to increase the max_col_assignment for the array
	# this will eliminate all the previously problematic columns
	it "returns [] when called on Matrix[[0,1,9],[0,3,3],[0,6,0],[4,5,6]]" do
		matrix = Matrix[[0,1,9],[0,3,3],[0,6,0],[4,5,6]]
		expect(matrix.get_problematic_rows).to eq([])
	end

	# test it on an array that is solveable
	it "returns [] when called on Matrix[[0,1,4],[5,7,0],[9,0,9]]" do
		matrix = Matrix[[0,1,4],[5,7,0],[9,0,9]]
		expect(matrix.get_problematic_rows).to eq([])
	end

	# case where there are no lonely zeros in the matrix at all
	it "returns [] when called on Matrix[[0,1,0],[0,7,0],[0,7,0]]" do
		matrix = Matrix[[0,1,0],[0,7,0],[0,7,0]]
		expect(matrix.get_problematic_rows).to eq([])
	end

	# case where multiple columns have too many lonely zeros, order is not being checked yet
	it "returns [[[0,2,[[0,2],[2,5]]],[3,3,[[1,3],[3,7],[4,8]]] when called on 
		Matrix[[0,5,4,3,2,9,10,17],[8,9,3,0,4,4,44,49],[0,5,5,5,5,5,55,52],[7,7,7,0,7,7,88,81],[8,8,8,0,8,8,8,777]]" do
		matrix = Matrix[[0,5,4,3,2,9,10,17],[8,9,3,0,4,4,44,49],[0,5,5,5,5,5,55,52],[7,7,7,0,7,7,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.get_problematic_rows).to eq([[0,2,[[0,2],[2,5]]],[3,3,[[1,3],[3,7],[4,8]]]])
	end

	# case where multiple columns have too many lonely zeros, checking for correct matrix order
	it "returns [[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]] when called on 
		Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]" do
		matrix = Matrix[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.get_problematic_rows).to eq([[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]])
	end

end

describe Matrix, "add_value_if_zero_else_subtract_value" do
	it "returns Matrix[[3,3,0,1,2,6]] when run on Matrix[[0,0,3,4,5,9]] and passed 0 and 3" do
		matrix = Matrix[[0,0,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value(0, 3)).to eq(Matrix[[3,3,0,1,2,6]])
	end

	it "returns Matrix[[5,0,2,3,4,8]] when run on Matrix[[6,1,3,4,5,9]] and passed 0 and 1" do
		matrix = Matrix[[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value(0, 1)).to eq(Matrix[[5,0,2,3,4,8]])
	end

	it "returns Matrix[[6,1,3,4,5,9]] when run on Matrix[[6,1,3,4,5,9]] and passed 1 and 1" do
		matrix = Matrix[[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value(1, 1)).to eq(Matrix[[6,1,3,4,5,9]])
	end

	it "returns Matrix[[6,1,3,4,5,9]] when run on Matrix[[6,1,3,4,5,9]] and passed 100 and 1" do
		matrix = Matrix[[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value(100, 1)).to eq(Matrix[[6,1,3,4,5,9]])
	end

	it "returns Matrix[[6,1,3,4,5,9],[1,0,4,5,0,4]] when run on Matrix[[6,1,3,4,5,9],[5,4,0,9,4,0]] and passed 1 and 4" do
		matrix = Matrix[[6,1,3,4,5,9],[5,4,0,9,4,0]]
		expect(matrix.add_value_if_zero_else_subtract_value(1, 4)).to eq(Matrix[[6,1,3,4,5,9],[1,0,4,5,0,4]])
	end

	it "returns Matrix[[6,1,3,4,5,9],[0,4,1,4,4,4],[5,4,0,9,4,0]] when run on Matrix[[6,1,3,4,5,9],[4,0,5,0,0,0],[5,4,0,9,4,0]] and passed 1 and 4" do
		matrix = Matrix[[6,1,3,4,5,9],[4,0,5,0,0,0],[5,4,0,9,4,0]]
		expect(matrix.add_value_if_zero_else_subtract_value(1, 4)).to eq(Matrix[[6,1,3,4,5,9],[0,4,1,4,4,4],[5,4,0,9,4,0]])
	end
end

describe Matrix, "#rows" do
	it "returns an array containing Vectors of each row in the matrix it is called on" do
		matrix = Matrix[[1,2,3],[9,7,6]]
		expect(matrix.rows).to eq([Vector[1,2,3],Vector[9,7,6]])
	end

	it "returns an array of nil Vectors when called on an empty matrix" do
		matrix = Matrix.build(1, 2) {}
		expect(matrix.rows).to eq([Vector[nil, nil]])
	end
end

describe Matrix, "solveable?" do
	it "doesn't return false when run on Matrix[[1,2],[1,2]]" do
		matrix = Matrix[[1,2],[1,2]]
		expect(matrix.solveable?).to_not eq(false)
	end

	it "returns false when run on Matrix[[0,3,0],[0,5,0],[0,1,0]]" do
		matrix = Matrix[[0,3,0],[0,5,0],[0,1,0]]
		expect(matrix.solveable?).to eq(false)
	end

	it "returns false when run on Matrix[[5,0,3],[4,0,2],[8,0,8]]" do
		matrix = Matrix[[5,0,3],[4,0,2],[8,0,8]]
		expect(matrix.solveable?).to eq(false)
	end

	it "returns false when run on Matrix[[4,0,1],[0,7,0],[9,0,2]]" do
		matrix = Matrix[[4,0,1],[0,7,0],[9,0,2]]
		expect(matrix.solveable?).to eq(false)
	end

	it "returns false when run on Matrix[[0,0,0],[4,0,6],[0,0,0]]" do
		matrix = Matrix[[0,0,0],[4,5,6],[0,0,0]]
		expect(matrix.solveable?).to eq(false)
	end

	it "returns false when run on Matrix[[1,0,1,0,5,6],[6,7,1,0,1,0],[1,0,3,9,1,0],[2,6,1,0,1,8]]" do
		matrix = Matrix[[1,0,1,0,5,6],[6,7,1,0,1,0],[1,0,3,9,1,0],[2,6,1,0,1,8]]
		expect(matrix.solveable?).to eq(false)
	end

	it "returns false when run on Matrix[[1,0,1,9,5,6,9],[6,7,1,0,1,9,23],[1,9,3,0,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]" do
		matrix = Matrix[[1,0,1,9,5,6,9],[6,7,1,0,1,9,23],[1,9,3,0,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]
		expect(matrix.solveable?).to eq(false)
	end

	it "returns false when run on Matrix[[1,7,1,3,5,6,9],[6,7,1,5,1,5,23],[1,3,3,9,1,9,6],[2,6,1,9,1,8,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = Matrix[[1,0,1,7,5,6,9],[6,7,1,0,1,0,23],[1,7,3,9,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]
		expect(matrix.solveable?).to eq(false)
	end

	it "returns false when run on Matrix[[1,6,1,2,0,0,0],[0,7,0,6,3,8,4],[1,1,3,1,0,0,0],[0,0,9,0,4,9,5],
				[5,1,1,1,0,0,0],[6,0,0,8,7,9,4],[9,23,6,2,0,0,9]]" do
		matrix = Matrix[[1,6,1,2,0,0,0],[0,7,0,6,3,8,4],[1,1,3,1,0,0,0],[0,0,9,0,4,9,5],
				[5,1,1,1,0,0,0],[6,0,0,8,7,9,4],[9,23,6,2,0,0,9]]
		expect(matrix.solveable?).to eq(false)
	end

	it "returns false when run on Matrix[[1,6,1,2],[0,7,0,6],[1,1,3,1],[0,0,9,0],[5,1,1,1],[6,0,0,8],[9,23,6,2]]" do
		matrix = Matrix[[1,6,1,2],[0,7,0,6],[1,1,3,1],[0,0,9,0],[5,1,1,1],[6,0,0,8],[9,23,6,2]]
		expect(matrix.solveable?).to eq(false)
	end	

# next test some matrices that will allow for multiple assignments in rows, then in columns

end
