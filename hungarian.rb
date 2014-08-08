# Modified hungarian algorithm to optimize matches
# for matrix reference http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/

# see http://www.tutorialspoint.com/ruby/ruby_modules.html under "Ruby require statement" to see how this works
$LOAD_PATH << '.'
require 'matrix'
require 'matrix_class_additions'


def hungarian
	# these assignments are going to pose problems for the following reason: http://stackoverflow.com/questions/6712298/dynamic-constant-assignment
	ORIGINAL_MATRIX = self
	WORKING_MATRIX = self.clone
	ASSIGNING_MATRIX = Matrix.build(self.row_count, self.column_count) {}

	# ensure self matrix has same number of elements in each row...
	# ensure self matrix has only integers in each row, and that each row contains each integer...

	# first two steps of algorithm
	if WORKING_MATRIX.row_count >= WORKING_MATRIX.column_count
		WORKING_MATRIX.zero_each_row
		WORKING_MATRIX.zero_each_column
	else
		WORKING_MATRIX.zero_each_column
		WORKING_MATRIX.zero_each_row
	end

	# third step in algorithm
		# is the Working Matrix solvable?
		if WORKING_MATRIX.solveable? == false


			# resolve problematic rows if they exist

		end

	# fourth step in algorithm
		# make assignments usin ASSIGNING MATRX



	# returns an array containing coordinates of each zero that lies in a row with the minimum number of assinable zeros
	def lonely_zeros_in_rows
	# returns an array containing coordinates of each zero that lies in a column with the minimum number of assinable zeros
	def lonely_zeros_in_columns
	# returns false if the matrix has no solution in its current state, nil if the matrix passes the test
	def solveable?
	# returns an array of indices of rows with zeros in the specified column index
	def rows_with_zeros_in_column(column_index)
	# outputs array of column indexes such that each column contains more zeros than could be assigned in that column
	def columns_over_max
	# counts number of cells with the given value in a row or column, must call on Vector
	def count_with_value(value)
	# subtracts the lowest value in each row from each member of that row, must call on Matrix
	def zero_each_row
	# subtracts the lowest value in each column from each member of that column, must call on Matrix
	def zero_each_column
	# returns an array of the rows in the Matrix it's called on
	def rows
	# returns an array of the columns in the Matrix it's called on
	def columns




# JUST USE MATRICES! Tells you how to access matrix values, AND change them: http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
# 	matrix.clone = creates a new matrix identical to the old one, not just a new name
# 	matrix.row_count = number of rows
# 	matrix.column_count = number of columns
# 	matrix.row(j) = outputs j-th row in matrix
# 	matrix.row(j)[k] = outputs the k-th element in the j-th row, i.e. row j column k
# 	matrix[j,k] = outputs element in the j-th row, in the kth column
# 	matrix.column(k) = outputs k-th column
# 	matrix.to_a = converts matrix into an array of arrays
# 	matrix.send( :[]=,j,k,m) = saves value m to the cell in row j, column k
# 	matrix.row(k).min = returns the minimum value in the kth row; use the same method on columns
# 	matrix.row(k).max = returns the max value in the kth row; use the same method on columns
# 	m.row(k).each_with_index do |value, index| = iterates through each index/value pair in row k, index must be listed second



end


#--------------------- HELPER METHODS-----------------------------------------------------

class Vector
	# counts number of cells with the given value in a row or column
	def count_with_value(value)
		count = 0
			self.each do |cell|
				count = (count + 1) unless (cell != value)
			end
		return count
	end

end

# Eventually you're going to want to add this to a new document titled "matrix_class_additions"
class Matrix
	# allows you to change values in matrix, see http://www.fmendez.com/blog/2013/04/09/working-with-the-ruby-matrix-class/
	def []=(row, column, value)
		@rows[row][column] = value
	end

	# CONSTRAINTS
	def max_col_assignment 
		# ceil rounds a float up to the nearest integer
		(self.row_count.fdiv(self.column_count)).ceil
	end

	def max_row_assignment
		# ceil rounds a float up to the nearest integer
		(self.column_count.fdiv(self.row_count)).ceil
	end

	def min_row_assignment
		return 1
	end

	def min_col_assignment
		return 1
	end

	# returns an array of the rows (data type: vectors) in the Matrix it's called on
	def rows
		row_index = 0
		rows = []
		while row_index < self.row_count
			rows << self.row(row_index)
			row_index = row_index + 1
		end
		return rows
	end

	# returns an array of the columns (data type: vectors) in the Matrix it's called on
	def columns
		col_index = 0
		columns = []
		while col_index < self.column_count
			columns << self.column(col_index)
			col_index = col_index + 1
		end
		return columns
	end


	# returns an array of indices of rows with zeros in the specified column index
	def rows_with_zeros_in_column(column_index)
		rows = []
		self.rows.each_with_index do |row, index|
			if row[column_index] == 0
				rows << index
			end
		end
		return rows
	end

	#returns an array of arrays [n, m] where n is the column index and m is the number of zeros
	def zeros_per_column
		result = []
		self.columns.each_with_index do |column, index|
			result << [index, self.column(index).count_with_value(0)]
		end
		return result
	end

	# outputs array of column indexes for whatever columns contain more zeros than could be assigned in that column
	def columns_over_max
		columns_over = []
		self.zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				columns_over << array[0]
			end
		end
		return columns_over
	end

	# subtracts the lowest value in each row from each member of that row
	def zero_each_row
		self.rows.each_with_index do |row, row_index|
			min = row.min
			row.each_with_index do |value, col_index|
				self.send( :[]=,row_index,col_index,value-min )
			end
		end
		return self
	end

	# subtracts the lowest value in each column from each member of that column
	def zero_each_column
		self.columns.each_with_index do |column, column_index|
			min = column.min
			column.each_with_index do |value, row_index|
				self.send( :[]=,row_index,col_index,value-min )
			end
		end
		return self
	end

	# returns an array of coordinates [n,m] of every lonely zero
	# a lonely zero is one which occurs as the sole zero in EITHER its row or its column
	# number of lonely zeros
	def lonely_zeros
		zeros = []
		self.rows.each_with_index do |row, row_index|
			row.each_with_index do |cell, col_index|
				if cell == 0 && (self.row(row_index).count_with_value(0) == 1 || self.column(col_index).count_with_value(0) == 1)
					zeros << [row_index, col_index]
				end
			end
		end
		return zeros
	end

	# returns an array of arrays [n,m] where n is the column index and m is the number of lonely zeros in the column
	def lonely_zeros_per_column
		zeros_per_column = []
		self.columns.each_with_index do |column, col_index|
			zeros = 0
			self.lonely_zeros.each do |array|
				if array[1] == col_index
					zeros = zeros + 1
				end
			end
			zeros_per_column << [col_index, zeros]
		end
		return zeros_per_column
	end

	# returns an array of arrays [n,m] where n is the column index and m is the number of lonely zeros in the column
	def lonely_zeros_per_row
		zeros_per_row = []
		self.rows.each_with_index do |row, row_index|
			zeros = 0
			self.lonely_zeros.each do |array|
				if array[0] == row_index
					zeros = zeros + 1
				end
			end
			zeros_per_row << [row_index, zeros]
		end
		return zeros_per_row
	end

	# returns false if the matrix has no solution in its current state, nil if the matrix passes the tests
	def solveable?
		# checks to see if there are too many lonely zeros in any column
		self.lonely_zeros_per_column.each do |array|
			if array[1] > self.max_col_assignment
				return "false - too many lonely zeros per column"
			end
		end

		# checks to see if there are too many lonely zeros in any row
		self.lonely_zeros_per_row.each do |array|
			if array[1] > self.max_row_assignment
				return "false - too many lonely zeros per row"
			end
		end
	end


	first count min row assignments allowable, e.g. num_rows x min_row_assignment
	second, count max column assignemnts possible
		count zeros in each column, assign up to the max_col_assignment
	if the first number is greater than the second, the matrix isn't solveable

	then look for the inverse property for rows

end

