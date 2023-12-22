// ReactNativeViewController.h
#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>

@interface ReactNativeViewController : NSObject
- (void)initializeReactNativeApp;
- (void)invalidate;
@property (nonatomic, strong) UIViewController *vc;
@end
