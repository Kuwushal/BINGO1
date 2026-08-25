local board = {}

local function shuffledNumbers()
	local numbers = {}

	for number = 1, 25 do
		numbers[number] = number
	end

	for index = #numbers, 2, -1 do
		local otherIndex = math.random(index)
		numbers[index], numbers[otherIndex] = numbers[otherIndex], numbers[index]
	end

	return numbers
end

function board.create()
	local numbers = shuffledNumbers()
	local cells = {}

	for row = 1, 5 do
		cells[row] = {}

		for column = 1, 5 do
			local cellNumber = (row - 1) * 5 + column
			cells[row][column] = {
				number = numbers[cellNumber],
				marked = false,
			}
		end
	end

	return cells
end

function board.markAt(cells, row, column)
	local cell = cells[row] and cells[row][column]

	if cell and not cell.free then
		cell.marked = not cell.marked
	end
end

function board.markNumber(cells, number)
	for row = 1, 5 do
		for column = 1, 5 do
			local cell = cells[row][column]

			if cell.number == number and not cell.free then
				cell.marked = true
			end
		end
	end
end

return board
