# Modified hungarian algorithm to find matches
# array_to_solve.hungarian == solution_array
# array_to_solve is an array of arrays--i.e. a matrix in array form
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

	# subtracts the lowest value in each column from each member of that column
	col_list = Array.new(columns) { Array.new(rows)}
	WORKING_MATRIX.each do |r|
		r.each do |index, value|
			col_list[index] << value
		end
	end

JUST USE MATRICES! Tells you how to access matrix values, AND change them: http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/


end


# Helper methods
def number_columns
	self[0].length
end

def column
	columns = []
	self.each do |row|


def column[number]
	column_contents = []
	self.each do |row|
		column_contents << row[number]
	end
	return column_contents
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


