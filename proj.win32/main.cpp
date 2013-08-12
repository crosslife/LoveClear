#include "main.h"
#include "AppDelegate.h"
#include "cocos2d.h"

#define WINDOW_WIDHT      320
#define WINDOW_HEIGHT     480

USING_NS_CC;

// uncomment below line, open debug console
#define USE_WIN32_CONSOLE

int APIENTRY _tWinMain(HINSTANCE hInstance,
                       HINSTANCE hPrevInstance,
                       LPTSTR    lpCmdLine,
                       int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

#ifdef USE_WIN32_CONSOLE
    AllocConsole();
    freopen("CONIN$", "r", stdin);
    freopen("CONOUT$", "w", stdout);
    freopen("CONOUT$", "w", stderr);
#endif

    // create the application instance
    AppDelegate app;
    EGLView* eglView = EGLView::getInstance();
    eglView->setViewName("MyGitGame");
    eglView->setFrameSize(WINDOW_WIDHT, WINDOW_HEIGHT);

    int ret = Application::getInstance()->run();

#ifdef USE_WIN32_CONSOLE
    FreeConsole();
#endif

    return ret;
}
