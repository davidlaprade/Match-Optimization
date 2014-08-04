# Modified hungarian algorithm to find matches
# Matrix_to_solve.hungarian == solution_array
# solution_array is a set of ordered pairs (n, m) such that n is the number of a row in matrix_to_solve and m is the assignment in that row
# solution_array.measure will add all of the values of the assignments in the solution

# for array reference: http://www.ruby-doc.org/core-2.1.2/Array.html

def hungarian
	# going to use an array, not a matrix so that values can be added/removed and accessed
	ORIGINAL_MATRIX = self
	WORKING_MATRIX = Array.new(self)

	# want to create an empty array the same size as the original
	rows = ORIGINAL_MATRIX[0].row_length
	columns = ORIGINAL_MATRIX.column_height
	ASSIGNING_MATRIX = Array.new(columns) { Array.new(rows) }




end


# Helper methods
def row_length
	self[0].length
end

def column_height
	self.length
end

def measure
	SUM = 0
	self.each do |index, value|
		SUM = SUM + value
	end
	return SUM
end


