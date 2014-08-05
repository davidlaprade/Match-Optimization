require 'matrix'

m = Matrix[[1,2,3,4,5,5],[1,4,6,8,8,8]]

class Vector
def count_with_value(value)
	count = 0
		self.each do |cell|
			count = (count + 1) unless (cell != value)
		end
	return count
end
end

print m
print "\nrow(0).count_with_value(5) returns #{m.row(0).count_with_value(5)}\n"
print "m.row(1).count_with_value(8) returns #{m.row(1).count_with_value(8)}\n"
print "m.column(0).count_with_value(1) returns #{m.column(0).count_with_value(1)}\n"
print "m.column(1).count_with_value(4) returns #{m.column(1).count_with_value(4)}\n"
