#pragma once

#include "Singleton_t.h"
#include <cocos2d.h>
#include <string>
#include <set>

extern "C" {
#	include "lua.h"
#	include "lualib.h"
#	include "lauxlib.h"
}
#include "lua_tinker.h"

struct lua_State;

using namespace std;
using namespace cocos2d;

class LuaTinkerManager : public TSingleton<LuaTinkerManager>
{
public:
	LuaTinkerManager();
	virtual ~LuaTinkerManager();

	//通用调用接口，不支持返回值为void
	template<typename RVal>
	RVal callLuaFunc(const char* filePath, const char* funcName)
	{

		CCASSERT(this->checkAnyLoadFile(filePath), "load lua file failed");

		return lua_tinker::call<RVal>(this->curLuaState, funcName);
	}

	template<typename RVal, typename T1>
	RVal callLuaFunc(const char* filePath, const char* funcName, T1 arg)
	{
		CCASSERT(this->checkAnyLoadFile(filePath), "load lua file failed");

		return lua_tinker::call<RVal>(this->curLuaState, funcName, arg);
	}

	template<typename RVal, typename T1, typename T2>
	RVal callLuaFunc(const char* filePath, const char* funcName, T1 arg1, T2 arg2)
	{
		CCASSERT(this->checkAnyLoadFile(filePath), "load lua file failed");

		return lua_tinker::call<RVal>(this->curLuaState, funcName, arg1, arg2);
	}

	template<typename RVal, typename T1, typename T2, typename T3>
	RVal callLuaFunc(const char* filePath, const char* funcName, T1 arg1, T2 arg2, T3 arg3)
	{
		CCASSERT(this->checkAnyLoadFile(filePath), "load lua file failed");

		return lua_tinker::call<RVal>(this->curLuaState, funcName, arg1, arg2, arg3);
	}

	bool checkAnyLoadFile(string filePath);
private:
	

private:
	lua_State *curLuaState;

	//已经加载的lua文件集合
	set<string> loadedFiles;
};