#pragma once

#include "stdlib.h"

template<class T>
class TSingleton
{
public:
    //create
    static void Create()
    {
        if ( !ms_pObject )
        {
            ms_pObject = new T;
        }
    }

    //destroy
    static void Destroy()
    {
        if ( ms_pObject )
        {
            delete ms_pObject;
            ms_pObject = NULL;
        }
    }

    //get instance
    static T* Get()
    {
		Create();
        return ms_pObject;
    }

protected:
    static T*	ms_pObject;
};

template<class T> 
T* TSingleton<T>::ms_pObject = NULL;
