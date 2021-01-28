//#include "RegisterMonoModules.h"
//#include "RegisterFeatures.h"
//#include <csignal>
//#import <UIKit/UIKit.h>
//
//static const int constsection = 0;
//void UnityInitTrampoline();
//
//extern "C" void unity_init(int argc, char* argv[])
//{
//    @autoreleasepool
//    {
//        UnityInitTrampoline();
//// Unity版本不同，有些可能要选UnityInitRuntime的方法
//        UnityInitRuntime(argc, argv);
////        UnityParseCommandLine(argc, argv);
//        
//        RegisterMonoModules();
//        NSLog(@"-> registered mono modules %p\n", &constsection);
//        RegisterFeatures();
//        std::signal(SIGPIPE, SIG_IGN);
//    }
//}
