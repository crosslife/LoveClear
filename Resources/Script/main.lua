
-- avoid memory leak
collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)
	
<<<<<<< HEAD
require("Script/Scene/SplashScene")
----------------

-- run
CCDirector:getInstance():runWithScene(CreateSplashScene())
=======
require "Script/Scene/MainMenuScene"
----------------


-- run
CCDirector:getInstance():runWithScene(CreateMenuScene())
>>>>>>> 6b7426e8b6ab17eccd738ec001af65f2fa04f106
