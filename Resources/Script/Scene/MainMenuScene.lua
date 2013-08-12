

local visibleSize = CCDirector:getInstance():getVisibleSize()	
local origin = CCDirector:getInstance():getVisibleOrigin()

local function createBackLayer()
	local backLayer = CCLayer:create()

	--add background
	local bandlandSprite = CCSprite:create("imgs/badland.jpg")
    bandlandSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)
    backLayer:addChild(bandlandSprite)

    -- handing touch events
    local touchBeginPoint = nil

    local function onTouchBegan(x, y)
        touchBeginPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end

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