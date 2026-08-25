local board = require("src.board")

local game = {}
local progression = { "B", "I", "N", "G", "O" }
local computerMistakeChance = 0.35

local function makeNumberPool()
	local numbers = {}
	for number = 1, 25 do numbers[number] = number end
	return numbers
end

local function getCell(cells, row, column)
	return cells[row] and cells[row][column]
end

local function completedLines(cells)
	local lines = {}
	for row = 1, 5 do
		local complete = true
		for column = 1, 5 do
			if not cells[row][column].marked then complete = false break end
		end
		if complete then table.insert(lines, "row" .. row) end
	end
	for column = 1, 5 do
		local complete = true
		for row = 1, 5 do
			if not cells[row][column].marked then complete = false break end
		end
		if complete then table.insert(lines, "column" .. column) end
	end
	return lines
end

local function updateProgress(state, cells, progress)
	local known = {}
	for _, line in ipairs(progress) do known[line] = true end
	for _, line in ipairs(completedLines(cells)) do
		if not known[line] then
			table.insert(progress, line)
			known[line] = true
		end
	end
end

local function scoreNumber(cells, number)
	local score = 0

	for row = 1, 5 do
		for column = 1, 5 do
			if cells[row][column].number == number then
				local rowMarks = 0
				for currentColumn = 1, 5 do
					if cells[row][currentColumn].marked then rowMarks = rowMarks + 1 end
				end
				if rowMarks == 4 then score = score + 1000 end
				score = score + rowMarks * rowMarks

				local columnMarks = 0
				for currentRow = 1, 5 do
					if cells[currentRow][column].marked then columnMarks = columnMarks + 1 end
				end
				if columnMarks == 4 then score = score + 1000 end
				score = score + columnMarks * columnMarks
				return score
			end
		end
	end

	return 0
end

local function chooseGreedyNumber(state, available)
	if math.random() < computerMistakeChance then
		return available[math.random(#available)]
	end

	local bestScore = -1
	local bestNumbers = {}

	for _, number in ipairs(available) do
		local score = scoreNumber(state.computerBoard, number)
		if score > bestScore then
			bestScore = score
			bestNumbers = { number }
		elseif score == bestScore then
			table.insert(bestNumbers, number)
		end
	end

	return bestNumbers[math.random(#bestNumbers)]
end

function game.new()
	return {
		playerBoard = board.create(),
		computerBoard = board.create(),
		numberPool = makeNumberPool(),
		calledNumbers = {},
		calledLookup = {},
		currentNumber = nil,
		computerNumber = nil,
		completedLines = {},
		computerCompletedLines = {},
		turn = "player",
		status = "playing",
		notice = nil,
	}
end

function game.playerCallAt(state, row, column)
	if state.status ~= "playing" or state.turn ~= "player" then return false end
	local cell = getCell(state.playerBoard, row, column)
	if not cell or state.calledLookup[cell.number] then return false end
	state.notice = nil
	state.currentNumber = cell.number
	state.calledLookup[cell.number] = true
	table.insert(state.calledNumbers, cell.number)
	board.markNumber(state.playerBoard, cell.number)
	board.markNumber(state.computerBoard, cell.number)
	updateProgress(state, state.playerBoard, state.completedLines)
	if state.status == "playing" then
		state.turn = "computer"
		game.computerCall(state)
	end
	return true
end

function game.callBingo(state)
	if state.status ~= "playing" or state.turn ~= "player" then return false end

	if #state.completedLines < 5 then
		state.notice = "Complete all five lines before calling BINGO."
		return false
	end

	state.status = "player_won"
	return true
end

function game.computerCall(state)
	if state.status ~= "playing" or state.turn ~= "computer" then return false end
	if #state.computerCompletedLines >= 5 then
		state.status = "computer_won"
		return true
	end
	local available = {}
	for _, number in ipairs(state.numberPool) do
		if not state.calledLookup[number] then table.insert(available, number) end
	end
	if #available == 0 then return false end
	local number = chooseGreedyNumber(state, available)
	state.computerNumber = number
	state.currentNumber = number
	state.calledLookup[number] = true
	table.insert(state.calledNumbers, number)
	board.markNumber(state.computerBoard, number)
	updateProgress(state, state.computerBoard, state.computerCompletedLines)
	state.turn = "player_mark"
	return true
end

function game.markComputerNumber(state, row, column)
	if state.status ~= "playing" or state.turn ~= "player_mark" then return false end
	local cell = getCell(state.playerBoard, row, column)
	if not cell or cell.number ~= state.computerNumber then return false end
	cell.marked = true
	state.notice = nil
	updateProgress(state, state.playerBoard, state.completedLines)
	if state.status == "playing" then state.turn = "player" end
	return true
end

function game.progress(state)
	return progression[math.min(#state.completedLines, #progression)] or "-"
end

return game
