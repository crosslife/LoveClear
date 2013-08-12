
-- avoid memory leak
collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)
	
require "Script/Scene/MainMenu"
----------------


-- run
local scene = CCScene:create()
scene:addChild(CreateMenu())
CCDirector:getInstance():runWithScene(scene)
