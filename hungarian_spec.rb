# to use: navigate to the directory of this file in the terminal, then type "rspec <file name here>"

$LOAD_PATH << '.'
require 'testing'

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
end
