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

local GameBoard = {}
GameBoard[1] = {}
GameBoard[2] = {}
GameBoard[3] = {}
GameBoard[4] = {}
GameBoard[5] = {}
GameBoard[6] = {}
GameBoard[7] = {}

local scene = nil

local curSelectTag = nil

local NODE_TAG_START = 1000
local NORMAL_TAG = 10
local SELECT_TAG = 20

local isTouching = false

local touchStartPoint = {}
local touchEndPoint = {}

local touchStartCell = {}
local touchEndCell = {}

local visibleSize = CCDirector:getInstance():getVisibleSize()

--触摸点转化为棋盘格子点
local function touchPointToCell(x, y)
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
local function getCellCenterPoint(cell)
	local point = {}
	point.x = (cell.x - 1) * GCellWidth + GLeftBottomOffsetX + GCellWidth / 2
	point.y = (cell.y - 1) * GCellWidth + GLeftBottomOffsetY + GCellWidth / 2

	return point
end

--加载游戏图标资源
local function loadGameIcon()
	CCSpriteFrameCache:getInstance():addSpriteFramesWithFile("imgs/GameIcon.plist")
end

--获取某个棋子
local function getGameIconSprite(type, index)
	local iconFrame = CCSpriteFrameCache:getInstance():getSpriteFrameByName("icon"..type..index..".png")
	local iconSprite = CCSprite:createWithSpriteFrame(iconFrame)
	return iconSprite
end

--初始化棋盘
local function initGameBoard()
	for	x = 1, 7 do
		for y = 1, 7 do
			math.randomseed(math.random(os.time()))
			GameBoard[x][y] = math.random(7)
		end
	end

	for x=1, 7 do
		for y = 1, 7 do

			--每个节点创建两个sprite
			local iconNormalSprite = getGameIconSprite(1, GameBoard[x][y])
			local iconSelectSprite = getGameIconSprite(4, GameBoard[x][y])

			local cell = {x = x, y = y}
			local cellPoint = getCellCenterPoint(cell)

			iconNormalSprite:setTag(NORMAL_TAG)
			iconSelectSprite:setTag(SELECT_TAG)
			iconSelectSprite:setVisible(false)

			local iconNode = CCNode:create()
			iconNode:setTag(NODE_TAG_START + 10 * x + y)

			iconNode:addChild(iconNormalSprite)
			iconNode:addChild(iconSelectSprite)
			iconNode:setPosition(CCPoint(cellPoint.x, cellPoint.y))

			scene:addChild(iconNode)
		end
	end
end

local function resetSelectGameIcon()
	if curSelectTag ~= nil then
		scene:getChildByTag(NODE_TAG_START + curSelectTag):getChildByTag(NORMAL_TAG):setVisible(true)
		scene:getChildByTag(NODE_TAG_START + curSelectTag):getChildByTag(SELECT_TAG):setVisible(false)
		curSelectTag = nil
	end
end

local function onClickGameIcon(cell)
	resetSelectGameIcon()

	curSelectTag = 10 * cell.x + cell.y

	scene:getChildByTag(NODE_TAG_START + curSelectTag):getChildByTag(NORMAL_TAG):setVisible(false)
	scene:getChildByTag(NODE_TAG_START + curSelectTag):getChildByTag(SELECT_TAG):setVisible(true)

	AudioEngine.playEffect("Sound/A_select.wav")
end

local function switchCell(cellA, cellB)
	isTouching = false

	resetSelectGameIcon()

	local tagA = 10 * cellA.x + cellA.y
	local tagB = 10 * cellB.x + cellB.y

	local cellPointA = getCellCenterPoint(cellA)
	local cellPointB = getCellCenterPoint(cellB)

	local nodeA = scene:getChildByTag(NODE_TAG_START + tagA)
	local nodeB = scene:getChildByTag(NODE_TAG_START + tagB)

	local moveToB = CCMoveTo:create(0.1, CCPoint(cellPointB.x, cellPointB.y))
	local moveToA = CCMoveTo:create(0.1, CCPoint(cellPointA.x, cellPointA.y))	

	nodeA:runAction(moveToB)
	nodeB:runAction(moveToA)

	--update tag
	nodeA:setTag(NODE_TAG_START + tagB)
	nodeB:setTag(NODE_TAG_START + tagA)

	--update gameboard
	GameBoard[cellA.x][cellA.y], GameBoard[cellB.x][cellB.y] = GameBoard[cellB.x][cellB.y], GameBoard[cellB.x][cellB.y]
end

local function createBackLayer()
	local backLayer = CCLayer:create()

	local textureBack = CCTextureCache:getInstance():addImage("imgs/game_bg.png")

	local visibleSize = CCDirector:getInstance():getVisibleSize()	
	rect = CCRect(0, 0, visibleSize.width, visibleSize.height)
    local backFrame = CCSpriteFrame:createWithTexture(textureBack, rect)

    local backSprite = CCSprite:createWithSpriteFrame(backFrame)
	backSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)

	backLayer:addChild(backSprite)

	return backLayer
end

local function createTouchLayer()

	local touchColor = Color4B:new(255, 255, 255 ,0)
	local touchLayer = CCLayerColor:create(touchColor)

	touchLayer:changeWidthAndHeight(visibleSize.width, visibleSize.height)

    local function onTouchBegan(x, y)
		--cclog("touchLayerBegan: %.2f, %.2f", x, y)
		isTouching = true
		touchStartPoint = {x = x, y = y}
		touchStartCell = touchPointToCell(x, y)
		onClickGameIcon(touchStartCell)

        return true
    end

	local function onTouchMoved(x, y)
		--cclog("touchLayerMoved: %.2f, %.2f", x, y)
		local touchCurCell = touchPointToCell(x, y)
		if	isTouching then
			if touchCurCell.x ~= touchStartCell.x or touchCurCell.y ~= touchStartCell.y then
				if (math.abs(touchCurCell.x - touchStartCell.x) == 1 and touchCurCell.y == touchStartCell.y)
				or (math.abs(touchCurCell.y - touchStartCell.y) == 1 and touchCurCell.x == touchStartCell.x) then					
					switchCell(touchCurCell, touchStartCell)
				end				
			end
		end		
    end

	local function onTouchEnded(x, y)
		--cclog("touchLayerEnded: %.2f, %.2f", x, y)
		touchEndPoint = {x = x, y = y}
		touchEndCell = touchPointToCell(x, y)
		isTouching = false
    end


    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
		elseif eventType == "moved" then
			return onTouchMoved(x, y)
		elseif eventType == "ended" then
			return onTouchEnded(x, y)
        end
    end

    touchLayer:registerScriptTouchHandler(onTouch)
    touchLayer:setTouchEnabled(true)

	return touchLayer
end


-- create game scene
function CreateGameScene()
   
	scene = CCScene:create()
	scene:addChild(createBackLayer())

	AudioEngine.stopMusic(true)

	local bgMusicPath = CCFileUtils:getInstance():fullPathForFilename("Sound/bgm_game.wav")
	AudioEngine.playMusic(bgMusicPath, true)

	loadGameIcon()

	initGameBoard()

	scene:addChild(createTouchLayer(), 1000)

    return scene
end