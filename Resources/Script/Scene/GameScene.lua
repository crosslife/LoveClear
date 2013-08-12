
local visibleSize = CCDirector:getInstance():getVisibleSize()	
local origin = CCDirector:getInstance():getVisibleOrigin()

local function createBackLayer()
	local backLayer = CCLayer:create()

	local frameWidth = 712
    local frameHeight = 1024

	local textureMenu = CCTextureCache:getInstance():addImage("imgs/game_bg.png")


	rect = CCRect(0, 0, frameWidth, frameHeight)
    local menuFrame = CCSpriteFrame:createWithTexture(textureMenu, rect)

    local menuSprite = CCSprite:createWithSpriteFrame(menuFrame)
	menuSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)

	--set scale
	menuSprite:setScaleX(visibleSize.width/frameWidth)
	backLayer:addChild(menuSprite)

    local function onTouchBegan(x, y)
		CCLuaLog("touch began...")
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

    return scene
end