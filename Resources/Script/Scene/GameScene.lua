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

require "Script/Logic/GameBoardLogic"

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

--初始化棋盘图标
local function initGameBoardIcon()
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

--重置之前选中棋子的选中状态
local function resetSelectGameIcon()
	if curSelectTag ~= nil then
		local cellNode = scene:getChildByTag(NODE_TAG_START + curSelectTag)
		if cellNode ~= nil then
			local normalSprite = cellNode:getChildByTag(NORMAL_TAG)
			local selectSprite = cellNode:getChildByTag(SELECT_TAG)
			if normalSprite ~= nil then 
				normalSprite:setVisible(true)
			end 

			if selectSprite ~= nil then
				selectSprite:setVisible(false)
			end
		end
		curSelectTag = nil
	end
end

--点击棋子更换图标效果
local function onClickGameIcon(cell)
	resetSelectGameIcon()

	curSelectTag = 10 * cell.x + cell.y

	scene:getChildByTag(NODE_TAG_START + curSelectTag):getChildByTag(NORMAL_TAG):setVisible(false)
	scene:getChildByTag(NODE_TAG_START + curSelectTag):getChildByTag(SELECT_TAG):setVisible(true)

	AudioEngine.playEffect("Sound/A_select.wav")
end

--交换相邻棋子
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
	GameBoard[cellA.x][cellA.y], GameBoard[cellB.x][cellB.y] = GameBoard[cellB.x][cellB.y], GameBoard[cellA.x][cellA.y]
	AudioEngine.playEffect("Sound/A_combo1.wav")
	
end

--不可移动的棋子
local function falseMoveCell(cellA, cellB)
	isTouching = false

	resetSelectGameIcon()

	local tagA = 10 * cellA.x + cellA.y
	local tagB = 10 * cellB.x + cellB.y

	local cellPointA = getCellCenterPoint(cellA)
	local cellPointB = getCellCenterPoint(cellB)

	local nodeA = scene:getChildByTag(NODE_TAG_START + tagA)
	local nodeB = scene:getChildByTag(NODE_TAG_START + tagB)

	local function roundMove(node, nowPoint, desPoint)
		local arrayOfActions = CCArray:create()			
		local moveForward = CCMoveTo:create(0.1, CCPoint(desPoint.x, desPoint.y))
		local moveBack = CCMoveTo:create(0.1, CCPoint(nowPoint.x, nowPoint.y))	

		arrayOfActions:addObject(moveForward)
		arrayOfActions:addObject(moveBack)

		local sequence = CCSequence:create(arrayOfActions)

		if node ~= nil then
			node:runAction(sequence)
		end		
	end

	roundMove(nodeA, cellPointA, cellPointB)
	roundMove(nodeB, cellPointB, cellPointA)
	AudioEngine.playEffect("Sound/A_falsemove.wav")
end

--背景层
local function createBackLayer()
	local backLayer = CCLayer:create()

	local backSprite = CCSprite:create("imgs/game_bg.png")

	backSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)

	backLayer:addChild(backSprite)

	return backLayer
end

--触摸层
local function createTouchLayer()

	local touchColor = Color4B:new(255, 255, 255 ,0)
	local touchLayer = CCLayerColor:create(touchColor)

	touchLayer:changeWidthAndHeight(visibleSize.width, visibleSize.height)

    local function onTouchBegan(x, y)
		--cclog("touchLayerBegan: %.2f, %.2f", x, y)
		isTouching = true
		touchStartPoint = {x = x, y = y}
		touchStartCell = touchPointToCell(x, y)
		if curSelectTag ~= nil then
			local curSelectCell = {x = math.modf(curSelectTag / 10), y = curSelectTag % 10}
			if (math.abs(curSelectCell.x - touchStartCell.x) == 1 and curSelectCell.y == touchStartCell.y)
			or (math.abs(curSelectCell.y - touchStartCell.y) == 1 and curSelectCell.x == touchStartCell.x) then					
				--模拟移动后数据
				GameBoard[curSelectCell.x][curSelectCell.y], GameBoard[touchStartCell.x][touchStartCell.y] = GameBoard[touchStartCell.x][touchStartCell.y], GameBoard[curSelectCell.x][curSelectCell.y]	

				local checkRet = checkCell(touchStartCell) or checkCell(curSelectCell)
				if checkRet == true then
					switchCell(curSelectCell, touchStartCell)
				else
					falseMoveCell(curSelectCell, touchStartCell)
				end		

				--还原数据，如果发生了移动，则移动内部已经互换了数据
				GameBoard[curSelectCell.x][curSelectCell.y], GameBoard[touchStartCell.x][touchStartCell.y] = GameBoard[touchStartCell.x][touchStartCell.y], GameBoard[curSelectCell.x][curSelectCell.y]	
				return true
			end	
		end
		

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
					--模拟移动后数据
					GameBoard[touchCurCell.x][touchCurCell.y], GameBoard[touchStartCell.x][touchStartCell.y] = GameBoard[touchStartCell.x][touchStartCell.y], GameBoard[touchCurCell.x][touchCurCell.y]	

					local checkRet = checkCell(touchStartCell) or checkCell(touchCurCell)
					if checkRet == true then
						switchCell(touchCurCell, touchStartCell)
					else
						falseMoveCell(touchCurCell, touchStartCell)
					end		

					--还原数据，如果发生了移动，则移动内部已经互换了数据
					GameBoard[touchCurCell.x][touchCurCell.y], GameBoard[touchStartCell.x][touchStartCell.y] = GameBoard[touchStartCell.x][touchStartCell.y], GameBoard[touchCurCell.x][touchCurCell.y]						
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
	initGameBoardIcon()

	scene:addChild(createTouchLayer(), 1000)

    return scene
end