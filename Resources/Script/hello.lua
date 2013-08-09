
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    local cclog = function(...)
        print(string.format(...))
    end

    local visibleSize = CCDirector:getInstance():getVisibleSize()	
    local origin = CCDirector:getInstance():getVisibleOrigin()

    -- create farm
    local function createLayerFarm()
        local layerFarm = CCLayer:create()

		--add badland 
		local bandlandSprite = CCSprite:create("imgs/badland.jpg")
        bandlandSprite:setPosition(visibleSize.width / 2, visibleSize.height / 2)
        layerFarm:addChild(bandlandSprite)

        -- handing touch events
        local touchBeginPoint = nil

        local function onTouchBegan(x, y)
            --cclog("onTouchBegan: %0.2f, %0.2f", x, y)
            touchBeginPoint = {x = x, y = y}
            -- CCTOUCHBEGAN event must return true
            return true
        end

        local function onTouchMoved(x, y)
            --cclog("onTouchMoved: %0.2f, %0.2f", x, y)
            if touchBeginPoint then
                local cx, cy = layerFarm:getPosition()
                layerFarm:setPosition(cx + x - touchBeginPoint.x,
                                      cy + y - touchBeginPoint.y)
                touchBeginPoint = {x = x, y = y}
            end
        end

        local function onTouchEnded(x, y)
            --cclog("onTouchEnded: %0.2f, %0.2f", x, y)
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
				cclog(eventType)
				return onTouchEnded(x, y)
            end
        end

        layerFarm:registerScriptTouchHandler(onTouch)
        layerFarm:setTouchEnabled(true)

        return layerFarm
    end

    -- run
    local sceneGame = CCScene:create()
    sceneGame:addChild(createLayerFarm())
    CCDirector:getInstance():runWithScene(sceneGame)
end

xpcall(main, __G__TRACKBACK__)
