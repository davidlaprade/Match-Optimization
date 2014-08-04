# Modified hungarian algorithm to find matches
# Matrix_to_solve.hungarian == solution_array
# solution_array is a set of ordered pairs (n, m) such that n is the number of a row in matrix_to_solve and m is the assignment in that row
# solution_array.measure will add all of the values of the assignments in the solution

# for array reference: http://www.ruby-doc.org/core-2.1.2/Array.html

def hungarian
	# going to use an array so that values can be added/removed and accessed
	ORIGINAL_MATRIX = self
	# makes a copy of the self array
	WORKING_MATRIX = Array.new(self)

	# ensure self array has same number of elements in each row...
	# ensure self array has only integers in each row, and that each row contains each integer...

	# want to create an empty array the same size as the original
	columns = ORIGINAL_MATRIX.number_columns
	rows = ORIGINAL_MATRIX.number_rows
	ASSIGNING_MATRIX = Array.new(rows) { Array.new(columns) }

	# for now, make these pre-set; later have them input by user
	# ceil rounds a float up to the nearest integer
	max_row_assignment = 1
	min_row_assignment = 1
	max_col_assignment = (rows/columns).ceil
	min_col_assignment = 1

	# subtracts the lowest value in each row from each member of that row
	WORKING_MATRIX.each do |row|
		min = row.min
		row.each do |cell|
			cell = cell - min
		end
	end
	Doesn't work in IRB for some reason!





end


# Helper methods
def number_columns
	self[0].length
end

def number_rows
	self.length
end

def measure
	SUM = 0
	self.each do |index, value|
		SUM = SUM + value
	end
	return SUM
end


