--[[
Copyright (c) 2013 crosslife <hustgeziyang@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

require "Script/Config/CommonDefine"

GameBoard = {}
GameBoard[1] = {}
GameBoard[2] = {}
GameBoard[3] = {}
GameBoard[4] = {}
GameBoard[5] = {}
GameBoard[6] = {}
GameBoard[7] = {}

--初始化棋盘数据
function initGameBoard()
	for	x = 1, 7 do
		for y = 1, 7 do
			math.randomseed(math.random(os.time()))
			GameBoard[x][y] = math.random(7)
		end
	end
end

--触摸点转化为棋盘格子点
function touchPointToCell(x, y)
	local cellX = math.modf((x - GLeftBottomOffsetX) / GCellWidth)
	local cellY = math.modf((y - GLeftBottomOffsetY) / GCellWidth)
	local cell = {}
	cell.x = cellX + 1
	cell.y = cellY + 1

	if cell.x > GBoardSizeX then
		cell.x = GBoardSizeX
	end

	if cell.y > GBoardSizeY then
		cell.y = GBoardSizeY
	end

	return cell
end

--获取某个格子的中心坐标
function getCellCenterPoint(cell)
	local point = {}
	point.x = (cell.x - 1) * GCellWidth + GLeftBottomOffsetX + GCellWidth / 2
	point.y = (cell.y - 1) * GCellWidth + GLeftBottomOffsetY + GCellWidth / 2

	return point
end

--检查两个格子是否相邻
function isTwoCellNearby(cellA, cellB)
	local ret = false
	if (math.abs(cellA.x - cellB.x) == 1 and cellA.y == cellB.y) or
	   (math.abs(cellA.y - cellB.y) == 1 and cellA.x == cellB.x) then
		ret = true
	end	
	return ret
end

--检查某个格子是否组成3连,根据GameBoard数据
function checkCell(cell)
	local x = cell.x
	local y = cell.y

	local index = GameBoard[x][y]

	local ret = false
	if x > 1 and GameBoard[x-1][y] == index then
		if (x > 2 and GameBoard[x-2][y] == index) or (x < GBoardSizeX and GameBoard[x+1][y] == index) then
			cclog("left")
			ret = true
		end
	end

	if x < GBoardSizeX and GameBoard[x+1][y] == index then
		if (x < GBoardSizeX-1 and GameBoard[x+2][y] == index) or (x > 1 and GameBoard[x-1][y] == index) then
			cclog("right")
			ret = true
		end
	end

	if y > 1 and GameBoard[x][y-1] == index then
		if (y > 2 and GameBoard[x][y-2] == index) or (y < GBoardSizeY and GameBoard[x][y+1] == index) then
			cclog("down")
			ret = true
		end
	end

	if y < GBoardSizeY and GameBoard[x][y+1] == index then
		if (y < GBoardSizeY-1 and GameBoard[x][y+2] == index) or (y > 1 and GameBoard[x][y-1] == index) then
			cclog("up")
			ret = true
		end
	end
	return ret
end
