<<<<<<< HEAD
require("Script/Scene/GameScene")
=======

>>>>>>> 6b7426e8b6ab17eccd738ec001af65f2fa04f106

local visibleSize = CCDirector:getInstance():getVisibleSize()	
local origin = CCDirector:getInstance():getVisibleOrigin()

local function createBackLayer()
	local backLayer = CCLayer:create()

<<<<<<< HEAD
	local frameWidth = 712
    local frameHeight = 1024

	local textureMenu = CCTextureCache:getInstance():addImage("imgs/menu_bg.png")


	rect = CCRect(0, 0, frameWidth, frameHeight)
    local menuFrame = CCSpriteFrame:createWithTexture(textureMenu, rect)

    local menuSprite = CCSprite:createWithSpriteFrame(menuFrame)
	menuSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)
	backLayer:addChild(menuSprite)

    local function onTouchBegan(x, y)
		CCLuaLog("touch began...")
		CCDirector:getInstance():replaceScene(CreateGameScene())
=======
	--add background
	local bandlandSprite = CCSprite:create("imgs/badland.jpg")
    bandlandSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)
    backLayer:addChild(bandlandSprite)

    -- handing touch events
    local touchBeginPoint = nil

    local function onTouchBegan(x, y)
        touchBeginPoint = {x = x, y = y}
>>>>>>> 6b7426e8b6ab17eccd738ec001af65f2fa04f106
        -- CCTOUCHBEGAN event must return true
        return true
    end

<<<<<<< HEAD
    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
=======
    local function onTouchMoved(x, y)
        if touchBeginPoint then
            local cx, cy = backLayer:getPosition()
            backLayer:setPosition(cx + x - touchBeginPoint.x, cy + y - touchBeginPoint.y)
            touchBeginPoint = {x = x, y = y}
        end
    end

    local function onTouchEnded(x, y)
        touchBeginPoint = nil
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
        elseif eventType == "ended" then
            return onTouchEnded(x, y)
		else
			return onTouchEnded(x, y)
>>>>>>> 6b7426e8b6ab17eccd738ec001af65f2fa04f106
        end
    end

    backLayer:registerScriptTouchHandler(onTouch)
    backLayer:setTouchEnabled(true)

	return backLayer
end

-- create main menu
function CreateMenuScene()
   
	local scene = CCScene:create()
	scene:addChild(createBackLayer())

    return scene
end