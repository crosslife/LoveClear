require("Script/Scene/MainMenuScene")

local visibleSize = CCDirector:getInstance():getVisibleSize()	
local origin = CCDirector:getInstance():getVisibleOrigin()

local function createBackLayer()
	local backLayer = CCLayer:create()

	local frameWidth = 712
    local frameHeight = 1024

	local textureSplash = CCTextureCache:getInstance():addImage("imgs/splash_bg.png")


	rect = CCRect(0, 0, frameWidth, frameHeight)
    local splashFrame = CCSpriteFrame:createWithTexture(textureSplash, rect)

    local splashSprite = CCSprite:createWithSpriteFrame(splashFrame)
	splashSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)
	backLayer:addChild(splashSprite)

    -- handing touch events
    local touchBeginPoint = nil

    local function onTouchBegan(x, y)
		CCLuaLog("touch began...")
		CCDirector:getInstance():replaceScene(CreateMenuScene())
        touchBeginPoint = {x = x, y = y}
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
function CreateSplashScene()
   
	local scene = CCScene:create()
	scene:addChild(createBackLayer())

    return scene
end