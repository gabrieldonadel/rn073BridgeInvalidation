#import "AppDelegate.h"
#import "ReactNativeViewController.h"
#import "BridgeDelegate.h"

#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>

@implementation AppDelegate {
  ReactNativeViewController *reactNativeViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  viewController.view.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = viewController;

  [self addButtonToView:viewController.view];

  reactNativeViewController = [[ReactNativeViewController alloc] init];
  [reactNativeViewController initializeReactNativeApp];

  reactNativeViewController.vc.view.frame = CGRectMake(0, 135, self.window.bounds.size.width, self.window.bounds.size.height - 100);
  [viewController.view addSubview:reactNativeViewController.vc.view];

  [self.window makeKeyAndVisible];

  return YES;
}

- (void)addButtonToView:(UIView *)view  {
  self.switchControl = [[UISwitch alloc] init];
  [view addSubview:self.switchControl];

  self.switchLabel = [[UILabel alloc] init];
  self.switchLabel.text = @"Send UserInterfaceStyle event after invalidating";
  self.switchLabel.font = [UIFont systemFontOfSize:14];
  [view addSubview:self.switchLabel];

  self.switchControl.translatesAutoresizingMaskIntoConstraints = NO;
  self.switchLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [NSLayoutConstraint activateConstraints:@[
    [self.switchControl.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:10],
    [self.switchControl.topAnchor constraintEqualToAnchor:view.topAnchor constant:50],

    [self.switchLabel.leadingAnchor constraintEqualToAnchor:self.switchControl.trailingAnchor constant:10],
    [self.switchLabel.centerYAnchor constraintEqualToAnchor:self.switchControl.centerYAnchor],
  ]];

  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  [button setTitle:@"Invalidate and create new instance" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [button sizeToFit];
  button.center = CGPointMake(self.window.bounds.size.width / 2, 105);

  [view addSubview:button];
}

- (void)buttonTapped:(UIButton *)sender {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self->reactNativeViewController invalidate];

    [self->reactNativeViewController   initializeReactNativeApp];
    if(self.switchControl.isOn){
      [self sendUserInterfaceStyleNotification];
    }
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
