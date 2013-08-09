require "AudioEngine" 

function GetFrameSizeX()
	return 1024
end

function GetFrameSizeY()
	return 768
end

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

    ---------------
	--CCEGLView:getInstance():setFrameSize(1024, 768)

    local visibleSize = CCDirector:getInstance():getVisibleSize()
	cclog("visibleSize: "..visibleSize.width.." "..visibleSize.height)
	
    local origin = CCDirector:getInstance():getVisibleOrigin()
	cclog("origin: "..origin.x.." "..origin.y)
	

    -- create farm
    local function createLayerFarm()
        local layerFarm = CCLayer:create()

        -- add in farm background
        --local bg = CCSprite:create("imgs/farm.jpg")
        --bg:setPosition(origin.x + visibleSize.width / 2 + 80, origin.y + visibleSize.height / 2)
        --layerFarm:addChild(bg)
		
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
            else
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
