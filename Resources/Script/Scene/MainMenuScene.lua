--[[
Copyright (c) 2013 crosslife <hustgeziyang@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

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