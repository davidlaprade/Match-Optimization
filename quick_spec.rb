$LOAD_PATH << '.'
require 'testing'

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# METHODS THAT DO NOT DEPEND ON OTHER METHODS I HAVE WRITTEN SHOULD BE TESTED FIRST, SO THAT IF THERE IS A PROBLEM WITH THEM, THE PROBLEM
# IS DISPLAYED FIRST WHEN I RUN RSPEC
# ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# temporarily breaking the above rule so that I focus on this issue first; it does not depend on problems with other methods; rather, the
# problem has to do with how I'm trying to speed up the algorithm by transposing non-square arrays

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


	it "returns failure code when run on [[0,3,0],[0,5,0],[0,1,0]]" do
		matrix = [[0,3,0],[0,5,0],[0,1,0]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	it "returns failure code when run on [[1,0,1,0,5,6],[6,7,1,0,1,0],[1,0,3,9,1,0],[2,6,1,0,1,8]]" do
		matrix = [[1,0,1,0,5,6],[6,7,1,0,1,0],[1,0,3,9,1,0],[2,6,1,0,1,8]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	# this test is largely uninteresting
	it "returns failure code when run on [[1,7,1,3,5,6,9],[6,7,1,5,1,5,23],[1,3,3,9,1,9,6],[2,6,1,9,1,8,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = [[1,0,1,7,5,6,9],[6,7,1,0,1,0,23],[1,7,3,9,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]
		expect(matrix.combinatorial_test).to eq("fail")
	end

	it "returns failure code when run on [[1,6,1,2],[0,7,0,6],[1,1,3,1],[0,0,9,0],[5,1,1,1],[6,0,0,8],[9,23,6,2]]" do
		matrix = [[1,6,1,2],[0,7,0,6],[1,1,3,1],[0,0,9,0],[5,1,1,1],[6,0,0,8],[9,23,6,2]]
		expect(matrix.combinatorial_test).to eq("fail")
	end	

end