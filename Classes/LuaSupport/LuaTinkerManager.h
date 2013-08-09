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
		RVal ret;
		if (false == this->checkAnyLoadFile(filePath))
			return ret;

		ret = lua_tinker::call<RVal>(this->curLuaState, funcName);
		return ret;
	}

	template<typename RVal, typename T1>
	RVal callLuaFunc(const char* filePath, const char* funcName, T1 arg)
	{
		RVal ret;
		if (false == this->checkAnyLoadFile(filePath))
			return ret;

		ret = lua_tinker::call<RVal>(this->curLuaState, funcName, arg);
		return ret;
	}

	template<typename RVal, typename T1, typename T2>
	RVal callLuaFunc(const char* filePath, const char* funcName, T1 arg1, T2 arg2)
	{
		RVal ret;
		if (false == this->checkAnyLoadFile(filePath))
			return ret;

		ret = lua_tinker::call<RVal>(this->curLuaState, funcName, arg1, arg2);
		return ret;
	}

	template<typename RVal, typename T1, typename T2, typename T3>
	RVal callLuaFunc(const char* filePath, const char* funcName, T1 arg1, T2 arg2, T3 arg3)
	{
		RVal ret;
		if (false == this->checkAnyLoadFile(filePath))
			return ret;

		ret = lua_tinker::call<RVal>(this->curLuaState, funcName, arg1, arg2, arg3);
		return ret;
	}

	//读取配置
	template<typename RVal, typename T1, typename T2>
	RVal getLuaConfig(string configFileName, const char * tableName, T1 idName, T2 typeName)
	{
		RVal ret;
		if (false == this->checkAnyLoadFile("scripts/GameConfig/" + configFileName + ".lua"))
			return ret;

		lua_tinker::table gTable = lua_tinker::get<lua_tinker::table>(this->curLuaState, tableName);
		lua_tinker::table inTable = gTable.get<lua_tinker::table>(idName);
		ret = inTable.get<RVal>(typeName);
		return ret;
	}

	bool checkAnyLoadFile(string filePath);
private:
	

private:
	lua_State *curLuaState;

	//已经加载的lua文件集合
	set<string> loadedFiles;
};