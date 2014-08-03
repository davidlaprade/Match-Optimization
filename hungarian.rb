# Modified hungarian algorithm to find matches
# Matrix_to_solve.hungarian == solution_array
# solution_array is a set of ordered pairs (n, m) such that n is the number of a row in matrix_to_solve and m is the assignment in that row
# solution_array.measure will add all of the values of the assignments in the solution


def hungarian
	ORIGINAL_MATRIX = self.clone
	# want to create a new matrix the same size as the old one and fill it with zeros
	# http://stackoverflow.com/questions/15884376/ruby-2-0-how-to-access-element-in-matrix-by-coordinate
	ASSIGNING_MATRIX = Matrix.build(rows, columns) {0}




end

def measure
	SUM = 0
	self.each do |index, value|
		SUM = SUM + value
	end
	return SUM
end


