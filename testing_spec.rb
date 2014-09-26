# to use: navigate to the directory of this file in the terminal, then type "rspec <file name here>"

$LOAD_PATH << '.'
require 'testing'

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# METHODS THAT DO NOT DEPEND ON OTHER METHODS I HAVE WRITTEN SHOULD BE TESTED FIRST, SO THAT IF THERE IS A PROBLEM WITH THEM, THE PROBLEM
# IS DISPLAYED FIRST WHEN I RUN RSPEC
# ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# temporarily breaking the above rule so that I focus on this issue first; it does not depend on problems with other methods; rather, the
# problem has to do with how I'm trying to speed up the algorithm by transposing non-square arrays
describe "make_matrix_solveable" do

	it "yeilds a solveable array when called on an uneven array" do
		matrix = [[6, 2, 2, 6, 4, 7, 3],[2, 6, 6, 6, 9, 2, 5],[6, 2, 4, 1, 2, 3, 1],[1, 5, 6, 5, 8, 2, 5],
			[2, 3, 1, 8, 9, 1, 5],[1, 9, 4, 8, 7, 7, 2],[5, 6, 9, 8, 9, 6, 3],[7, 1, 6, 7, 6, 6, 1],
			[5, 4, 2, 8, 8, 2, 2],[3, 2, 5, 9, 5, 6, 3],[7, 3, 1, 8, 9, 5, 6],[9, 7, 1, 1, 4, 9, 8],[9, 5, 3, 8, 5, 1, 6]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	it "yeilds a solveable array when called on an uneven array" do
		matrix = [[7, 8, 7, 4, 6, 9],[4, 6, 4, 5, 6, 1],[3, 8, 2, 8, 7, 2],[3, 4, 1, 3, 7, 9],[3, 6, 0, 7, 3, 0],[0, 6, 8, 5, 8, 1],
			[8, 9, 4, 9, 2, 3],[9, 7, 7, 2, 2, 5],[6, 3, 0, 9, 9, 3],[5, 2, 8, 7, 2, 1],[8, 7, 3, 4, 7, 8],[1, 1, 3, 0, 5, 1],
			[8, 2, 5, 9, 2, 3],[3, 3, 4, 2, 6, 0],[9, 9, 9, 5, 5, 3]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	it "yeilds a solveable array when called on an uneven array" do
		matrix = [[5, 8, 6, 7, 7, 0, 5],[0, 8, 8, 0, 5, 4, 2],[7, 8, 9, 0, 4, 0, 1],[9, 7, 8, 1, 6, 5, 2],[7, 0, 1, 1, 3, 0, 3],
			[8, 7, 9, 3, 7, 3, 3],[4, 8, 4, 5, 5, 0, 2],[3, 5, 7, 7, 0, 9, 0],[4, 3, 4, 9, 8, 3, 7],[1, 8, 7, 9, 1, 1, 9],
			[8, 8, 5, 2, 3, 6, 9],[0, 0, 2, 8, 7, 0, 6],[4, 9, 3, 3, 6, 0, 0]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	it "yeilds a solveable array when called on an uneven array" do
		matrix = [[4, 6, 2, 1],[6, 7, 1, 6],[5, 2, 2, 8],[1, 0, 5, 2],[5, 4, 1, 8],[4, 2, 7, 6],[5, 6, 8, 0],[2, 4, 7, 8],[8, 4, 8, 7],
			[7, 6, 3, 6],[1, 9, 1, 7]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	it "yeilds a solveable array when called on an uneven array" do
		matrix = [[7, 3, 6, 6, 5],[3, 6, 0, 4, 5],[1, 5, 2, 6, 5],[6, 5, 4, 9, 3],[7, 5, 0, 2, 3],[3, 3, 3, 2, 3],[6, 3, 8, 1, 7],
			[2, 8, 7, 8, 4],[0, 3, 9, 8, 4],[8, 1, 6, 3, 6],[8, 9, 5, 7, 7],[4, 8, 8, 7, 9],[5, 2, 2, 9, 9],[4, 0, 3, 1, 4]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	it "should not throw a RuntimeError" do
		matrix = [[2, 0, 7, 8, 3],[1, 2, 1, 0, 0],[8, 3, 4, 7, 9],[2, 1, 0, 8, 2],[7, 2, 1, 1, 2],
			[5, 5, 8, 9, 9],[3, 7, 1, 8, 9],[1, 8, 1, 4, 3],[3, 9, 5, 7, 7],[9, 5, 9, 3, 2],[0, 1, 7, 3, 5]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	it "should not throw a RuntimeError" do
		matrix = [[7, 1, 5, 9, 4, 5, 6],[9, 1, 7, 9, 5, 7, 1],[1, 6, 0, 3, 0, 9, 5],[5, 1, 1, 5, 5, 6, 6],[5, 4, 9, 2, 5, 1, 6],[9, 1, 9, 0, 0, 0, 5],
	[6, 3, 0, 4, 8, 5, 0],[9, 5, 0, 2, 1, 4, 9],[7, 2, 0, 4, 1, 8, 3],[4, 3, 5, 4, 3, 6, 0],[8, 9, 4, 4, 0, 3, 7],[3, 7, 0, 6, 9, 8, 2],
	[3, 7, 3, 5, 6, 8, 7],[3, 6, 9, 9, 1, 3, 1],[7, 1, 3, 7, 6, 7, 2],[4, 3, 1, 1, 8, 9, 5]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	it "should not throw a RuntimeError" do
		matrix = [[4, 3, 7, 9, 4, 6],[6, 0, 2, 6, 1, 5],[1, 8, 6, 9, 5, 7],[6, 2, 5, 6, 2, 4],[9, 0, 6, 3, 0, 7],[2, 4, 9, 7, 3, 5],
	[8, 1, 0, 5, 8, 5],[8, 9, 4, 6, 4, 6],[9, 3, 4, 1, 7, 0],[7, 1, 9, 9, 9, 6],[4, 8, 1, 1, 9, 0],[0, 0, 1, 2, 0, 7]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	it "yeilds a solveable array when called on an array bordered by low values" do
		matrix = [[1,1,1,1,1,1],[1,4,5,6,3,1],[1,9,3,8,5,1],[1,5,8,7,3,1],[1,3,9,5,7,1],[1,1,1,1,1,1]]
		expect(make_matrix_solveable(matrix).solveable?).to eq("true")
	end

	# 40.times do
	# 	it "yeilds a solveable array when called on an array with more rows than columns" do
	# 		cols = rand(7)+1
	# 		rows = (2*cols)+rand(4)
	# 		matrix = Array.new(rows) {Array.new(cols) {rand(10)}}
	# 		original = matrix.dup
	# 		solveable = make_matrix_solveable(matrix).solveable?
	# 		original.print_readable if solveable != "true"
	# 		expect(solveable).to eq("true")
	# 	end	
	# end

	# 40.times do
	# 	it "yeilds a solveable array when called on an array of random size filled with random numbers" do
	# 		rows = rand(13)+2
	# 		cols = rand(13)+2
	# 		matrix = Array.new(rows) {Array.new(cols) {rand(10)}}
	# 		original = matrix.dup
	# 		solveable = make_matrix_solveable(matrix).solveable?
	# 		original.print_readable if solveable != "true"
	# 		expect(solveable).to eq("true")
	# 	end	
	# end

end


describe Array, ".zero_each_row" do
	# called on Array object; subtracts the lowest value in each row from each member of that row, repeats process until each
	# row contains at least enough zeros to support a minimum_row_assignment; then it returns the corrected array

	it "changes the attributes of the array it's called on" do
		array = [[2,7,5]]
		array.zero_each_row
		expect(array).to eq([[0,0,0]])
	end

	it "works when each row needs one zero, will get it by just getting rid of first min" do
		array = [[2,7,5],[9,1,2],[4,4,3]]
		expect(array.zero_each_row).to eq([[0,5,3],[8,0,1],[1,1,0]])
	end

	it "works when each row needs two zeros, will happen just by getting rid of first min" do
		array = [[2,7,5,2],[9,1,1,7]]
		array.zero_each_row
		expect(array).to eq([[0,5,3,0],[8,0,0,6]])
	end

	it "works when each row needs one zero, will happen just by getting rid of first min, one row ends up with two zeros" do
		array = [[2,7,5],[9,1,1],[4,4,3]]
		expect(array.zero_each_row).to eq([[0,5,3],[8,0,0],[1,1,0]])
	end


	it "works when each row needs two zeros, will only happen by getting rid of second min" do
		array = [[1,7,5,2],[9,1,2,7]]
		array.zero_each_row
		expect(array).to eq([[0,5,3,0],[7,0,0,5]])
	end

	it "works when each row needs two zeros, one row needs to be normalized twice, other row once" do
		array = [[1,7,5,2],[9,1,1,7]]
		array.zero_each_row
		expect(array).to eq([[0,5,3,0],[8,0,0,6]])
	end

	it "works when each row needs three zeros, one needs to be normalized three times, another two, last one" do
		array = [[1,2,3,3,3,9,8,8,6],[5,4,6,8,8,2,9,2,7],[5,5,9,10,12,6,7,9,5]]
		array.zero_each_row
		expect(array).to eq([[0,0,0,0,0,6,5,5,3],[1,0,2,4,4,0,5,0,3],[0,0,4,5,7,1,2,4,0]])
	end

	it "works when one row doesn't have to be changed, one does" do
		array = [[0,4,5,0],[2,3,3,2]]
		array.zero_each_row
		expect(array).to eq([[0,4,5,0],[0,1,1,0]])
	end

	it "it changes nothing when no zeros need to be added" do
		array = [[0,7,5],[0,1,2],[0,4,3]]
		array.zero_each_row
		expect(array).to eq([[0,7,5],[0,1,2],[0,4,3]])
	end

	it "it changes nothing when no zeros need to be added" do
		array = [[0,0,0]]
		array.zero_each_row
		expect(array).to eq([[0,0,0]])
	end

end

describe Array, ".zero_each_column" do

	# called on Array object; subtracts the lowest value in each column from each member of that column, repeats process until each
	# column contains at least enough zeros to support a minimum_column_assignment; then it returns the corrected array

	it "changes the attributes of the array it's called on" do
		array = [[2,7,5]].transpose
		array.zero_each_column
		expect(array).to eq([[0,0,0]].transpose)
	end

	it "works when each column needs one zero, will get it by just getting rid of first min" do
		array = [[2,7,5],[9,1,2],[4,4,3]].transpose
		expect(array.zero_each_column).to eq([[0,5,3],[8,0,1],[1,1,0]].transpose)
	end

	it "works when each column needs two zeros, will happen just by getting rid of first min" do
		array = [[2,7,5,2],[9,1,1,7]].transpose
		array.zero_each_column
		expect(array).to eq([[0,5,3,0],[8,0,0,6]].transpose)
	end

	it "works when each column needs one zero, will happen just by getting rid of first min, one column ends up with two zeros" do
		array = [[2,7,5],[9,1,1],[4,4,3]].transpose
		expect(array.zero_each_column).to eq([[0,5,3],[8,0,0],[1,1,0]].transpose)
	end


	it "works when each column needs two zeros, will only happen by getting rid of second min" do
		array = [[1,7,5,2],[9,1,2,7]].transpose
		array.zero_each_column
		expect(array).to eq([[0,5,3,0],[7,0,0,5]].transpose)
	end

	it "works when each column needs two zeros, one column needs to be normalized twice, other column once" do
		array = [[1,7,5,2],[9,1,1,7]].transpose
		array.zero_each_column
		expect(array).to eq([[0,5,3,0],[8,0,0,6]].transpose)
	end

	it "works when each column needs three zeros, one needs to be normalized three times, another two, last one" do
		array = [[1,2,3,3,3,9,8,8,6],[5,4,6,8,8,2,9,2,7],[5,5,9,10,12,6,7,9,5]].transpose
		array.zero_each_column
		expect(array).to eq([[0,0,0,0,0,6,5,5,3],[1,0,2,4,4,0,5,0,3],[0,0,4,5,7,1,2,4,0]].transpose)
	end

	it "works when one column doesn't have to be changed, one does" do
		array = [[0,4,5,0],[2,3,3,2]].transpose
		array.zero_each_column
		expect(array).to eq([[0,4,5,0],[0,1,1,0]].transpose)
	end

	it "it changes nothing when no zeros need to be added" do
		array = [[0,7,5],[0,1,2],[0,4,3]].transpose
		array.zero_each_column
		expect(array).to eq([[0,7,5],[0,1,2],[0,4,3]].transpose)
	end

	it "it changes nothing when no zeros need to be added" do
		array = [[0,0,0]].transpose
		array.zero_each_column
		expect(array).to eq([[0,0,0]].transpose)
	end


end

describe Array, "permissible assignment values, min_column_assignment, max_col_assignment, etc" do

	# every object on the x axis gets mapped to at least one object on the y
	# axis, and vice versa; perhaps sometimes the most optimal match is one in which an individual doesn't get matched; if so, 
	# then my algorithm won't catch it; I have to start somewhere

	# Formerly, I had just set min_row and min_col_assignment to 1 automatically. But it's not clear why I should have. If what
	# these values are supposed to be are the minimum/maximum number of assignments in an optimal match for the relevant array, 
	# then the minimums will seldom if ever be 1. In a square array, the min row/col assignments should be equal to the max row/col
	# assignments

	it "yeilds the right min/max_col_assignment when there is only one row" do
		array = [["!","!","!","!","!"]]
		expect(array.min_col_assignment).to eq(1)
		expect(array.max_col_assignment).to eq(1)
	end

	it "yeilds the right values when there is only one row" do
		array = [[2,4,4,3,5,21,4,5]]
		expect(array.min_row_assignment).to eq(8)
		expect(array.max_row_assignment).to eq(8)
		expect(array.min_col_assignment).to eq(1)
		expect(array.max_col_assignment).to eq(1)
	end

	it "yeilds the right values when there is only one column" do
		array = [[2],[4],[4],[3],[5],[21],[4],[5]]
		expect(array.min_row_assignment).to eq(1)
		expect(array.max_row_assignment).to eq(1)
		expect(array.min_col_assignment).to eq(8)
		expect(array.max_col_assignment).to eq(8)
	end

	it "yeilds the right values when the array is square" do
		array = [[4, 7, 9, 8, 1, 4, 1, 7, 8], [9, 5, 2, 3, 4, 5, 5, 2, 2], [9, 6, 6, 1, 5, 4, 4, 2, 4], [5, 6, 9, 2, 4, 7, 5, 8, 6], 
			[3, 1, 7, 5, 3, 3, 9, 3, 9], [6, 5, 3, 6, 3, 1, 6, 4, 5], [7, 7, 2, 4, 1, 7, 5, 8, 8], [2, 9, 3, 8, 3, 6, 4, 3, 7], 
			[2, 2, 6, 8, 4, 2, 6, 6, 3]]
		expect(array.min_row_assignment).to eq(1)
		expect(array.max_row_assignment).to eq(1)
		expect(array.min_col_assignment).to eq(1)
		expect(array.max_col_assignment).to eq(1)
	end


	it "yeilds the right values when there are more rows than columns" do
		array = [[4, 7, 9, 8, 1, 4, 1, 7, 8], [9, 5, 2, 3, 4, 5, 5, 2, 2], [9, 6, 6, 1, 5, 4, 4, 2, 4], [5, 6, 9, 2, 4, 7, 5, 8, 6], 
			[3, 1, 7, 5, 3, 3, 9, 3, 9], [6, 5, 3, 6, 3, 1, 6, 4, 5], [7, 7, 2, 4, 1, 7, 5, 8, 8], [2, 9, 3, 8, 3, 6, 4, 3, 7], 
			[2, 2, 6, 8, 4, 2, 6, 6, 3],[2,4,5,7,2,4,6,7,8]]
		expect(array.min_row_assignment).to eq(1)
		expect(array.max_row_assignment).to eq(1)
		expect(array.min_col_assignment).to eq(1)
		expect(array.max_col_assignment).to eq(2)
	end

	it "yeilds the right values when there are more columns than rows" do
		array = [[7, 3, 3, 1, 4, 6, 1, 7, 2, 7, 2], [6, 4, 7, 8, 5, 5, 7, 2, 9, 3, 2], [1, 9, 2, 1, 7, 5, 5, 7, 6, 9, 9], 
			[3, 2, 1, 2, 2, 3, 5, 6, 3, 9, 5], [9, 2, 8, 2, 1, 7, 8, 8, 2, 3, 3], [8, 4, 3, 6, 1, 8, 7, 2, 9, 5, 9], 
			[2, 7, 2, 7, 1, 5, 7, 4, 9, 8, 8], [4, 3, 6, 1, 9, 1, 6, 3, 3, 9, 4], [3, 4, 2, 6, 9, 6, 5, 2, 2, 4, 4]]
		expect(array.min_row_assignment).to eq(1)
		expect(array.max_row_assignment).to eq(2)
		expect(array.min_col_assignment).to eq(1)
		expect(array.max_col_assignment).to eq(1)
	end		

end


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

describe Array, ".solution?" do
	# call on mask Array object; returns true if the mask represents a complete, acceptable assignment, false otherwise

	it "accepts solution with one row" do
		array = [["!","!","!","!","!"]]
		expect(array.solution?).to eq(true)
	end

	it "treats 0s and Xs the same" do
		solved = [["X",9],[2,"X"]]
		unsolved = [[0,9],[2,0]]
		expect(solved.solution?).to eq(unsolved.solution?)
	end

	it "rejects non-solution with one row" do
		array = [["!","!","!",9,"!"]]
		expect(array.solution?).to eq(false)
	end

	it "distinguishes between zeros and assignments" do
		solved = [["!",9],[2,"!"]]
		unsolved = [[0,9],[2,0]]
		expect(solved.solution?).to_not eq(unsolved.solution?)
	end

	it "accepts solution with one column" do
		array = [["!"],["!"],["!"],["!"],["!"],["!"],["!"]]
		expect(array.solution?).to eq(true)
	end

	it "rejects non-solution with one column" do
		array = [["!"],[10],["!"],["!"],[2],["!"],["!"]]
		expect(array.solution?).to eq(false)
	end

	it "accepts a solved, square array" do
		array = [[6, 0, 8, "!", 3, 9], [5, "!", 8, 7, 3, 6], [7, 7, 1, 1, "!", 9], [3, 1, 2, 4, 0, "!"], ["!", 9, 4, 6, 1, 2],
				[6, 9, "!", 2, 3, 5]]
		expect(array.solution?).to eq(true)
	end

	it "accepts a solved array with more columns than rows, some zeros x'ed out" do
		array = [["!",6,"X","X","X",1,1,"!","!",4],[6,"!",3,1,"!",2,1,3,6,"!"],[4, 5,2,3,2,"!","!",1,5,2],[6, 1,"!","!",1,3,"X",2,4,2]]
		expect(array.solution?).to eq(true)
	end

	it "accepts a solved array with many more rows than columns" do
		array = [[7,4,7,"!",5,1,6,5,2,5],["!",7,6,1,4,0,0,2,3,8],[5,2,4,1,4,5,2,8,5,"!"],[3,7,6,1,0,1,7,"!",7,6],[3,5,7,4,7,6,1,2,"!",5],
		[1,7,1,6,4,4,3,7,6,"!"],[5,5,3,7,3,8,"!",8,1,4],[7,"!",4,8,5,5,2,7,7,7],[4,4,5,0,"!",7,2,6,0,0],[8,"!",7,2,1,8,4,7,5,1],
		[6,0,5,3,6,3,4,5,"!",0],[2,8,4,"!",1,5,0,8,4,6],[2,1,3,"!",6,8,1,2,2,6],[1,1,4,4,5,1,"!",1,3,4],[7,4,"!",7,4,2,0,4,6,7],
		[2,4,7,6,1,"!",6,6,2,7],[8,5,4,7,5,"!",8,0,4,8],[2,7,3,"!",1,3,7,4,6,6],[2,7,4,4,3,6,1,6,3,"!"],[8,5,3,2,"!",0,8,3,5,1],
		[2,3,"!",3,0,0,4,8,1,3],[6,2,3,0,2,3,1,1,"!",3],["!",6,6,3,4,3,4,2,6,6],[6,"!",2,3,0,0,0,4,2,2],[4,4,4,5,3,3,"!",7,6,6],
		[2,4,7,4,8,7,1,5,"!",2],[4,4,6,1,6,"!",3,3,4,4],[4,6,5,4,6,1,"!",1,1,4],[1,3,4,5,"!",3,2,5,2,2],[2,0,4,2,2,5,3,"!",3,0],
		["!",4,3,2,4,5,4,1,6,6],[7,6,7,0,2,7,4,7,4,"!"],[7,2,"!",2,2,5,6,6,4,1],[0,6,"!",8,7,3,1,7,2,7],["!",0,4,4,5,3,3,6,3,5],
		[7,1,2,8,1,"!",6,5,1,3],[0,7,7,8,0,7,8,"!",4,3],[5,0,3,4,2,5,4,"!",0,7],[2,"!",5,1,2,0,2,3,1,2],[5,2,7,2,"!",6,4,2,2,1]]
		expect(array.solution?).to eq(true)
	end

	it "returns false for an array of all assignments" do
		array = [["!","!"],["!","!"]]
		expect(array.solution?).to eq(false)
	end

	it "returns false when there are no assignments" do
		array = [[5,5],[5,5]]
		expect(array.solution?).to eq(false)
	end

	it "returns false when there are too many col assignments" do
		array = [["!",5],[6,"!"],[1,"!"],[7,"!"]]
		expect(array.solution?).to eq(false)
	end

	it "returns false when there are too few col assignments" do
		array = [["!",5],[6,7],[1,"!"],[7,"!"]]
		expect(array.solution?).to eq(false)
	end

	it "returns false when there are too few row assignments" do
		array = [[2,"!",4,"!",6,7],["!",3,"!",5,6,"!"]]
		expect(array.solution?).to eq(false)
	end

	it "returns false when there are too many row assignments" do
		array = [[2,"!",4,"!",6,7],["!",3,"!",5,"!","!"]]
		expect(array.solution?).to eq(false)
	end

	# it "accepts solutions when there are multiple assignments per row" do

	# end

	# it "rejects solutions when there are multiple assignments per row" do

	# end

	# it "accepts solutions when there are multiple assignments per column" do

	# end

	# it "rejects solutions when there are multiple assignments per column" do

	# end

end

describe Array, ".reduce_problem" do
	# call on mask Array object, does NOT change the mask, returns minimal array that needs to be assigned in order to finish
	# assigning to the mask object the method was called on

	it "does not change the array it is called on" do
		mask = [[9,0,4,0],[1,3,"!",3],[2,0,0,0],["!",4,5,7]]
		original = mask.dup
		mask.reduce_problem
		expect(mask).to eq(original)
	end

	it "has no problems with Xs" do
		mask = [[6, 1, 8, "!", 2],[3, 2, 2, "!", 5],["X", 3, 1, 3, "!"],[1, 7, 4, 2, "!"],[8, "!", 2, 7, 7],[4, 0, 0, 2, 4],
			[1, 3, 2, "!", 1],[8, 0, 6, 0, 2],[4, 4, "!", 6, 4],[5, "X", "X", 1, "!"],[5, 4, 0, 0, 5],[5, 2, 3, 1, "!"],
			[2, 0, 2, 0, 4],[4, 0, 2, 0, 2],["X", 7, 7, "!", 4],["X", 2, 1, 5, "!"],["!", 1, 3, 2, 3],["!", 2, 7, 5, 4],
			[1, 0, 3, 0, 3],["!", 1, 1, 4, 6],["!", 4, 6, 2, 3],["X", 6, "!", 1, 1],[6, 0, 0, 0, 5],["!", 3, 4, 6, 1],
			[4, 1, "!", 3, 4]]
		expect(mask.reduce_problem).to eq([["X", [1,4], [2,2], [3,1]],[[5,1], 0, 0, 2],[[7,1], 0, 6, 0],[[10,1], 4, 0, 0],
			[[12,1], 0, 2, 0],[[13,1], 0, 2, 0],[[18,1], 0, 3, 0],[[22,1], 0, 0, 0]])
	end

	it "returns [X] when called on an array that is solved" do
		mask = [["!",9,4],[1,"!",3],[7,3,"!"]]
		expect(mask.reduce_problem).to eq([["X"]])
	end

	# a choice has to be made here: should the "reduce_problem" method be the kind of thing you could call on an unsolsveable array?
	# Or the kind of thing you should only call on a solveable array? I certainly intend to only use it on solveable arrays. Either
	# way, the choice will effect how the code is written. I have decided on the latter option, and this test respects that fact.
	# But a a similar test could be written which the current code would fail--one which was called on an array that lacked zeros in 
	# rows and certain columns.
	it "returns entire array unchanged when there are no assignments" do
		mask = [[9,0,4,0],[0,3,6,3],[2,0,7,0],[6,4,0,7]]
		expect(mask.reduce_problem).to eq([["X",[0,1],[1,1],[2,1],[3,1]],[[0,1],9,0,4,0],[[1,1],0,3,6,3],[[2,1],2,0,7,0],[[3,1],6,4,0,7]])
	end

	it "isolates submatrix to solve when called on square mask array" do
		mask = [[9,0,4,0],[1,3,"!",3],[2,0,0,0],["!",4,5,7]]
		expect(mask.reduce_problem).to eq([["X",[1,1],[3,1]],[[0,1],0,0],[[2,1],0,0]])
	end

	it "isolates submatrix to solve when called on array with more columns than rows" do
		mask = [[3, 3, 0, 3, 7, 2, 2, 6, 7, 2, "!", 4, 5, 4, 5, 1, 3, 5, 3, 0, "!", "!", 0, 6, 1],
			    [7, 2, 7, 4, 6, "!", 5, 0, 6, 5, 2, "!", 5, "!", 6, 3, 2, 0, 3, 0, 1, 3, 5, 0, 0],
			    [2, "!", 6, "!", 3, 8, 5, 4, 5, "X", 1, 1, "!", 1, 7, "X", "!", 6, "!", 1, "X", 5, 3, 6, 4],
			    ["!", 3, 7, 1, 1, 6, 7, 0, "!", 0, 4, 2, 7, 3, 2, "!", 4, 0, 3, 3, 6, 1, 0, 1, 5],
			    [2, 7, 0, 7, "!", 1, "!", 1, 5, 0, 3, 5, 6, 2, "!", 4, 5, 1, 7, 3, 6, 4, 7, 0, 0]]
		expect(mask.reduce_problem).to eq([["X",[2,1],[7,1],[9,1],[17,1],[19,1],[22,1],[23,1],[24,1]],[[0,2],0, 6, 2, 5, 0, 0, 6, 1],[[1,2],7, 0, 5, 0, 0, 5, 0, 0],
			[[3,2],7, 0, 0, 0, 3, 0, 1, 5],[[4,2],0, 1, 0, 1, 3, 7, 0, 0]])
	end

	it "isolates submatrix to solve when called on array with more rows than columns" do
		mask = [[6, 1, 8, "!", 2],[3, 2, 2, "!", 5],["X", 3, 1, 3, "!"],[1, 7, 4, 2, "!"],[8, "!", 2, 7, 7],[4, 0, 0, 2, 4],
			[1, 3, 2, "!", 1],[8, 0, 6, 0, 2],[4, 4, "!", 6, 4],[5, "X", "X", 1, "!"],[5, 4, 0, 0, 5],[5, 2, 3, 1, "!"],
			[2, 0, 2, 0, 4],[4, 0, 2, 0, 2],["X", 7, 7, "!", 4],["X", 2, 1, 5, "!"],["!", 1, 3, 2, 3],["!", 2, 7, 5, 4],
			[1, 0, 3, 0, 3],["!", 1, 1, 4, 6],["!", 4, 6, 2, 3],["X", 6, "!", 1, 1],[6, 0, 0, 0, 5],["!", 3, 4, 6, 1],
			[4, 1, "!", 3, 4]]
		expect(mask.reduce_problem).to eq([["X", [1,4], [2,2], [3,1]],[[5,1], 0, 0, 2],[[7,1], 0, 6, 0],[[10,1], 4, 0, 0],
			[[12,1], 0, 2, 0],[[13,1], 0, 2, 0],[[18,1], 0, 3, 0],[[22,1], 0, 0, 0]])
	end


	# here the example array is 5x27, meaning that two rows will need 6 assignments; so, what can happen is that a row might
	# have the minimum requirement, but still fail to have the max allowable, so that row will get left in the reduce problem
	# array even if it contains no zeros
	it "removes rows that contain no zeros even when dimensions are uneven" do
		mask = [["X", 4, 3, 3, 7, 6, 6, "!", 2, "!", 1, 1, "!", 4, "!", 1, 6, 5, 7, 3, 2, 1, 6, 1, 3, 5, "!"],
			    ["!", "!", 4, 3, 4, 5, 6, 6, "!", 1, 1, 2, 1, 3, 2, "!", 3, 2, 4, 7, "!", 2, 4, 2, 1, 2, 1],
			    [5, "X", 2, "!", 2, "!", 6, 2, 3, 2, 0, 3, "X", 2, "X", 3, 7, "!", "!", 3, 1, 0, "!", 4, 8, 6, 1],
			    [5, "X", 3, 3, "!", 6, "!", 2, 1, 4, 1, 0, 6, 1, 4, "X", 5, 4, 6, "!", 2, 0, 6, 2, "!", 2, 4],
			    [1, 3, "!", 2, 2, 4, 1, 4, 5, 3, 0, 0, 7, "!", 5, 6, "!", 4, 1, 8, 2, 2, 5, "!", 4, "!", 2]]
		expect(mask.reduce_problem).to eq([["X", [10,1], [11,1], [21,1]],[[2,0], 0, 3, 0],[[3,1], 1, 0, 0],[[4,0], 0, 0, 2]])
	end

	# same problem as described above, 5x27 array
	it "removes rows that contain no zeros even when dimensions are uneven" do
		mask = [[5, 5, "X", 3, 4, 2, 2, 6, 3, 1, 7, 4, 0, 5, 3, 6, 0, 5, "!", 0, 0, 2, 2, "!", 3, 0, "!"],
			    [6, 2, "!", 3, "!", 1, "!", 4, 6, "!", 6, 2, 4, 7, 2, 4, 1, 3, 2, 2, 3, 1, "!", 1, 5, 2, 4],
			    [4, 3, 6, 0, 1, 5, 7, 4, "!", 5, "!", "!", 8, 6, 6, 7, 0, 4, 3, 3, 8, 4, 2, 3, "!", 5, 1],
			    [4, "!", "X", 0, "X", "!", 5, "!", 6, "X", 8, 3, 0, 5, 3, 4, 0, "!", 2, 0, 0, 4, "X", 1, 1, 0, 3],
			    ["!", 6, 2, 5, 6, 2, 7, 1, 1, "X", 7, 3, 7, "!", "!", "!", 7, 1, 2, 1, 3, "!", "X", 4, 1, 2, 6]]
			expect(mask.reduce_problem).to eq([["X",[3,1], [12,1], [16,1], [19,1], [20,1], [25,1]],
											[[0,2], 3, 0, 0, 0, 0, 0],
										    [[2,1], 0, 8, 0, 3, 8, 5],
										    [[3,1], 0, 0, 0, 0, 0, 0]])
	end

	# analogous problem to the ones above, 13x7 array
	it "removes columns that contain no zeros even when dimensions are uneven" do
		mask = [[4, 1, 6, "!", 4, 1, 4],[0, 4, 8, 0, 8, 1, 7],[0, "X", 8, 3, 1, 0, 7],[6, 8, 3, 4, 3, 3, "!"],
			[3, 1, 2, 7, "!", 2, 3],[4, "!", 4, 8, 4, 5, 6],[0, 6, "X", 0, 2, 4, 7],[1, "X", 2, 7, 2, "!", 1],
			[7, 6, "!", 6, 2, 4, 5],[7, 6, 7, 7, "!", 4, 4],[1, "!", "X", 1, 3, 5, 4],[5, 8, "!", 4, 7, 6, 1],
			["!", 6, 2, 5, 5, 2, 2]]
		expect(mask.reduce_problem).to eq([["X", [0,0], [3,0], [5,0]],[[1,1], 0, 0, 1],[[2,1], 0, 3, 0],[[6,1], 0, 0, 4]])
	end



	# analogous problem to the ones above, 29x7 array
	it "removes columns that contain no zeros even when dimensions are uneven" do
		mask = [["X", 6, "!", "X", 1, 3, 6],[3, 5, 7, 2, 4, "!", 6],[6, 3, 4, 5, 1, "!", 3],["!", 1, 2, 6, 1, 1, 6],
			[3, 6, 5, 4, 1, 6, "!"],[3, 0, 3, 0, 1, 5, 4],[7, "X", "!", "X", 4, 6, "X"],[7, 5, 4, 7, 7, "!", 3],
			[7, 1, 6, "!", 4, 8, 8],[6, "!", 5, 7, 6, 4, 6],[2, "X", "!", "X", 1, "X", 2],["!", "X", 3, 3, "X", 6, 6],
			[1, 1, 1, 3, "!", 2, 4],["!", 2, 2, 5, 1, 6, 7],[6, 0, 2, 7, 2, 6, 0],[3, 6, 2, 0, 0, 8, 0],["!", 2, 5, 3, 5, 2, "X"],
			[2, 3, 7, "!", 4, 6, 6],[4, 2, 1, 6, 3, 4, "!"],[1, 6, 2, "!", 7, 4, 6],[3, 4, 3, "!", 8, 8, 4],
			[6, 1, 3, 6, 6, "!", 1],[4, "!", 3, 8, 1, "X", 7],[7, 0, 5, 4, 0, 1, 3],[5, 2, "!", 1, 4, "X", 7],
			[4, 4, 3, 3, 3, "!", 2],[4, 0, 4, 1, 0, "X", 5],[2, 2, 5, 4, "!", 5, 2],[5, 6, 7, 0, 2, 2, 0]]
		expect(mask.reduce_problem).to eq([["X", [1,2],[3,0],[4,2],[6,2]],[[5, 1], 0, 0, 1, 4],[[14,1], 0, 7, 2, 0],[[15,1], 6, 0, 0, 0],
			[[23,1], 0, 4, 0, 3],[[26,1], 0, 1, 0, 5],[[28,1], 6, 0, 2, 0]])
	end

end

describe Array, ".next_assignment" do
	# call on mask Array object; run reduce_problem on the object; use result to get
	# row/col with most assignments needed to reach min, in event of tie choice is random;
	# outputs array [p,q] where p is the row/col ID and q is the number of needed assignments; 
	# I don't care if there are multiple arrays that are identical to [p,q]

	it "does not change the array it is called on" do
		mask = [[3, 3, 0, 3, 7, 2, 2, 6, 7, 2, "!", 4, 5, 4, 5, 1, 3, 5, 3, 0, "!", "!", 0, 6, 1],
			    [7, 2, 7, 4, 6, "!", 5, 0, 6, 5, 2, "!", 5, "!", 6, 3, 2, 0, 3, 0, 1, 3, 5, 0, 0],
			    [2, "!", 6, "!", 3, 8, 5, 4, 5, "X", 1, 1, "!", 1, 7, "X", "!", 6, "!", 1, "X", 5, 3, 6, 4],
			    ["!", 3, 7, 1, 1, 6, 7, 0, "!", 0, 4, 2, 7, 3, 2, "!", 4, 0, 3, 3, 6, 1, 0, 1, 5],
			    [2, 7, 0, 7, "!", 1, "!", 1, 5, 0, 3, 5, 6, 2, "!", 4, 5, 1, 7, 3, 6, 4, 7, 0, 0]]
		original = mask.dup
		mask.next_assignment
		expect(mask).to eq(original)
	end

	it "returns nothing when called on a solved mask" do
		mask = [[3, 2, 4, "!", 5, 2, 4, 4, 7, 7],["!", 4, 1, 2, 2, "X", 5, 2, 2, 5],[7, 7, "X", 1, 1, 1, 4, 5, 4, "!"],
		[6, 2, "!", 2, 5, 2, 1, 1, 7, 3],["X", 5, "X", 1, "!", 2, 5, 3, 5, "X"],["X", 4, 7, 1, 1, 2, 7, "!", "X", 7],
		[2, 4, 1, 3, 6, "!", 5, 4, 6, "X"],[8, "!", 3, 2, 5, "X", 5, 4, 1, 7],[4, 1, 5, 3, 2, 2, "!", 1, "X", 6],
		[6, 6, "X", 8, 4, 4, 8, 7, "!", 3]]
		expect(mask.next_assignment).to eq(nil)
	end

	# these are taken care of by the tests below
	# it "outputs the correct array when it occurs in a row" do
	# end

	# it "outputs the correct array when it occurs in a column" do
	# end

	it "outputs correct array when there are three different values for needed assignemnts, and a column requires the most assignments" do
		mask = [["X", 6, "!", "X", 1, 3, 6],[3, 5, 7, 2, 4, "!", 6],[6, 3, 4, 5, 1, "!", 3],["!", 1, 2, 6, 1, 1, 6],
			[3, 6, 5, 4, 1, 6, "!"],[3, 0, 3, 0, 1, 5, 4],[7, "X", "!", "X", 4, 6, "X"],[7, 5, 4, 7, 7, "!", 3],
			[7, 1, 6, "!", 4, 8, 8],[6, "!", 5, 7, 6, 4, 6],[2, "X", "!", "X", 1, "X", 2],["!", "X", 3, 3, "X", 6, 6],
			[1, 1, 1, 3, "!", 2, 4],["!", 2, 2, 5, 1, 6, 7],[6, 0, 2, 7, 2, 6, 0],[3, 6, 2, 0, 0, 8, 0],["!", 2, 5, 3, 5, 2, "X"],
			[2, 3, 7, "!", 4, 6, 6],[4, 2, 1, 6, 3, 4, "!"],[1, 6, 2, "!", 7, 4, 6],[3, 4, 3, "!", 8, 8, 4],
			[6, 1, 3, 6, 6, "!", 1],[4, "!", 3, 8, 1, "X", 7],[7, 0, 5, 4, 0, 1, 3],[5, 2, "!", 1, 4, "X", 7],
			[4, 4, 3, 3, 3, "!", 2],[4, 0, 4, 1, 0, "X", 5],[2, 2, 5, 4, "!", 5, 2],[5, 6, 7, 0, 2, 2, 0]]
		expect(mask.next_assignment).to eq([1,2])
	end

	it "outputs correct array when dimensions are uneven, and a row requires the most assignments" do
		mask = [[5, 5, "X", 3, 4, 2, 2, 6, 3, 1, 7, 4, 0, 5, 3, 6, 0, 5, "!", 0, 0, 2, 2, "!", 3, 0, "!"],
			    [6, 2, "!", 3, "!", 1, "!", 4, 6, "!", 6, 2, 4, 7, 2, 4, 1, 3, 2, 2, 3, 1, "!", 1, 5, 2, 4],
			    [4, 3, 6, 0, 1, 5, 7, 4, "!", 5, "!", "!", 8, 6, 6, 7, 0, 4, 3, 3, 8, 4, 2, 3, "!", 5, 1],
			    [4, "!", "X", 0, "X", "!", 5, "!", 6, "X", 8, 3, 0, 5, 3, 4, 0, "!", 2, 0, 0, 4, "X", 1, 1, 0, 3],
			    ["!", 6, 2, 5, 6, 2, 7, 1, 1, "X", 7, 3, 7, "!", "!", "!", 7, 1, 2, 1, 3, "!", "X", 4, 1, 2, 6]]
		expect(mask.next_assignment).to eq([0,2])
	end		   
	
end

describe Array, ".make_next_assignment" do
	# called on mask Array object; gets array [p,q] from next_assignment, where p is a row/col ID and q is the number of needed assignments; finds that value first in row 0 of
	# the reduction array, and if not there then in col 0 of the reduction array; once found, it assigns to the zero with the fewest
	# other zeros in its respective row/col, in event of tie it assigns to zero closest to the top/left; then it makes the corresponding
	# assignment to the mask; then it reruns assign to needy zeros (abstract sub-methods from the assign_needy_zeros method)

	it "changes the array it is called on when mask is not a complete assignment" do
		mask = [[6, 1, 8, "!", 2],[3, 2, 2, "!", 5],["X", 3, 1, 3, "!"],[1, 7, 4, 2, "!"],[8, "!", 2, 7, 7],[4, 0, 0, 2, 4],
			[1, 3, 2, "!", 1],[8, 0, 6, 0, 2],[4, 4, "!", 6, 4],[5, "X", "X", 1, "!"],[5, 4, 0, 0, 5],[5, 2, 3, 1, "!"],
			[2, 0, 2, 0, 4],[4, 0, 2, 0, 2],["X", 7, 7, "!", 4],["X", 2, 1, 5, "!"],["!", 1, 3, 2, 3],["!", 2, 7, 5, 4],
			[1, 0, 3, 0, 3],["!", 1, 1, 4, 6],["!", 4, 6, 2, 3],["X", 6, "!", 1, 1],[6, 0, 0, 0, 5],["!", 3, 4, 6, 1],
			[4, 1, "!", 3, 4]]
		original = mask.dup
		mask.make_next_assignment
		expect(mask).to_not eq(original)
	end

	it "returns 'finished' when called on a solved mask" do
		mask = [[3, 2, 4, "!", 5, 2, 4, 4, 7, 7],["!", 4, 1, 2, 2, "X", 5, 2, 2, 5],[7, 7, "X", 1, 1, 1, 4, 5, 4, "!"],
		[6, 2, "!", 2, 5, 2, 1, 1, 7, 3],["X", 5, "X", 1, "!", 2, 5, 3, 5, "X"],["X", 4, 7, 1, 1, 2, 7, "!", "X", 7],
		[2, 4, 1, 3, 6, "!", 5, 4, 6, "X"],[8, "!", 3, 2, 5, "X", 5, 4, 1, 7],[4, 1, 5, 3, 2, 2, "!", 1, "X", 6],
		[6, 6, "X", 8, 4, 4, 8, 7, "!", 3]]
		print mask.solution?
		print mask.reduce_problem
		expect(mask.make_next_assignment).to eq("finished")
	end

	it "does not change the array it's called on when called on a solved mask" do
		mask = [[3, 2, 4, "!", 5, 2, 4, 4, 7, 7],["!", 4, 1, 2, 2, "X", 5, 2, 2, 5],[7, 7, "X", 1, 1, 1, 4, 5, 4, "!"],
		[6, 2, "!", 2, 5, 2, 1, 1, 7, 3],["X", 5, "X", 1, "!", 2, 5, 3, 5, "X"],["X", 4, 7, 1, 1, 2, 7, "!", "X", 7],
		[2, 4, 1, 3, 6, "!", 5, 4, 6, "X"],[8, "!", 3, 2, 5, "X", 5, 4, 1, 7],[4, 1, 5, 3, 2, 2, "!", 1, "X", 6],
		[6, 6, "X", 8, 4, 4, 8, 7, "!", 3]]
		original = mask.dup
		mask.make_next_assignment
		expect(mask).to eq(original)
	end

	it "assigns correct zero when a row requires most assignments, and it is the first zero in that row" do
	end

	it "assigns correct zero when a row requires most assignments, and it is not the first zero in that row,
	 but it has the fewest zeros in its column, no ties" do
	end

	it "assigns correct zero when a row requires most assignments, and is not the first zero in that row, and
	 it is tied with another zero in the row for the number of zeros in its column" do
	end

	it "assigns correct zero when a column requires most assignments, and it is the first zero in that column" do
	end

	it "assigns correct zero when a column requires most assignments, and it is not the first zero in that column,
	 but it has the fewest zeros in its row, no ties" do
	end

	it "assigns correct zero when a column requires most assignments, and is not the first zero in that column, and
	 it is tied with another zero in the column for the number of zeros in its row" do
	end



end

describe Array, ".needy_zeros" do

	# call on mask Array object; outputs coordinates of any zeros that are in "needy" rows/columns, where a row/column is needy iff every 
	# assignable zero in it must be assigned in order for it to reach its minimum allowable value

	it "finds the needy zero when there is only one" do
		array = [[0,1,3],[4,7,2],[12,11,1]]
		expect(array.needy_zeros).to eq([[0,0]])
	end

	it "finds needy zeros when there are multiple" do
		array = [[0,1,3],[4,0,2],[12,11,1]]
		expect(array.lonely_zeros).to eq([[0,0],[1,1]])
	end

	it "identifies lonely zeros as needy zeros" do
		array = [[0,1,0],[4,0,2],[12,11,0]]
		expect(array.needy_zeros).to eq([[0,0],[1,1],[2,2]])
	end

	it "can identify non-lonely zeros as needy zeros" do
		array = [[0,6,7,8,9,4,3,0],[0,2,4,7,2,3,4,0],[0,9,3,5,7,3,6,0],[0,3,4,5,6,2,4,0]]
		expect(array.needy_zeros).to eq([[0,0],[0,7],[1,0],[1,7],[2,0],[2,7],[3,0],[3,7]])
	end

	it "can distinguish non-lonely needy zeros from non-lonely non-needy zeros, more rows than columns" do
		array = [[0,8,0,2,3],[0,0,7,0,0]]
		expect(array.needy_zeros).to eq([[0,0],[0,2],[1,1],[1,3],[1,4]])
	end

	it "can distinguish non-lonely needy zeros from non-lonely non-needy zeros, more rows than columns" do
		array = [[0,0,4,4,4,6,5,2,5,1],[0,2,4,1,3,2,3,2,7,6],[7,3,0,1,2,7,1,3,4,0],[0,2,0,5,4,7,1,9,1,0],[1,0,1,2,6,6,6,4,2,0]]
		expect(array.needy_zeros).to eq([[0,0],[0,1],[1,0],[2,2],[2,9],[4,1],[4,9]])
	end

	it "can distinguish non-lonely needy zeros from non-lonely non-needy zeros, more columns than rows" do
		array = [[8,2,4,0],[0,5,6,0],[8,0,6,0],[3,0,2,0],[1,4,0,0],[1,8,0,0],[0,3,5,0],[2,9,7,0]]
		expect(array.needy_zeros).to eq([[0,3],[1,0],[2,1],[3,1],[4,2],[5,2],[6,0],[7,3]])
	end

end

describe Array, ".lonely_zeros" do
	# called on Array object; returns an array of coordinates [n,m] of every lonely zero; a "lonely" zero is one which occurs as the 
	# sole zero in EITHER its row or its column

	it "finds the lonely zero when there is only one" do
		array = [[0,1,3],[4,7,2],[12,11,1]]
		expect(array.lonely_zeros).to eq([[0,0]])
	end

	it "finds lonely zeros when there are multiple" do
		array = [[0,1,3],[4,0,2],[12,11,1]]
		expect(array.lonely_zeros).to eq([[0,0],[1,1]])
	end

	it "finds lonely zeros in columns when they occur in rows with other zeros" do
		array = [[0,0,3],[4,0,0],[12,0,0]]
		expect(array.lonely_zeros).to eq([[0,0]])
	end

	it "finds lonely zeros in rows when they occur in columns with other zeros" do
		array = [[0,7,3],[0,0,12],[0,0,6]]
		expect(array.lonely_zeros).to eq([[0,0]])
	end

	it "finds lonely zeros in a medium-sized array of randomly generated values between 0 and 9" do
		array = [[3,7,3,6,3,8,2,1,6],[3,5,1,9,4,8,7,8,0],[9,9,6,6,2,4,0,1,2],[9,5,6,1,3,8,7,1,1],[7,7,3,8,7,7,4,2,9],
			[0,9,4,5,5,7,5,8,3],[0,0,2,8,3,7,9,3,4],[8,2,1,5,9,4,3,4,8],[8,6,2,3,3,6,9,0,7]]
		expect(array.lonely_zeros).to eq([[1,8],[2,6],[5,0],[6,1],[8,7]])
	end

	it "only lists zeros lonely for both their column AND row once" do
		array = [[1,2,3],[4,0,7],[9,8,6]]
		expect(array.lonely_zeros).to eq([[1,1]])
	end

end

describe Array, ".extra_lonely_zeros" do
	# called on array object; returns array of coordinates [p,q] such that each self[p][q] is an extra-lonely zero
	# an "extra lonely" zero is one which occurs as the only zero in both its row AND column

	it "finds extra lonely zero when there is only one" do
		array = [[10,2,5],[9,0,7],[8,2,5]]
		expect(array.extra_lonely_zeros).to eq([[1,1]])
	end

	it "finds extra lonely zeros when there are multiple" do
		array = [[0,2,5],[9,4,7],[8,2,0]]
		expect(array.extra_lonely_zeros).to eq([[0,0],[2,2]])
	end

	it "finds extra lonely zeros when there are multiple" do
		array = [[0,2,5],[9,0,7],[8,2,10]]
		expect(array.extra_lonely_zeros).to eq([[0,0],[1,1]])
	end

	it "distinguishes between non-lonely, lonely, and extra lonely zeros" do
		array = [[0,2,0],[9,0,7],[8,2,0]]
		expect(array.lonely_zeros).to eq([[0,0],[1,1],[2,2]])
		expect(array.extra_lonely_zeros).to eq([[1,1]])
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

describe Object, "assign_needy_zeros(mask)" do
	# pass a mask Array object; assigns to lonely zeros and extended lonely zeros in the mask, then returns the mask


	it "changes the object it is passed" do
		array = [[0,1,3],[4,7,2],[12,11,1]]
		assign_needy_zeros(array)
		expect(array).to_not eq([[0,1,3],[4,7,2],[12,11,1]])
	end

	it "changes object it is passed, marks Xs in columns" do
		array = [[0,0,0],[4,0,8],[12,0,0]]
		assign_needy_zeros(array)
		expect(array.include?([12,"X","!"])).to eq(true)
	end

	it "raises error when passed a non-array" do
		array = 9
		expect {assign_needy_zeros(array)}.to raise_error(RuntimeError, 'Wrong kind of argument, requires an array')
	end

	it "raises error when passed a non-2D array, i.e. an array without non-matrix dimensions" do
		array = [[1,2],1]
		expect {assign_needy_zeros(array)}.to raise_error()
	end

	it "assigns lonely zero when there is only one, no other zeros around" do
		array = [[0,1,3],[4,7,2],[12,11,1]]
		expect(assign_needy_zeros(array)).to eq([["!",1,3],[4,7,2],[12,11,1]])
	end

	it "assigns lonely zero when there is only one and other zeros are around" do
		array = [[0,1,0],[4,0,2],[0,11,0]]
		expect(assign_needy_zeros(array)).to eq([[0,1,0],[4,"!",2],[0,11,0]])
	end

	it "changes nothing when there are no needy zeros" do
		array = [[0,1,0],[4,8,2],[0,11,0]]
		assign_needy_zeros(array)
		expect(array).to eq([[0,1,0],[4,8,2],[0,11,0]])
	end

	it "assigns needy zeros when there are multiple" do
		array = [[0,1,3],[4,0,2],[12,11,1]]
		expect(assign_needy_zeros(array)).to eq([["!",1,3],[4,"!",2],[12,11,1]])
	end

	it "assigns needy zeros in columns when they occur in rows with other zeros" do
		array = [[0,9,3],[4,0,0],[12,0,0]]
		expect(assign_needy_zeros(array)).to eq([["!",9,3],[4,0,0],[12,0,0]])
	end

	it "assigns needy zeros in rows when they occur with other zeros, marks unassignable zeros with Xs, 
		assigns extended needy zeros" do
		array = [[0,7,3],[0,0,0],[0,0,6]]
		assign_needy_zeros(array)
		expect(array).to eq([["!",7,3],["X","X","!"],["X","!",6]])
	end

	it "assigns needy zeros in a medium-sized array of randomly generated values between 0 and 9" do
		array = [[3,7,3,6,3,8,2,1,6],[3,5,1,9,4,8,7,8,0],[9,9,6,6,2,4,0,1,2],[9,5,6,1,3,8,7,1,1],[7,7,3,8,7,7,4,2,9],
			[0,9,4,5,5,7,5,8,3],[9,0,2,8,3,7,9,3,4],[8,2,1,5,9,4,3,4,8],[8,6,2,3,3,6,9,0,7]]
		assign_needy_zeros(array)
		expect(array).to eq([[3,7,3,6,3,8,2,1,6],[3,5,1,9,4,8,7,8,"!"],[9,9,6,6,2,4,"!",1,2],[9,5,6,1,3,8,7,1,1],[7,7,3,8,7,7,4,2,9],
			["!",9,4,5,5,7,5,8,3],[9,"!",2,8,3,7,9,3,4],[8,2,1,5,9,4,3,4,8],[8,6,2,3,3,6,9,"!",7]])
	end

	it "marks unassignable zeros with X when there is only one" do
		array = [[0,0,3],[4,0,0],[12,0,0]]
		expect(assign_needy_zeros(array)).to eq([["!","X",3],[4,0,0],[12,0,0]])
	end

	it "marks unassignable zeros with X when there is only one in a medium-sized array" do
		array = [[3,7,3,6,3,8,2,1,6],[3,5,1,9,4,8,7,8,0],[9,9,6,6,2,4,0,1,2],[9,5,6,1,3,8,7,1,1],[7,7,3,8,7,7,4,2,9],
			[0,9,4,5,5,7,5,8,3],[0,0,2,8,3,7,9,3,4],[8,2,1,5,9,4,3,4,8],[8,6,2,3,3,6,9,0,7]]
		assign_needy_zeros(array)
		expect(array).to eq([[3,7,3,6,3,8,2,1,6],[3,5,1,9,4,8,7,8,"!"],[9,9,6,6,2,4,"!",1,2],[9,5,6,1,3,8,7,1,1],[7,7,3,8,7,7,4,2,9],
			["!",9,4,5,5,7,5,8,3],["X","!",2,8,3,7,9,3,4],[8,2,1,5,9,4,3,4,8],[8,6,2,3,3,6,9,"!",7]])
	end

	it "marks unassignable zeros with X when there are multiple" do
		array = [[0,0,0],[4,0,0],[12,0,0]]
		expect(assign_needy_zeros(array)).to eq([["!","X","X"],[4,0,0],[12,0,0]])
	end

	it "marks extended extra lonely zeros when there is one" do
		array = [[0,0,0],[4,0,8],[12,0,0]]
		assign_needy_zeros(array)
		expect(array).to eq([["!","X","X"],[4,"!",8],[12,"X","!"]])
	end

	it "marks extended extra lonely zeros when there are multiple" do
		array = [[0,0,0,2,9],[4,0,8,5,0],[2,3,0,3,0],[2,2,2,2,0],[5,3,2,8,4]]
		assign_needy_zeros(array)
		expect(array).to eq([["!","X","X",2,9],[4,"!",8,5,"X"],[2,3,"!",3,"X"],[2,2,2,2,"!"],[5,3,2,8,4]])
	end

	it "assigns to all of the extended lonely zeros when they appear only after several rounds of changes" do
		array = [[0,0,0,9,1],[0,6,7,8,9],[0,0,0,0,0],[0,0,1,2,4],[0,0,0,0,8]]
		assign_needy_zeros(array)
		expect(array).to eq([["X","X","!",9,1],["!",6,7,8,9],["X","X","X","X","!"],["X","!",1,2,4],["X","X","X","!",8]])
	end

	it "assigns to all of the extended lonely zeros when they appear only after several rounds of changes, when the
			min_row_assignment is greater than 1" do
		array = [[0,0,9,9,1,0,7,0],[0,6,7,8,9,1,2,0],[0,0,0,0,0,1,2,0],[0,0,0,2,4,6,0,0]]
		assign_needy_zeros(array)
		expect(array).to eq([["X","!",9,9,1,"!",7,"X"],["!",6,7,8,9,1,2,"!"],["X","X","X","!","!",1,2,"X"],["X","X","!",2,4,6,"!","X"]])
	end

	# it "does not add assignments over the max allowable for columns" do
	# end

	# it "does not add assignments over the max allowable for rows" do
	# end


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

describe Array, "zero_rows_and_columns" do
	# call on Array object; return Array object which has been normalized in rows and in columns

	# generates array of arrays N rows by M columns filled with random integers from 1-P inclusive
	# Array.new(N) {Array.new(M) {rand(P)+1}}

	# normalizes rows and then columns:
	# .each.map {|r| r.map {|v| v - r.min}}.transpose.each.map {|r| r.map {|v| v - r.min}}.transpose

	# normalizes columns and then rows:
	# .transpose.each.map {|r| r.map {|v| v - r.min}}.transpose.each.map {|r| r.map {|v| v - r.min}}


	it "should always choose the most efficient dimension to order first" do
		method_works = 0

		1000.times do
			num_rows = rand(7)+3
			num_columns = num_rows + (rand(7)+3)
			a = Array.new(num_rows) {Array.new(num_columns) {rand(9)+1}}
			original = a.dup
			b = a.dup
			c = a.dup

			solutionA = a.zero_each_row.zero_each_column
			diffA = (original.to_m - solutionA.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+)

			solutionB = b.zero_each_column.zero_each_row
			diffB = (original.to_m - solutionB.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+)

			solutionC = c.zero_rows_and_columns
			diffC = (original.to_m - solutionC.to_m).collect{|e| e.abs}.to_a.flatten(1).inject(:+)

			method_works = method_works + 1 if diffC <= diffA && diffC <= diffB
		end
		expect(100*method_works/1000).to eq(100)
	end


	it "works when # of columns = # of rows" do
		matrix = [[4,11,9,7,4,6,3,3],[12,5,11,11,12,9,2,14],[3,14,14,11,2,4,7,3],[14,3,12,1,2,15,0,1],
				[0,11,9,3,5,7,5,14],[13,9,15,7,3,5,3,1],[3,2,15,11,2,12,12,14],[14,8,6,14,7,7,2,4]]
		expect(matrix.zero_rows_and_columns).to eq([[1, 8, 2,  3, 1,  1,  0, 0], [10, 3, 5,  8, 10, 5,  0, 12], [1, 12, 8,  8, 0,  0,  5, 1], [14, 3, 8,  0, 2,  13, 0, 1], 
				[0, 11, 5,  2, 5,  5,  5, 14], [12, 8, 10, 5, 2,  2,  2,  0], [1,  0, 9,  8, 0,  8,  10, 12], [12, 6, 0, 11, 5,  3,  0,  2]])
	end

	it "works when # of rows > # of columns" do
		array = [[1,2,3,3,3,9,8,8,6],[5,4,6,8,8,2,9,2,7],[5,5,9,10,12,6,7,9,5]]
		array.zero_rows_and_columns
		expect(array).to eq([[0,0,0,0,0,6,3,5,3],[1,0,2,4,4,0,3,0,3],[0,0,4,5,7,1,0,4,0]])
	end

	it "works when # of columns > # of rows" do
		array = [[6, 1, 4, 5], [9, 7, 9, 1], [3, 8, 3, 3], [7, 2, 5, 8], [4, 1, 6, 3], [4, 6, 7, 7], [7, 1, 9, 8], 
			[2, 4, 7, 9], [8, 5, 4, 9], [6, 9, 1, 4], [5, 2, 5, 4], [6, 7, 1, 7], [3, 7, 9, 1], [1, 1, 3, 2], [9, 5, 6, 1], 
			[6, 4, 5, 4], [2, 8, 9, 2], [4, 5, 2, 9], [6, 3, 4, 3], [9, 6, 2, 1]]
		array.zero_rows_and_columns
		expect(array).to eq([[5, 0, 3, 4], [8, 6, 8, 0], [0, 5, 0, 0], [5, 0, 3, 6], [3, 0, 5, 2], [0, 2, 3, 3], [6, 0, 8, 7], 
			[0, 2, 5, 7], [4, 1, 0, 5], [5, 8, 0, 3], [3, 0, 3, 2], [5, 6, 0, 6], [2, 6, 8, 0], [0, 0, 2, 1], [8, 4, 5, 0], 
			[2, 0, 1, 0], [0, 6, 7, 0], [2, 3, 0, 7], [3, 0, 1, 0], [8, 5, 1, 0]])
	end

	it "changes nothing when called on a Matrix that is already normalized" do
		matrix = Array.new(20) {Array.new(80) {rand(11)}}
		solution = matrix.transpose.each.map {|r| r.map {|v| v - r.min}}.transpose.each.map {|r| r.map {|v| v - r.min}}
		expect(solution.zero_rows_and_columns).to eq(solution)
	end

	it "changes nothing in problem case" do
		matrix = [[1,1,1,1,1,1],[1,4,5,6,3,1],[1,9,3,8,5,1],[1,5,8,7,3,1],[1,3,9,5,7,1],[1,1,1,1,1,1]]
		solution_matrix = [[0,0,0,0,0,0],[0,3,4,5,2,0],[0,8,2,7,4,0],[0,4,7,6,2,0],[0,2,8,4,6,0],[0,0,0,0,0,0]]	
		expect(matrix.zero_rows_and_columns).to eq(solution_matrix)
	end
end


describe Array, '.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(submatrix)' do
	# called on Array object, passed array that is a submatrix (Array format) of the Array-matrix
	# makes changes to the Array it's called on, subtracting the smallest min-sans-zero value that resides in a column
	# (that does not contain a zero in the submatrix) from every member in its row with the exception of zeros; changes 
	# the corresponding values in the Array; repeats the process until min_row_permitted <= max_col_assignments_possible
	# returns the corrected Array object it was called on

	it "fixes the matrix minimally when submatrix passed in is only problematic submatrix" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		argument = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2]]
		matrix.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(argument)
		expect(matrix).to eq([[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],
			[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

	it "fixes the matrix minimally when submatrix passed in is only one of several problematic submatrices" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		argument = [[2,6,1,0,1,8,2],[8,3,9,0,2,7,1]]
		matrix.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(argument)
		expect(matrix).to eq([[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],
			[1,0,3,9,1,0,6],[1,5,0,0,0,7,1],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

	# this test case is interesting for several reasons: first, multiple changes have to be made; second, the first few changes that will be made
	# create zeros in the same column, so they don't really add new column assignments; third, when one change is made, this changes the values in
	# other rows, meaning that the min values for the rows are constantly changing
	# NOTE: the result of running this method need NOT result in a matrix that is solveable, since it's not being passed the series of minimally
 	# problematic submatrices it contains; it's just being passed a rather large problematic submatrix; when this method is going to be called in the
	# actual algorithm it's first going to be called on all of the smaller submatrices first; and in that case should return a solveable array
	it "fixes the matrix minimally when more than one value has to be changed" do
		matrix = [[1,9,7,0,5,6,9],[2,7,7,0,7,9,23],[7,3,3,0,4,9,6],[2,6,7,0,7,8,4],[8,3,9,0,8,7,4],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		argument = [[1,9,7,0,5,6,9],[2,7,7,0,7,9,23],[7,3,3,0,4,9,6],[2,6,7,0,7,8,4],[8,3,9,0,8,7,4]]
		matrix.subtract_min_sans_zero_from_rows_to_add_new_column_assignments(argument)
		expect(matrix).to eq([[0,8,6,0,4,5,8],[2,7,7,0,7,9,23],[3,0,0,0,0,5,2],[2,6,7,0,7,8,4],
			[8,3,9,0,8,7,4],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

end

describe Array, ".make_more_column_assignments_possible" do
	# called on Array object; returns Array corrected such that min permitted row assignments <= max column assignments possible
		# HOW THIS IS GOING TO WORK
		# 1. Find problematic submatrices
		# 	2. In each such submarix, identify the minimum value-sans-zero in each row
		# 	3. Identify the smallest such min-sans-zero
		# 		4. Subtract the min-sans-zero from every member-sans-zero of the row in which it occurs
		# 5. Repeat step 1 until min permitted row assignments <= max column assignments possible

	it "works when the smallest problematic submmatrix is all that has to be changed" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		expect(matrix.make_more_column_assignments_possible).to eq([[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],
			[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

	# should work when there are many problematic submatrices built off the same elements (i.e. which share the same elements)
	it "works when two overlapping problematic submatrices have to be changed" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[8,3,9,0,2,7,1],
			[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		expect(matrix.make_more_column_assignments_possible).to eq([[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],
				[1,0,3,9,1,0,6],[1,5,0,0,0,7,1],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]])
	end

	# should work when there are two distinct problematic submatrices (i.e. which do not share any elements)
	it "works when two distinct problematic submatrices have to be changed" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[4,3,0,4,0,7,4],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]]
		expect(matrix.make_more_column_assignments_possible).to eq([[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],[0,0,2,8,0,0,5],[2,6,1,0,1,8,2],
			[0,0,0,0,0,3,0],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]])
	end

	# original algorithm does not handle this case correctly; it changes [2,6,1,0,1,8,2] into [1,6,0,0,0,8,1] and then into [0,4,0,0,0,6,0]
	# to resolve the conflict, when it could have changed [1,0,0,1,0,4,1] into [0,0,0,0,0,3,0] to resolve the conflict;
	# the former change requires changing values by 2, the latter only by 1; by the principle of minimal mutilation, the second should be
	# preferred
	it "works when two distinct problematic submatrices have to be changed, hard case" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[4,3,0,4,0,7,4],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]]
		expect(matrix.make_more_column_assignments_possible).to eq([[0,0,0,0,4,5,8],[6,7,1,0,1,0,23],[0,0,2,8,0,0,5],[2,6,1,0,1,8,2],
			[0,0,0,0,0,3,0],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]])
	end

end

describe Array, ".get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible" do
	# Call on Array object; returns array of submatrices (in array format) for which the number of minimum row assignments permitted
	# is greater than then number of possible column assignments

	# returns nothing when there are no such submatrices
	it "returns [] when called on Matrix[[1,2,0],[0,3,9]]" do
		matrix = [[1,2,0],[0,3,9]]
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible).to eq([])
	end

	# should work when there is exactly one problematic submatrix
	it "returns one submatrix when called on [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],
		[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible.count).to eq(1)
		expect(matrix.get_submatrices_where_min_row_permitted_is_greater_than_max_col_possible).to eq([ [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],
			[1,0,3,9,1,0,6],[2,6,1,0,1,8,2]]])
	end

	# should work when there are many problematic submatrices built off the same elements (i.e. which share the same elements)
	it "returns nine submatrices when called on [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],
		[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[8,3,9,0,2,7,1],[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
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
	it "returns one submatrix when called on [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],
		[2,6,1,0,1,8,2],[4,3,0,4,0,7,4],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]]" do
		matrix = [[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[4,3,0,4,0,7,4],[4,8,0,9,0,9,4],[4,4,0,5,0,4,9]]
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


describe Array, ".find_matching_row_then_subtract_value" do
	# called on Array; finds all rows matching the row_to_match (data type: array) given as first parameter;
	# subtracts input value from each member of each row matching the row_array, skips over zeros
	# returns corrected Array object
	# PARAMETERS (row_to_match, value_to_subtract)

	# it should work when passed a Matrix with just one row
	it "returns Matrix[[0,0,0,2]] when called on Matrix[[2,2,0,4]] and passed [2,2,0,4] and 2" do
		matrix = [[2,2,0,4]]
		matrix.find_matching_row_then_subtract_value([2,2,0,4],2)
		expect(matrix).to eq([[0,0,0,2]])
	end

	# it should work when passed the same row in a larger Matrix
	it "returns [[0,0,0,4],[7,8,9,2],[3,3,1,9]] when called on [[2,2,0,4],[7,8,9,2],[3,3,1,9]] and passed [2,2,0,4] and 2" do
		matrix = [[2,2,0,4],[7,8,9,2],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,2,0,4],2)
		expect(matrix).to eq([[0,0,0,2],[7,8,9,2],[3,3,1,9]])
	end

	# it should work when the row isn't the first row in a larger Matrix
	it "returns [[7,8,9,2],[0,0,0,4],[3,3,1,9]] when called on [[7,8,9,2],[2,2,0,4],[3,3,1,9]] and passed [2,2,0,4] and 2" do
		matrix = [[7,8,9,2],[2,2,0,4],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,2,0,4],2)
		expect(matrix).to eq([[7,8,9,2],[0,0,0,2],[3,3,1,9]])
	end

	# it shouldn't change anything when passed a row it doesn't contain, but is passed a row CLOSE to a row it contains
	it "returns [[7,8,9,2],[2,2,0,4],[3,3,1,9]] when called on [[7,8,9,2],[2,2,0,4],[3,3,1,9]] and passed [2,0,4] and 2" do
		matrix = [[7,8,9,2],[2,2,0,4],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,0,4],2)
		expect(matrix).to eq([[7,8,9,2],[2,2,0,4],[3,3,1,9]])
	end

	# it shouldn't change anything when passed a row it doesn't contain, but is passed a row CLOSE to a row it contains
	it "returns [[7,8,9,2],[2,2,0,4],[3,3,1,9]] when called on [[7,8,9,2],[2,2,0,4],[3,3,1,9]] and passed [2,2,0,4,1] and 2" do
		matrix = [[7,8,9,2],[2,2,0,4],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,0,4],2)
		expect(matrix).to eq([[7,8,9,2],[2,2,0,4],[3,3,1,9]])
	end

	# it shouldn't change anything when passed a value of zero, along with a row it does contain
	it "returns [[7,8,9,2],[2,2,0,4],[3,3,1,9]] when called on [[7,8,9,2],[2,2,0,4],[3,3,1,9]] and passed [2,2,0,4] and 0" do
		matrix = [[7,8,9,2],[2,2,0,4],[3,3,1,9]]
		matrix.find_matching_row_then_subtract_value([2,0,4],2)
		expect(matrix).to eq([[7,8,9,2],[2,2,0,4],[3,3,1,9]])
	end

end

describe Array, ".add_value_if_zero_else_subtract_value_in_columns" do

	# called on Array object, takes column index and value as inputs
	# outputs Array in which the value provided has been added to each zero in the column and subtracted otherwise
	# def add_value_if_zero_else_subtract_value_in_columns(col_index, value)

	# it should add the value to each member of a column that contains only zeros
	it "returns [[2,2,9,5,6,8],[2,4,6,8,1,0],[2,2,4,7,8,0],[2,9,8,4,6,3],[2,6,4,9,2,4]] when called on 
		[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]] and passed 0, 2" do
		matrix = [[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(0,2)).to eq([[2,2,9,5,6,8],[2,4,6,8,1,0],[2,2,4,7,8,0],[2,9,8,4,6,3],[2,6,4,9,2,4]])
	end

	# it should add the value to each member of a column that contains many zeros
	it "returns [[0,2,9,5,6,8],[0,4,6,8,1,9],[0,2,4,7,8,9],[0,9,8,4,6,3],[0,6,4,9,2,4]] when called on 
		[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]] and passed 5, 9" do
		matrix = [[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(5,9)).to eq([[0,2,9,5,6,-1],[0,4,6,8,1,9],[0,2,4,7,8,9],[0,9,8,4,6,-6],[0,6,4,9,2,-5]])
	end

	# it should add the value even if it is very large
	it "returns [[1,4,1000006],[8,11,1000013]] when called on 
		[[1,4,6],[8,11,13]] and passed 1, 6" do
		matrix = [[1,4,0],[8,11,0]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(2,1000000)).to eq([[1,4,1000000],[8,11,1000000]])
	end

	# it should subtract the value to each member of a column that contains no zeros
	it "returns [[0,3,9,5,6,8],[0,3,6,8,1,0],[0,3,4,7,8,0],[0,3,8,4,6,3],[0,0,4,9,2,4],[2,1,7,3,6,3]] when called on 
		[[0,9,9,5,6,8],[0,9,6,8,1,0],[0,9,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4],[2,7,7,3,6,3]] and passed 1, 6" do
		matrix = [[0,9,9,5,6,8],[0,9,6,8,1,0],[0,9,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4],[2,7,7,3,6,3]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(1,6)).to eq([[0,3,9,5,6,8],[0,3,6,8,1,0],[0,3,4,7,8,0],[0,3,8,4,6,3],[0,0,4,9,2,4],[2,1,7,3,6,3]])
	end

	# it should leave the column unchanged if it is passed a value of zero
	it "returns [[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]] when called on 
		[[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]] and passed anything with 0" do
		matrix = [[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]]
		anything = (rand*10).ceil
		expect(matrix.add_value_if_zero_else_subtract_value_in_columns(anything,0)).to eq([[0,2,9,5,6,8],[0,4,6,8,1,0],[0,2,4,7,8,0],[0,9,8,4,6,3],[0,6,4,9,2,4]])
	end

	# it should throw an error if passed a column index for a column that doesn't exist

	# it should throw an error if passed a non-integer

	# it should throw an error if passed a non-number

	# it should throw an error if passed a negative value
end

describe Array, ".get_problematic_columns_per_problematic_row" do
	# called on Array object; outputs array of arrays [n,m,o] where n is the index of a row with too many lonely zeros
	# m is the number of lonely zero's in row n
	# and o is an ORDERED array that contains arrays [p,q] where p is a column index of a lonely zero in row n, 
	# and q is the min value in that column other than zero, ordered by ascending q value

	# multiple rows have too many lonely zeros, but columns are already ordered by ascending min-sans-zero value
	it "returns [[1,2,[[1,1],[2,7]]],[3,2,[[0,1],[4,3]]]] when called on [[3,3,9,0,7],[5,0,0,0,2],[6,6,7,0,3],[0,1,7,6,0],[1,6,8,0,3]]" do
		matrix = [[3,3,9,0,7],[5,0,0,0,2],[6,6,7,0,3],[0,1,7,6,0],[1,6,8,0,3]]
		expect(matrix.get_problematic_columns_per_problematic_row).to eq([[1,2,[[1,1],[2,7]]],[3,2,[[0,1],[4,2]]]])
	end

	# multiple rows have too many lonely zeros, but columns are NOT ordered by ascending min-sans-zero value
	it "returns [[1,2,[[2,1],[1,7]]],[3,2,[[4,1],[0,3]]]] when called on [[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]" do
		matrix = [[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]
		expect(matrix.get_problematic_columns_per_problematic_row).to eq([[1,2,[[2,1],[1,7]]],[3,2,[[4,1],[0,3]]]])
	end

	# no rows have too many lonely zeros
	it "returns [] when called on [[1,2,0],[3,0,9],[0,5,4]]" do
		matrix = [[1,2,0],[3,0,9],[0,5,4]]
		expect(matrix.get_problematic_columns_per_problematic_row).to eq([])
	end

end

describe Array, ".zero_fewest_problematic_columns" do
	# called on Array object; takes as input an array of arrays [n,m,o] where n is a row index, m is the number of lonely zeros in that row
	# and o is an ordered array of arrays [p,q] where p is the column index of a lonely zero in row n, and q is the min value in that column other than zero
	# see method "get_problematic_columns_per_problematic_row" for a convenient way to get a parameter like this
	# for each member of the array passed to this method as a parameter, the method adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited Array object it was called on

	# corrects minimum number of columns, and only those with the lowest min-sans-zero values
	it "returns [[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]] when called on
			    [[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]] and passed [[1,2,[[2,1],[1,7]]],[3,2,[[4,1],[0,3]]]]" do
		matrix = [[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]
		expect(matrix.zero_fewest_problematic_columns([[1,2,[[2,1],[1,7]]],[3,2,[[4,1],[0,3]]]])).to eq([[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]])
	end

	# corrects minimum number of columns, and only those with the lowest min-sans-zero values
	it "returns [[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]] when called on
			    [[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]] and passed result of get_problematic_columns_per_problematic_row" do
		matrix = [[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]
		expect(matrix.zero_fewest_problematic_columns(matrix.get_problematic_columns_per_problematic_row)).to eq([[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]])
	end

	# already vigorously tested the method that this method was written from, i.e. zero_fewest_problematic_rows
	# if this test passes, I'm satisfied this is going to work...

end

describe Array, ".fix_too_many_lonely_zeros_in_rows" do
	# called on Array object; finds rows that have too many lonely zeros, then the columnss in those rows that contain the lonely zeros
	# changes the values in the fewest columns possible to remove the problem

	# corrects minimum number of columns, and only those with the lowest min-sans-zero values
	it "returns [[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]] when called on
			    [[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]" do
		matrix = [[3,7,1,0,7],[5,0,0,0,1],[6,7,7,0,3],[0,7,7,6,0],[3,7,8,0,3]]
		expect(matrix.fix_too_many_lonely_zeros_in_rows).to eq([[3,7,0,0,6],[5,0,1,0,0],[6,7,6,0,2],[0,7,6,6,1],[3,7,7,0,2]])
	end

	# already vigorously tested the method that this method was written from, i.e. fix_too_many_lonely_zeros_in_columns
	# if this test passes, I'm satisfied this is going to work...
end

describe Array, ".zero_fewest_problematic_rows" do
	# called on Array object, for each row specified in params, adds min row-value-sans-zero to each zero in the row
	# subtracts min-row-value-sans-zero from each non-zero in the row; edits as few rows as necessary to remove the problem
	# returns the edited Array object it was called on
		# problematic rows must be an array of arrays [n,m,o], one for each problematic column
		# n is the column index, m is the number of lonely zeros in column n
		# o is an ORDERED array containing all arrays [p,q] where p is the row index of a row containing a lonely zero in column n
		# and q is the minimum value in that row-sans-zero; o is ordered by ascending q value
		# the "get_problematic_rows_per_problematic_column" method returns exactly this array

	# it shouldn't change the Matrix if passed an empty array
	it "returns [[0,1,4],[5,7,0],[9,0,9]] when called on [[0,1,4],[5,7,0],[9,0,9]] and passed []" do
		matrix = [[0,1,4],[5,7,0],[9,0,9]]
		expect(matrix.zero_fewest_problematic_rows([])).to eq([[0,1,4],[5,7,0],[9,0,9]])
	end

	# a possible big problem: if (1) fixing a matrix leads to an unsolveable matrix,
	# and (2) running the method again on the problematic matrix it generates just brings it back to the original problematic array
	# the following scenario almost fits the bill here

			# does it work when passed a small problematic array?
			it "returns [[0,5,6],[1,0,2],[9,0,4]] when called on [[0,5,6],[0,1,3],[9,0,4]] 
				and passed [[0,2,[[1,1],[0,5]]]" do
				matrix = [[0,5,6],[0,1,3],[9,0,4]]
				expect(matrix.zero_fewest_problematic_rows([[0,2,[[1,1],[0,5]]]])).to eq([[0,5,6],[1,0,2],[9,0,4]])
			end

			# does it work on the array it produces in the previous example?
			it "returns [[0,5,6],[0,1,3],[9,0,4]] when called on [[0,5,6],[1,0,2],[9,0,4]] 
				and passed [[1,2,[[1,1],[2,4]]]" do
				matrix = [[0,5,6],[1,0,2],[9,0,4]]
				expect(matrix.zero_fewest_problematic_rows([[1,2,[[1,1],[2,4]]]])).to eq([[0,5,6],[0,1,1],[9,0,4]])
			end

			# does it work on the array it produces in the previous example?
			it "returns [[0,5,6],[1,0,0],[9,0,4]] when called on [[0,5,6],[0,1,1],[9,0,4]] 
				and passed [[0,2,[[1,1],[0,5]]]]" do
				matrix = [[0,5,6],[0,1,1],[9,0,4]]
				expect(matrix.zero_fewest_problematic_rows([[0,2,[[1,1],[0,5]]]])).to eq([[0,5,6],[1,0,0],[9,0,4]])
			end

			# ---------------------------------------------
			# second attempt to produce the vicious loop
				# it "returns [[1,0,0,1],[0,2,2,0],[8,0,0,8]] when called on matrix = [[0,1,1,0],[0,2,2,0],[8,0,0,8]] and 
				# passed matrix.get_problematic_rows_per_problematic_column" do
					# this doesn't work either! none of these zeros is lonely!

	# does it work when passed problematic_rows directly when there are multiple columns with too many lonely zeros, and those zeros occur in rows with differing min-sans-zero values?
	it "returns [[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]]
		when called on [[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]],
			and passed [[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]]" do
		matrix = [[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.zero_fewest_problematic_rows([[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]])).to eq([[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],
			[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]])
	end

	# does it work with the get_problematic_rows_per_problematic_column method when there are multiple columns with too many lonely zeros, and those zeros occur in rows with differing min-sans-zero values?
	it "returns [[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]]
		when called on matrix = [[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]],
			and passed matrix.get_problematic_rows_per_problematic_column" do
		matrix = [[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.zero_fewest_problematic_rows(matrix.get_problematic_rows_per_problematic_column)).to eq([[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],
			[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]])
	end
end


describe Array, ".fix_too_many_lonely_zeros_in_columns" do
	# called on Array object; finds columns that have too many lonely zeros, then the rows in those columns that contain the lonely zeros
	# changes the values in the fewest rows possible to remove the problem
		# isolate the columns that are causing the problem, then the rows in those columns that contain their lonely zeros
		# PROBLEM: it could be that there are multiple columns with too many lonely zeros, e.g. one col might have 4, another 2
			# and if the max col assignment were 1, you would want to add_value_if_zero to 3 of the 4 rows in the first group
			# and only 1 of the 2 rows in the second group
			# so you need some way of keeping track of these groups

		# now make the fewest changes necessary to remove the problem, and determine which row to correct based on the other values in that row
		# you want to correct the row with the lowest min value first, then the row with the next lowest, then with the next lowest, and so on
		# point is: you want to minimize the extent to which you have to lower values to get an assignment

	# does it work when there are multiple columns with too many lonely zeros, and those zeros occur in rows with differing min-sans-zero values?
	it "returns [[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]]
		when called on matrix = [[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]" do
		matrix = [[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq([[0,6,6,6,6,9,10,17],[0,0,0,9,0,0,35,40],
			[5,0,0,0,0,0,50,47],[17,17,17,0,17,17,88,81],[0,0,0,8,0,0,0,769]])
	end

	# does it work when passed a small problematic array?
	it "returns [[0,5,6],[1,0,2],[9,0,4]] when called on [[0,5,6],[0,1,3],[9,0,4]]" do
		matrix = [[0,5,6],[0,1,3],[9,0,4]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq([[0,5,6],[1,0,2],[9,0,4]])
	end

	# does it work on the array it produces in the previous example?
	it "returns [[0,5,6],[0,1,3],[9,0,4]] when called on [[0,5,6],[1,0,2],[9,0,4]]" do
		matrix = [[0,5,6],[1,0,2],[9,0,4]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq([[0,5,6],[0,1,1],[9,0,4]])
	end

	# does it work on the array it produces in the previous example?
	it "returns [[0,5,6],[1,0,0],[9,0,4]] when called on [[0,5,6],[0,1,1],[9,0,4]]" do
		matrix = [[0,5,6],[0,1,1],[9,0,4]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq([[0,5,6],[1,0,0],[9,0,4]])
	end

	# does it leave an unproblematic array unchanged?
	it "returns [[0,3,4],[7,0,9],[3,3,0]] when called on [[0,3,4],[7,0,9],[3,3,0]]" do
		matrix = [[0,3,4],[7,0,9],[3,3,0]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq([[0,3,4],[7,0,9],[3,3,0]])
	end

	# does it work when there are many rows to fix?
	it "returns	[[0,7],[0,9],[2,0],[1,0],[1,0],[0,35],[0,23],[0,9],[4,0]] when called on 
		[[0,7],[0,9],[0,2],[0,1],[0,1],[0,35],[0,23],[0,9],[0,4]]" do
		matrix = [[0,7],[0,9],[0,2],[0,1],[0,1],[0,35],[0,23],[0,9],[0,4]]
		expect(matrix.fix_too_many_lonely_zeros_in_columns).to eq([[0,7],[0,9],[2,0],[1,0],[1,0],[0,35],[0,23],[0,9],[4,0]])
	end

end

describe Array, ".get_problematic_rows_per_problematic_column" do
	# called on Array object; outputs array of arrays [n,m,o] where n is the index of a column with too many lonely zeros
	# m is the number of lonely zero's in column n
	# and o is an ORDERED array that contains arrays [p,q] where p is a row index of a lonely zero in column n, 
	# and q is the min value in that row other than zero, ordered by ascending q value
	
	# test with one problematic column, when rows are in order of min-sans-zero
	it "returns [[0,2,[[0,1],[1,3]]] when called on [[0,1,9],[0,3,3],[0,6,0]]" do
		matrix = [[0,1,9],[0,3,3],[0,6,0]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([[0,2,[[0,1],[1,3]]]])
	end

	# test same array as above, but add a row to increase the max_col_assignment for the array
	# this will eliminate all the previously problematic columns
	it "returns [] when called on [[0,1,9],[0,3,3],[0,6,0],[4,5,6]]" do
		matrix = [[0,1,9],[0,3,3],[0,6,0],[4,5,6]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([])
	end

	# test it on an array that is solveable
	it "returns [] when called on [[0,1,4],[5,7,0],[9,0,9]]" do
		matrix = [[0,1,4],[5,7,0],[9,0,9]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([])
	end

	# case where there are no lonely zeros in the matrix at all
	it "returns [] when called on [[0,1,0],[0,7,0],[0,7,0]]" do
		matrix = [[0,1,0],[0,7,0],[0,7,0]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([])
	end

	# case where multiple columns have too many lonely zeros, order is not being checked yet
	it "returns [[[0,2,[[0,2],[2,5]]],[3,3,[[1,3],[3,7],[4,8]]] when called on 
		[[0,5,4,3,2,9,10,17],[8,9,3,0,4,4,44,49],[0,5,5,5,5,5,55,52],[7,7,7,0,7,7,88,81],[8,8,8,0,8,8,8,777]]" do
		matrix = [[0,5,4,3,2,9,10,17],[8,9,3,0,4,4,44,49],[0,5,5,5,5,5,55,52],[7,7,7,0,7,7,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([[0,2,[[0,2],[2,5]]],[3,3,[[1,3],[3,7],[4,8]]]])
	end

	# case where multiple columns have too many lonely zeros, checking for correct matrix order
	it "returns [[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]] when called on 
		[[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]" do
		matrix = [[0,6,6,6,6,9,10,17],[9,9,9,0,9,9,44,49],[0,5,5,5,5,5,55,52],[17,17,17,0,17,17,88,81],[8,8,8,0,8,8,8,777]]
		expect(matrix.get_problematic_rows_per_problematic_column).to eq([[0,2,[[2,5],[0,6]]],[3,3,[[4,8],[1,9],[3,17]]]])
	end

end

describe Array, ".add_value_if_zero_else_subtract_value_in_rows" do
	# called on Array object, takes row index and value as inputs
	# outputs Array in which the value provided has been added to each zero and subtracted otherwise

	it "returns [[3,3,0,1,2,6]] when run on [[0,0,3,4,5,9]] and passed 0 and 3" do
		matrix = [[0,0,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(0, 3)).to eq([[3,3,0,1,2,6]])
	end

	it "returns [[5,0,2,3,4,8]] when run on [[6,1,3,4,5,9]] and passed 0 and 1" do
		matrix = [[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(0, 1)).to eq([[5,0,2,3,4,8]])
	end

	it "returns [[6,1,3,4,5,9]] when run on [[6,1,3,4,5,9]] and passed 1 and 1" do
		matrix = [[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(1, 1)).to eq([[6,1,3,4,5,9]])
	end

	it "returns [[6,1,3,4,5,9]] when run on [[6,1,3,4,5,9]] and passed 100 and 1" do
		matrix = [[6,1,3,4,5,9]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(100, 1)).to eq([[6,1,3,4,5,9]])
	end

	it "returns [[6,1,3,4,5,9],[1,0,4,5,0,4]] when run on [[6,1,3,4,5,9],[5,4,0,9,4,0]] and passed 1 and 4" do
		matrix = [[6,1,3,4,5,9],[5,4,0,9,4,0]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(1, 4)).to eq([[6,1,3,4,5,9],[1,0,4,5,0,4]])
	end

	it "returns [[6,1,3,4,5,9],[0,4,1,4,4,4],[5,4,0,9,4,0]] when run on [[6,1,3,4,5,9],[4,0,5,0,0,0],[5,4,0,9,4,0]] and passed 1 and 4" do
		matrix = [[6,1,3,4,5,9],[4,0,5,0,0,0],[5,4,0,9,4,0]]
		expect(matrix.add_value_if_zero_else_subtract_value_in_rows(1, 4)).to eq([[6,1,3,4,5,9],[0,4,1,4,4,4],[5,4,0,9,4,0]])
	end
end



describe Array, ".solveable?" do
	# called on Array object; returns failure code if the matrix-array has no solution in its current state, 
	# returns true if the matrix-array passes the tests

	# this matrix is not solveable; once lonely zeros are assigned, no assignment can be made in row 7
	# Here is the original array before make_matrix_solveable is called on it:
		# [6, 2, 2, 6, 4, 7, 3],[2, 6, 6, 6, 9, 2, 5],[6, 2, 4, 1, 2, 3, 1],[1, 5, 6, 5, 8, 2, 5],
		# [2, 3, 1, 8, 9, 1, 5],[1, 9, 4, 8, 7, 7, 2],[5, 6, 9, 8, 9, 6, 3],[7, 1, 6, 7, 6, 6, 1],
		# [5, 4, 2, 8, 8, 2, 2],[3, 2, 5, 9, 5, 6, 3],[7, 3, 1, 8, 9, 5, 6],[9, 7, 1, 1, 4, 9, 8],[9, 5, 3, 8, 5, 1, 6]
	it "does not return 'yes' when called on an unsolveable array with uneven rows/columns" do
		matrix = [[4,0,0,4,1,5,1],[0,4,4,4,6,0,3],[5,1,3,0,0,2,0],[0,4,5,4,6,1,4],[1,2,0,7,7,0,4],[0,8,3,7,5,6,1],
			[2,3,6,5,5,3,0],[6,0,5,6,4,5,0],[3,2,0,6,5,0,0],[1,0,3,7,2,4,1],[6,2,0,7,7,4,5],[8,6,0,0,2,8,7],[8,4,2,7,3,0,5]]
		expect(matrix.solveable?).to_not eq("true")
	end

	it "returns true when run on [[0,0,0],[4,0,6],[0,0,0]]" do
		matrix = [[0,0,0],[4,0,6],[0,0,0]]
		expect(matrix.solveable?).to eq("true")
	end

	it "returns failure code when run on [[1,2],[1,2]]" do
		matrix = [[1,2],[1,2]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns true when run on [[0,0,0],[0,9,0],[0,7,8]]" do
		matrix = [[0,0,0],[0,9,0],[0,7,8]]
		expect(matrix.solveable?).to eq("true")
	end

	it "returns failure code when run on [[0,3,0],[0,5,0],[0,1,0]]" do
		matrix = [[0,3,0],[0,5,0],[0,1,0]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns failure code when run on [[5,0,3],[4,0,2],[8,0,8]]" do
		matrix = [[5,0,3],[4,0,2],[8,0,8]]
		expect(matrix.solveable?).to eq("no, too many lonely zeros in columns")
	end

	# this is an interesting case, it has too many loney zeros in column 1, and too many lonely zeros in row 1
	it "returns failure code when run on [[4,0,1],[0,7,0],[9,0,2]]" do
		matrix = [[4,0,1],[0,7,0],[9,0,2]]
		expect(matrix.solveable?).to eq("no, too many lonely zeros in columns")
	end

	it "returns failure code when run on [[1,0,1,0,5,6],[6,7,1,0,1,0],[1,0,3,9,1,0],[2,6,1,0,1,8]]" do
		matrix = [[1,0,1,0,5,6],[6,7,1,0,1,0],[1,0,3,9,1,0],[2,6,1,0,1,8]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns failure code when run on [[1,0,1,9,5,6,9],[6,7,1,0,1,9,23],[1,9,3,0,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]" do
		matrix = [[1,0,1,9,5,6,9],[6,7,1,0,1,9,23],[1,9,3,0,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]
		expect(matrix.solveable?).to eq("no, too many lonely zeros in columns")
	end

	it "returns failure code when run on [[1,7,1,3,5,6,9],[6,7,1,5,1,5,23],[1,3,3,9,1,9,6],[2,6,1,9,1,8,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = [[1,0,1,7,5,6,9],[6,7,1,0,1,0,23],[1,7,3,9,1,9,6],[2,6,1,9,1,0,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,0]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns failure code when run on [[1,6,1,2,0,0,0],[0,7,0,6,3,8,4],[1,1,3,1,0,0,0],[0,0,9,0,4,9,5],
				[5,1,1,1,0,0,0],[6,0,0,8,7,9,4],[9,23,6,2,0,0,9]]" do
		matrix = [[1,6,1,2,0,0,0],[0,7,0,6,3,8,4],[1,1,3,1,0,0,0],[0,0,9,0,4,9,5],
				[5,1,1,1,0,0,0],[6,0,0,8,7,9,4],[9,23,6,2,0,0,9]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end

	it "returns failure code when run on [[1,6,1,2],[0,7,0,6],[1,1,3,1],[0,0,9,0],[5,1,1,1],[6,0,0,8],[9,23,6,2]]" do
		matrix = [[1,6,1,2],[0,7,0,6],[1,1,3,1],[0,0,9,0],[5,1,1,1],[6,0,0,8],[9,23,6,2]]
		expect(matrix.solveable?).to eq("no, min permitted row assignments > max column assignments possible")
	end	

	it "returns failure code when run on array that does not have enough zeros in a certain row to meet the min_row_assignment" do
		array = [[1,2],[0,0]]
		expect(array.solveable?).to eq("no, not enough zeros in rows")
	end

	it "returns failure code when run on array that does not have enough zeros in a certain row to meet the min_row_assignment" do
		array = [[6,0,0,0,0,0],[0,5,6,7,9,3],[4,0,0,0,0,0]]
		expect(array.solveable?).to eq("no, not enough zeros in rows")
	end

	it "returns failure code when run on array that does not have enough zeros in a certain column to meet the min_col_assignment" do
		array = [[1,0],[2,0]]
		expect(array.solveable?).to eq("no, not enough zeros in columns")
	end

	it "returns failure code when run on array that does not have enough zeros in a certain column to meet the min_col_assignment" do
		array = [[6, 0, 4], [0, 5, 0], [0, 6, 0], [0, 7, 0], [0, 9, 0], [0, 3, 0]]
		expect(array.solveable?).to eq("no, not enough zeros in columns")
	end


	# min_row_assmts_permitted > max_column_assmts_possible for any submatrix

# next test some matrices that will allow for multiple assignments in rows, then in columns

end
