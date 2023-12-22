// BlueViewController.h
#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>

@interface BlueViewController : NSObject <RCTBridgeDelegate>
- (void)initializeReactNativeApp;
- (void)invalidate;
@property (nonatomic, strong) UIViewController *vc;

+ (instancetype)sharedInstance;
@end
