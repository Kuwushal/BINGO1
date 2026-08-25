local game = require("src.game")
local ui = require("src.ui")

local state
local boardY = 205
local cellSize = 72
local playerX = 300
local bingoButtonX = 420
local bingoButtonY = 585
local bingoButtonWidth = 160
local bingoButtonHeight = 38

local function inside(x, y, left, top, width, height)
	return x >= left and x <= left + width and y >= top and y <= top + height
end

local function statusText()
	if state.status == "player_won" then return "YOU WIN - press R for a new sheet" end
	if state.status == "computer_won" then return "COMPUTER WINS - press R for a new sheet" end
	if state.notice then return state.notice end
	if state.turn == "player" then return "YOUR TURN - click an uncalled number to call it" end
	return "COMPUTER CALLED " .. state.computerNumber .. " - click it to cross it"
end

local function drawBoard(cells, x, y)
	ui.drawSheetFrame(x - 12, y - 12, cellSize * 5 + 24, cellSize * 5 + 24)
	local mouseX, mouseY = love.mouse.getPosition()

	for row = 1, 5 do
		for column = 1, 5 do
			local cell = cells[row][column]
			local cellX = x + (column - 1) * cellSize
			local cellY = y + (row - 1) * cellSize
			local isComputerCall = state.turn == "player_mark" and cell.number == state.computerNumber
			local canInteract = state.turn == "player" and not state.calledLookup[cell.number]
				or state.turn == "player_mark" and isComputerCall
			local isHovered = inside(mouseX, mouseY, cellX, cellY, cellSize, cellSize)
			if isHovered and canInteract then ui.setColor(ui.blue, 0.3)
			elseif cell.marked then ui.setColor(ui.highlight, 0.38)
			elseif isComputerCall then ui.setColor(ui.red, 0.25)
			else ui.setColor(ui.paper) end
			love.graphics.rectangle("fill", cellX, cellY, cellSize, cellSize)
			ui.setColor(isHovered and canInteract and ui.blue or (isComputerCall and ui.red or ui.graphite), 0.95)
			ui.drawSketchRect(cellX, cellY, cellSize, cellSize, isHovered and canInteract and 1 or 0.78)
			if cell.marked then
				ui.setColor(ui.blue, 0.8)
				love.graphics.line(cellX + 10, cellY + cellSize - 14, cellX + cellSize - 12, cellY + 13)
			end
			ui.setColor(ui.ink)
			ui.printf(tostring(cell.number), cellX, cellY + 24, cellSize, "center", 0, 1.25, 1.25)
		end
	end

	for _, line in ipairs(state.completedLines) do
		local rowNumber = tonumber(string.match(line, "^row(%d+)$"))
		local columnNumber = tonumber(string.match(line, "^column(%d+)$"))
		if rowNumber then
			local lineY = y + (rowNumber - 0.5) * cellSize
			ui.drawHighlightStroke(x + 8, lineY, x + cellSize * 5 - 8, lineY)
		else
			local lineX = x + (columnNumber - 0.5) * cellSize
			ui.drawHighlightStroke(lineX, y + 8, lineX, y + cellSize * 5 - 8)
		end
	end
end

function love.load()
	math.randomseed(os.time())
	state = game.new()
end

function love.draw()
	local width, height = love.graphics.getDimensions()
	ui.drawBackground(width, height)
	ui.setColor(ui.ink)
	ui.drawTitle(370, 18, 52, #state.completedLines)
	ui.setColor(ui.graphite)
	ui.printf(statusText(), 0, 60, width, "center")
	if state.notice then ui.drawNotice(75, 100, 300, state.notice) end
	ui.setColor(ui.ink)
	ui.print("PLAYER", playerX, boardY - 58)
	ui.print("YOUR SHEET", playerX, boardY - 36)
	ui.drawProgress(playerX + 390, boardY - 54, #state.completedLines)
	drawBoard(state.playerBoard, playerX, boardY)
	ui.print("COMPUTER BINGO", 760, 245)
	ui.drawProgress(790, 275, #state.computerCompletedLines)
	ui.drawCallStamp(width / 2, 130, state.currentNumber)
	ui.drawNumberLog(75, 245, state.calledNumbers)
	ui.setColor(ui.graphite)
	ui.printf("TURN " .. (#state.calledNumbers + 1), 0, 630, width, "center")
	ui.printf("LINES " .. #state.completedLines .. "/5    CALLED " .. #state.calledNumbers .. "/25", 0, 648, width, "center")

	local mouseX, mouseY = love.mouse.getPosition()
	local bingoHovered = inside(mouseX, mouseY, bingoButtonX, bingoButtonY, bingoButtonWidth, bingoButtonHeight)
	local bingoActive = state.turn == "player"
	ui.setColor(bingoActive and (bingoHovered and ui.red or ui.highlight) or ui.graphite, bingoActive and 1 or 0.35)
	love.graphics.rectangle("fill", bingoButtonX, bingoButtonY, bingoButtonWidth, bingoButtonHeight)
	ui.setColor(bingoActive and bingoHovered and ui.paper or ui.ink, bingoActive and 1 or 0.45)
	ui.drawSketchRect(bingoButtonX, bingoButtonY, bingoButtonWidth, bingoButtonHeight, bingoHovered and 1 or 0.75)
	ui.printf("CALL BINGO", bingoButtonX, bingoButtonY + 11, bingoButtonWidth, "center")
	ui.drawTab(390, height - 32, 105, "NEW GAME")
	ui.drawTab(507, height - 32, 90, "PAUSE")
	ui.drawTab(609, height - 32, 100, "SETTINGS")
end

function love.keypressed(key)
	if key == "r" then state = game.new() end
end

function love.mousepressed(x, y, button)
	if button ~= 1 then return end
	if x >= bingoButtonX and x <= bingoButtonX + bingoButtonWidth and y >= bingoButtonY and y <= bingoButtonY + bingoButtonHeight then
		game.callBingo(state)
		return
	end
	local column = math.floor((x - playerX) / cellSize) + 1
	local row = math.floor((y - boardY) / cellSize) + 1
	if row < 1 or row > 5 or column < 1 or column > 5 then return end
	if state.turn == "player" then
		game.playerCallAt(state, row, column)
	elseif state.turn == "player_mark" then
		game.markComputerNumber(state, row, column)
	end
end
