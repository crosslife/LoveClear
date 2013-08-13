require "Script/Config/CommonDefine"

local function touchPointToCell(x, y)
	local cellX = math.modf((x - GLeftBottomOffsetX) / GCellWidth)
	local cellY = math.modf((y - GLeftBottomOffsetY) / GCellWidth)
	local cell = {}
	cell.x = cellX + 1
	cell.y = cellY + 1

	if cell.x > GBoardSizeX then
		cell.x = GBoardSizeX - 1
	end

	if cell.y > GBoardSizeY then
		cell.y = GBoardSizeY - 1
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

local function createBackLayer()
	local backLayer = CCLayer:create()

	local textureMenu = CCTextureCache:getInstance():addImage("imgs/game_bg.png")

	local visibleSize = CCDirector:getInstance():getVisibleSize()	
	rect = CCRect(0, 0, visibleSize.width, visibleSize.height)
    local menuFrame = CCSpriteFrame:createWithTexture(textureMenu, rect)

    local menuSprite = CCSprite:createWithSpriteFrame(menuFrame)
	menuSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)

	--set scale
	--menuSprite:setScaleX(visibleSize.width/frameWidth)
	backLayer:addChild(menuSprite)

    local function onTouchBegan(x, y)
		cclog("onTouchBegan: %0.2f, %0.2f", x, y)
		CCLuaLog("touch began...")
		local cell = touchPointToCell(x, y)
		cclog("touchCell: %d, %d", cell.x, cell.y)
		--SceneLoader:ChangeScene("game")
        -- CCTOUCHBEGAN event must return true
        return true
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        end
    end

    backLayer:registerScriptTouchHandler(onTouch)
    backLayer:setTouchEnabled(true)

	return backLayer
end

-- create main menu
function CreateGameScene()
   
	local scene = CCScene:create()
	scene:addChild(createBackLayer())

	AudioEngine.stopMusic(true)

	local bgMusicPath = CCFileUtils:getInstance():fullPathForFilename("Sound/bgm_game.wav")
    AudioEngine.playMusic(bgMusicPath, true)

	loadGameIcon()

	for cellY=1, 4 do
		for cellX = 1, 7 do
			local iconSprite = getGameIconSprite(cellY, cellX)
			local cell = {x = cellX, y = cellY}
			local cellPoint = getCellCenterPoint(cell)
			iconSprite:setPosition(ccp(cellPoint.x, cellPoint.y))
			scene:addChild(iconSprite)
		end
	end

    return scene
end