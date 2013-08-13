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




local function initGameBoard()
	for	x = 1, 7 do
		for y = 1, 7 do
			math.randomseed(math.random(os.time()))
			GameBoard[x][y] = math.random(7)
		end
	end

	local function onClickGameIcon(tag)
		cclog("click..."..tag)
		if curSelectTag ~= nil then
			cclog("unselected.."..curSelectTag)
			scene:getChildByTag(curSelectTag):getChildByTag(curSelectTag):unselected()
		end

		curSelectTag = tag
		scene:getChildByTag(curSelectTag):getChildByTag(curSelectTag):selected()

		AudioEngine.playEffect("Sound/A_select.wav")
	end

	for x=1, 7 do
		for y = 1, 7 do
			local iconNormalSprite = getGameIconSprite(1, GameBoard[x][y])
			local iconSelectSprite = getGameIconSprite(4, GameBoard[x][y])
			iconSelectSprite:setPosition(-6, -6)

			local iconMenuSprite = CCMenuItemSprite:create(iconNormalSprite, iconSelectSprite)
			--iconMenuSprite:setTag(100)
			iconMenuSprite:registerScriptTapHandler(onClickGameIcon)

			local iconMenu = CCMenu:create()
			iconMenu:addChild(iconMenuSprite, 10, 10 * x + y)
			 
			local cell = {x = x, y = y}
			local cellPoint = getCellCenterPoint(cell)
			iconMenu:setPosition(CCPoint(cellPoint.x, cellPoint.y))
			iconMenu:setTag(10 * x + y)

			scene:addChild(iconMenu)
		end
	end
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
		--cclog("onTouchBegan: %0.2f, %0.2f", x, y)
		--CCLuaLog("touch began...")
		local cell = touchPointToCell(x, y)
		cclog("touchCell: %d, %d", cell.x, cell.y)
		
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
   
	scene = CCScene:create()
	scene:addChild(createBackLayer())

	AudioEngine.stopMusic(true)

	local bgMusicPath = CCFileUtils:getInstance():fullPathForFilename("Sound/bgm_game.wav")
	AudioEngine.playMusic(bgMusicPath, true)

	--local readyMusicPath = CCFileUtils:getInstance():fullPathForFilename("Sound/A_ready.wav")
	--AudioEngine.playMusic(readyMusicPath, false)

	--AudioEngine.playEffect("Sound/A_ready.wav")

	--local effectSelectPath = CCFileUtils:getInstance():fullPathForFilename("Sound/A_select.wav")
	--AudioEngine.preloadEffect(effectSelectPath)

	loadGameIcon()

	initGameBoard()



    return scene
end