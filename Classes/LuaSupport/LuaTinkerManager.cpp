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

		unsigned long fileSize = 0;
		unsigned char* buffer = CCFileUtils::sharedFileUtils()->getFileData(path.c_str(), "rt", &fileSize);
		int ret = luaL_dostring(this->curLuaState, (char*)buffer, fileSize);

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
