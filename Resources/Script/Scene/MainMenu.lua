local visibleSize = CCDirector:getInstance():getVisibleSize()	
local origin = CCDirector:getInstance():getVisibleOrigin()

-- create main menu
function CreateMenu()
    local layerFarm = CCLayer:create()

	--add badland 
	local bandlandSprite = CCSprite:create("imgs/badland.jpg")
    bandlandSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)
    layerFarm:addChild(bandlandSprite)

    -- handing touch events
    local touchBeginPoint = nil

    local function onTouchBegan(x, y)
        touchBeginPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end

    local function onTouchMoved(x, y)
        if touchBeginPoint then
            local cx, cy = layerFarm:getPosition()
            layerFarm:setPosition(cx + x - touchBeginPoint.x, cy + y - touchBeginPoint.y)
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

    layerFarm:registerScriptTouchHandler(onTouch)
    layerFarm:setTouchEnabled(true)

    return layerFarm
end