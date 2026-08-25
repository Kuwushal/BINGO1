local ui = {}

ui.paper = { 0.91, 0.88, 0.78 }
ui.ink = { 0.16, 0.17, 0.16 }
ui.graphite = { 0.34, 0.34, 0.31 }
ui.blue = { 0.35, 0.48, 0.54 }
ui.red = { 0.65, 0.28, 0.25 }
ui.highlight = { 0.78, 0.59, 0.25 }

function ui.setColor(color, alpha)
	love.graphics.setColor(color[1], color[2], color[3], alpha or 1)
end

function ui.print(text, x, y)
	ui.setColor(ui.graphite, 0.18)
	love.graphics.print(text, x + 1, y + 1)
	ui.setColor(ui.ink, 0.86)
	love.graphics.print(text, x, y)
end

function ui.printf(text, x, y, width, align, rotation, scaleX, scaleY)
	rotation = rotation or 0
	scaleX = scaleX or 1
	scaleY = scaleY or 1
	ui.setColor(ui.graphite, 0.18)
	love.graphics.printf(text, x + 1, y + 1, width, align, rotation, scaleX, scaleY)
	ui.setColor(ui.ink, 0.86)
	love.graphics.printf(text, x, y, width, align, rotation, scaleX, scaleY)
end

local function pencilLine(x1, y1, x2, y2, alpha)
	local middleX = (x1 + x2) / 2
	local middleY = (y1 + y2) / 2
	love.graphics.line(x1, y1, middleX + 1.4, middleY - 0.7, x2, y2)
	ui.setColor(ui.graphite, alpha * 0.35)
	love.graphics.line(x1 + 1, y1 + 1, middleX - 0.8, middleY + 1.1, x2 - 1, y2 + 1)
end

function ui.drawSketchRect(x, y, width, height, alpha)
	ui.setColor(ui.graphite, alpha or 0.75)
	pencilLine(x, y, x + width, y, alpha or 0.75)
	pencilLine(x + width, y, x + width, y + height, alpha or 0.75)
	pencilLine(x + width, y + height, x, y + height, alpha or 0.75)
	pencilLine(x, y + height, x, y, alpha or 0.75)
end

function ui.drawHighlightStroke(x1, y1, x2, y2)
	love.graphics.setLineWidth(7)
	ui.setColor(ui.highlight, 0.42)
	pencilLine(x1, y1, x2, y2, 0.42)
	love.graphics.setLineWidth(1)
end

function ui.drawTitle(x, y, spacing, completed)
	local letters = { "B", "I", "N", "G", "O" }
	for index, letter in ipairs(letters) do
		ui.setColor(index <= completed and ui.highlight or ui.graphite, index <= completed and 1 or 0.45)
		ui.printf(letter, x + (index - 1) * spacing, y, 34, "center", 0, 1.7, 1.7)
	end
end

function ui.drawBackground(width, height)
	ui.setColor(ui.paper)
	love.graphics.rectangle("fill", 0, 0, width, height)

	ui.setColor(ui.blue, 0.12)
	for y = 32, height, 32 do
		love.graphics.line(0, y, width, y)
	end

	ui.setColor(ui.red, 0.35)
	love.graphics.line(72, 0, 72, height)

	ui.setColor(ui.graphite, 0.2)
	for x = 12, width, 47 do
		love.graphics.points(x, 18 + (x % 13))
	end
end

function ui.drawTab(x, y, width, label)
	ui.setColor(ui.paper)
	love.graphics.rectangle("fill", x, y, width, 30)
	ui.setColor(ui.graphite, 0.7)
	ui.drawSketchRect(x, y, width, 30, 0.7)
	ui.printf(label, x, y + 8, width, "center")
end

function ui.drawSheetFrame(x, y, width, height)
	ui.setColor(ui.graphite, 0.12)
	love.graphics.rectangle("fill", x + 5, y + 6, width, height)
	ui.setColor(ui.paper)
	love.graphics.rectangle("fill", x, y, width, height)
	ui.setColor(ui.graphite, 0.75)
	ui.drawSketchRect(x, y, width, height, 0.75)
	ui.setColor(ui.blue, 0.2)
	love.graphics.line(x + 8, y + 8, x + width - 8, y + 8)
	love.graphics.line(x + 8, y + height - 8, x + width - 8, y + height - 8)
end

function ui.drawNotice(x, y, width, text)
	ui.setColor(ui.red, 0.14)
	love.graphics.rectangle("fill", x, y, width, 30)
	ui.setColor(ui.red, 0.8)
	ui.drawSketchRect(x, y, width, 30, 0.8)
	ui.setColor(ui.red)
	ui.printf("!  " .. text .. "  !", x, y + 8, width, "center")
end

function ui.drawCallStamp(x, y, number)
	ui.setColor(ui.red, 0.12)
	love.graphics.circle("fill", x, y, 62)
	ui.setColor(ui.red, 0.8)
	love.graphics.circle("line", x, y, 62)
	love.graphics.circle("line", x + 2, y - 1, 58)
	ui.printf(number and tostring(number) or "--", x - 42, y - 24, 84, "center", 0, 1.8, 1.8)
	ui.setColor(ui.red)
	ui.printf("CALL", x - 45, y + 38, 90, "center")
end

function ui.drawProgress(x, y, completed)
	local letters = { "B", "I", "N", "G", "O" }

	for index, letter in ipairs(letters) do
		local active = index <= completed
		ui.setColor(active and ui.highlight or ui.graphite, active and 1 or 0.42)
		ui.printf(letter, x, y + (index - 1) * 29, 28, "center", 0, 1.2, 1.2)
		if active then
			love.graphics.line(x - 2, y + 23 + (index - 1) * 29, x + 29, y + 23 + (index - 1) * 29)
		end
	end
end

function ui.drawNumberLog(x, y, numbers)
	ui.setColor(ui.graphite)
	ui.print("NUMBER LOG", x, y)

	for index, number in ipairs(numbers) do
		local column = (index - 1) % 5
		local row = math.floor((index - 1) / 5)
		local circleX = x + 15 + column * 38
		local circleY = y + 38 + row * 34
		ui.setColor(ui.blue, 0.7)
		love.graphics.circle("line", circleX, circleY, 13)
		ui.setColor(ui.ink)
		ui.printf(tostring(number), circleX - 13, circleY - 6, 26, "center")
	end
end

return ui
