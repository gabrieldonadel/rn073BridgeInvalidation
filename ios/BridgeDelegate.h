#import "CustomAppDelegate.h"
#import <React/RCTRootView.h>

@interface BridgeDelegate : CustomAppDelegate

- (RCTRootView *)createRootViewWithModuleName:(NSString *)moduleName
                                launchOptions:(NSDictionary *_Nullable)launchOptions
                                  application:(UIApplication *)application;

@end
