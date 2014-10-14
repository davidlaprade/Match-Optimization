$LOAD_PATH << '.'
require 'testing'

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# METHODS THAT DO NOT DEPEND ON OTHER METHODS I HAVE WRITTEN SHOULD BE TESTED FIRST, SO THAT IF THERE IS A PROBLEM WITH THEM, THE PROBLEM
# IS DISPLAYED FIRST WHEN I RUN RSPEC
# ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

describe Array, ".combinatorial_test" do
	# call on Array object; returns "fail" if there are fewer column assignments possible than would be permitted in a complete
	# assignment; returns "pass" otherwise; checks to see if the minimum allowable row assignments is greater than the maximum number of column assignments
	# if min_allowable_row_assmts_permitted is greater than max_column_assmts_possible for any submatrix, the parent matrix is unsolveable
	# run this test last, since calculating every_combination_of_its_members takes a long time for big arrays
		# how this works:
			# 	populate array of every combination of the matrix_array rows
			# 	for each member of the combination array:
			# 		find min row assignments permitted
			# 		find max column assignments possible
			# 		check if min_row_assmts_permitted > max_col_assmts_poss
			# 			return false
		# this seems to catch all of the cases where min allowable column assignments > max num of possible row assignments
		# so I didn't write a corresponding test for that

	it "returns failure code when 2 rows have zeros in only 1 column" do
		matrix = [  [0,3,2],
					[0,5,4],
					[8,1,9]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	it "returns failure code when 3 rows have zeros in only 2 columns" do
		matrix = [  [0,3,0],
					[0,5,0],
					[0,1,0]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	it "returns pass code when 3 rows have zeros in 3 columns" do
		matrix = [  [0,3,8],
					[1,0,0],
					[0,1,0]]
		expect(matrix.combinatorial_test).to eq("pass")
	end

	it "returns failure code when 5 rows have zeros in only 3 columns" do
		matrix = [  [1,0,1,0,5,6],
					[6,7,1,0,1,0],
					[1,0,3,9,1,0],
					[2,6,1,0,1,8]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	it "returns failure code when 5 rows have zeros in only 3 columns and there are extra rows with assignable zeros in other columns" do
		matrix = [  [1,0,1,0,5,6],
					[6,7,1,0,1,0],
					[1,0,3,9,1,0],
					[2,6,1,0,1,8],
					[2,6,1,0,0,8],
					[2,6,0,0,1,8]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	it "returns failure code when 5 rows have zeros in only 3 columns, there are extra rows, and problematic rows aren't grouped together" do
		matrix = [  [1,0,1,0,5,6],
					[2,6,1,7,0,8],
					[6,7,1,0,1,0],
					[0,1,0,1,1,1],
					[1,0,3,9,1,0],
					[2,6,1,0,1,8]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	it "returns failure code when the array is large and zeros are spread out" do
		matrix = [[0, 8, 2, 1, 1, 1, 6, 5, 9, 1, 7, 1, 6, 9, 1],
				 [5, 2, 9, 9, 2, 8, 6, 0, 2, 5, 7, 1, 3, 4, 3],
				 [8, 7, 8, 7, 3, 5, 3, 7, 2, 8, 5, 5, 6, 0, 7],
				 [3, 9, 6, 1, 5, 5, 8, 0, 5, 6, 2, 5, 9, 9, 3],
				 [0, 3, 6, 4, 3, 8, 4, 8, 4, 8, 7, 2, 6, 6, 4],
				 [9, 1, 1, 7, 2, 6, 6, 2, 4, 4, 3, 3, 1, 0, 2]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	 it "returns failure code when one row contains only zeros, all others have zero in one col" do
		matrix = [  [0,0,0,0,0,0],
					[0,7,1,4,1,4],
					[0,4,3,9,1,4],
					[0,6,1,4,1,8],
					[0,6,1,4,4,8],
					[0,6,4,4,1,8]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	 it "returns failure code when one row contains only zeros, all others have zero in one col" do
		matrix = [  [3,3,3,3,3,3],
					[3,0,0,0,0,0],
					[3,0,3,9,1,4],
					[3,0,1,4,1,8],
					[3,0,1,4,4,8],
					[3,0,4,4,1,8]]
		expect(matrix.combinatorial_test).to eq("fail")
	end


end