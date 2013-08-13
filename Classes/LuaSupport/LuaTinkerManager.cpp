/*
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
*/

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
