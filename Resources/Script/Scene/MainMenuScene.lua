require("Script/Scene/GameScene")



local function createBackLayer()
	local backLayer = CCLayer:create()

	local textureMenu = CCTextureCache:getInstance():addImage("imgs/menu_bg.png")
	local visibleSize = CCDirector:getInstance():getVisibleSize()	

	rect = CCRect(0, 0, visibleSize.width, visibleSize.height)
    local menuFrame = CCSpriteFrame:createWithTexture(textureMenu, rect)

    local menuSprite = CCSprite:createWithSpriteFrame(menuFrame)
	menuSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)
	--set scale
	--menuSprite:setScaleX(visibleSize.width/frameWidth)

	backLayer:addChild(menuSprite)

    local function onTouchBegan(x, y)
		CCLuaLog("touch began...")
		CCDirector:getInstance():replaceScene(CreateGameScene())
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
function CreateMenuScene()
   
	local scene = CCScene:create()
	scene:addChild(createBackLayer())

    return scene
end