#import "AppDelegate.h"
#import "BlueViewController.h"
#import "BridgeDelegate.h"

#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>

@implementation AppDelegate {
  UIViewController *viewController;
  BlueViewController *blueViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  self.window.rootViewController = viewController;
  
  [self addButtonToView:viewController.view];
  
  blueViewController = [[BlueViewController alloc] init];
  [blueViewController initializeReactNativeApp];
  CGFloat remainingHeight = self.window.bounds.size.height - 100;
  blueViewController.vc.view.frame = CGRectMake(0, 120, self.window.bounds.size.width, remainingHeight);
  [viewController.view addSubview:blueViewController.vc.view];
  
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)addButtonToView:(UIView *)view  {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  [button setTitle:@"Invalidate and create new instance" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [button sizeToFit];
  button.center = CGPointMake(self.window.bounds.size.width / 2, 80);
  
  [view addSubview:button];
}

- (void)buttonTapped:(UIButton *)sender {
  dispatch_async(dispatch_get_main_queue(), ^{
    [blueViewController invalidate];
    
    [blueViewController initializeReactNativeApp];
    //    [self sendUserInterfaceStyleNotification];
  });
}

- (void)sendUserInterfaceStyleNotification
{
  UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
  id<UITraitEnvironment>env = mainWindow.rootViewController;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:RCTUserInterfaceStyleDidChangeNotification
                                                      object:env
                                                    userInfo:@{
    RCTUserInterfaceStyleDidChangeNotificationTraitCollectionKey : env.traitCollection
  }];
}

@end
