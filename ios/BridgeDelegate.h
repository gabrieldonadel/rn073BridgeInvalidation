// Copyright 2015-present 650 Industries. All rights reserved.
#import <React/RCTBridgeDelegate.h>
#import <React/RCTRootView.h>
#if __has_include(<React-RCTAppDelegate/RCTAppDelegate.h>)
#import <React-RCTAppDelegate/RCTAppDelegate.h>
#elif __has_include(<React_RCTAppDelegate/RCTAppDelegate.h>)
// for importing the header from framework, the dash will be transformed to underscore
#import <React_RCTAppDelegate/RCTAppDelegate.h>
#endif

@interface BridgeDelegate : RCTAppDelegate

- (RCTRootView *)createRootViewWithModuleName:(NSString *)moduleName
                                launchOptions:(NSDictionary *_Nullable)launchOptions
                                  application:(UIApplication *)application;

@end
