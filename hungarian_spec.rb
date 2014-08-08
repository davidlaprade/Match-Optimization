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

	it "returns false when run on Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]" do
		matrix = Matrix[[1,0,1,0,5,6,9],[6,7,1,0,1,0,23],[1,0,3,9,1,0,6],[2,6,1,0,1,8,2],[0,3,0,4,0,7,0],
					[0,8,0,9,0,9,0],[0,4,0,5,0,4,9]]
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

end
