#include "LuaTinkerManager.h"
#include "CCLuaEngine.h"


LuaTinkerManager::LuaTinkerManager()
{
	curLuaState = LuaEngine::getInstance()->getLuaStack()->getLuaState();
}

LuaTinkerManager::~LuaTinkerManager()
{
	loadedFiles.clear();
}

bool LuaTinkerManager::checkAnyLoadFile(string filePath)
{
	
	if (loadedFiles.find(filePath) == loadedFiles.end())
	{
		std::string path = FileUtils::getInstance()->fullPathForFilename(filePath.c_str());

		int ret = luaL_dofile(this->curLuaState, path.c_str());

		if (ret != 0) {
			CCLOG("load %s file error: %s", filePath.c_str(), lua_tostring(this->curLuaState, -1));
			lua_pop(this->curLuaState, 1);
			return false;
		}

		loadedFiles.insert(filePath);
		return true;
	}

	return true;
}
