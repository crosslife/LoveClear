
-- avoid memory leak
collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)
	
require "Script/Scene/MainMenuScene"
----------------


-- run
CCDirector:getInstance():runWithScene(CreateMenuScene())
