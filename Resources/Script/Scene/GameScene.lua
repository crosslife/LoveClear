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

local ICON_TAG_START = 10000
local SELECT_TAG_START = 20000

local touchStartPoint = {}
local touchEndPoint = {}

local touchStartCell = {}
local touchEndCell = {}

local visibleSize = CCDirector:getInstance():getVisibleSize()

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

local function getCellCenterPoint(cell)
	local point = {}
	point.x = (cell.x - 1) * GCellWidth + GLeftBottomOffsetX + GCellWidth / 2
	point.y = (cell.y - 1) * GCellWidth + GLeftBottomOffsetY + GCellWidth / 2

	return point
end

local function loadGameIcon()
	CCSpriteFrameCache:getInstance():addSpriteFramesWithFile("imgs/GameIcon.plist")
end

local function getGameIconSprite(type, index)
	local iconFrame = CCSpriteFrameCache:getInstance():getSpriteFrameByName("icon"..type..index..".png")
	local iconSprite = CCSprite:createWithSpriteFrame(iconFrame)
	return iconSprite
end

local function initGameBoard()
	for	x = 1, 7 do
		for y = 1, 7 do
			math.randomseed(math.random(os.time()))
			GameBoard[x][y] = math.random(7)
		end
	end

	for x=1, 7 do
		for y = 1, 7 do
			local iconNormalSprite = getGameIconSprite(1, GameBoard[x][y])
			local iconSelectSprite = getGameIconSprite(4, GameBoard[x][y])

			local cell = {x = x, y = y}
			local cellPoint = getCellCenterPoint(cell)

			iconNormalSprite:setPosition(CCPoint(cellPoint.x, cellPoint.y))
			iconNormalSprite:setTag(ICON_TAG_START + 10 * x + y)

			iconSelectSprite:setPosition(CCPoint(cellPoint.x, cellPoint.y))
			iconSelectSprite:setTag(SELECT_TAG_START + 10 * x + y)
			iconSelectSprite:setVisible(false)

			scene:addChild(iconNormalSprite)
			scene:addChild(iconSelectSprite)
		end
	end
end

local function onClickGameIcon(cell)
	local normalTag = ICON_TAG_START + 10 * cell.x + cell.y
	local selectTag = SELECT_TAG_START + 10 * cell.x + cell.y

	if curSelectTag ~= nil then
		scene:getChildByTag(ICON_TAG_START + curSelectTag):setVisible(true)
		scene:getChildByTag(SELECT_TAG_START + curSelectTag):setVisible(false)
	end

	curSelectTag = 10 * cell.x + cell.y

	scene:getChildByTag(ICON_TAG_START + curSelectTag):setVisible(false)
	scene:getChildByTag(SELECT_TAG_START + curSelectTag):setVisible(true)

	AudioEngine.playEffect("Sound/A_select.wav")
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
		cclog("touchLayerBegan: %.2f, %.2f", x, y)
		touchStartPoint = {x = x, y = y}
		touchStartCell = touchPointToCell(x, y)
        return true
    end

	local function onTouchMoved(x, y)
		cclog("touchLayerMoved: %.2f, %.2f", x, y)
		
    end

	local function onTouchEnded(x, y)
		cclog("touchLayerEnded: %.2f, %.2f", x, y)
		touchEndPoint = {x = x, y = y}
		touchEndCell = touchPointToCell(x, y)

		if touchEndCell.x == touchStartCell.x and touchEndCell.y == touchEndCell.y then
			onClickGameIcon(touchEndCell)
		end
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


-- create main menu
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