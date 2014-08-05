# Modified hungarian algorithm to find matches
# array_to_solve.hungarian == solution_array
# array_to_solve is an array of arrays--i.e. a matrix in array form
# solution_array is a set of ordered pairs (n, m) such that n is the number of a row in matrix_to_solve and m is the assignment in that row
# solution_array.measure will add all of the values of the assignments in the solution

# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
require 'matrix'


def hungarian
	ORIGINAL_MATRIX = self
	# makes a copy of the input matrix
	WORKING_MATRIX = self.clone

	# ensure self matrix has same number of elements in each row...
	# ensure self matrix has only integers in each row, and that each row contains each integer...

	# want to create an empty matrix the same size as the original
	columns = ORIGINAL_MATRIX.column_count
	rows = ORIGINAL_MATRIX.row_count
	ASSIGNING_MATRIX = Matrix.build(rows, columns) {}

	# for now, make these pre-set; later have them input by user
	# ceil rounds a float up to the nearest integer
	max_row_assignment = 1
	min_row_assignment = 1
	max_col_assignment = (rows/columns).ceil
	min_col_assignment = 1

	# subtracts the lowest value in each row from each member of that row
	i = 0
	while i < rows do
		min = WORKING_MATRIX.row(i).min
		WORKING_MATRIX.row(i).each_with_index do |value, index|
			m.send( :[]=,i,index,value-min )
		end
		i = i + 1
	end
	
	# subtracts the lowest value in each column from each member of that column
	i = 0
	while i < columns do
		min = WORKING_MATRIX.column(i).min
		WORKING_MATRIX.column(i).each_with_index do |value, index|
			WORKING_MATRIX.send( :[]=,index,i,value-min )
		end
		i = i + 1
	end


	col_list = Array.new(columns) { Array.new(rows)}
	WORKING_MATRIX.each do |r|
		r.each do |index, value|
			col_list[index] << value
		end
	end

JUST USE MATRICES! Tells you how to access matrix values, AND change them: http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
	matrix.clone = creates a new matrix identical to the old one, not just a new name
	matrix.row_count = number of rows
	matrix.column_count = number of columns
	matrix.row(j) = outputs j-th row in matrix
	matrix.row(j)[k] = outputs the k-th element in the j-th row, i.e. row j column k
	matrix[j,k] = outputs element in the j-th row, in the kth column
	matrix.column(k) = outputs k-th column
	matrix.to_a = converts matrix into an array of arrays
	matrix.send( :[]=,j,k,m) = saves value m to the cell in row j, column k
	matrix.row(k).min = returns the minimum value in the kth row; use the same method on columns
	matrix.row(k).max = returns the max value in the kth row; use the same method on columns
	m.row(k).each_with_index do |value, index| = iterates through each index/value pair in row k, index must be listed second



end


# Helper methods
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

def measure
	SUM = 0
	self.each do |index, value|
		SUM = SUM + value
	end
	return SUM
end

# allows you to change values in matrix
# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
class Matrix
  def []=(row, column, value)
    @rows[row][column] = value
  end
end


