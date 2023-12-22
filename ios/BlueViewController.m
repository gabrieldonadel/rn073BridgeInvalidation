// BlueViewController.m
#import "BlueViewController.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>


#import "BridgeDelegate.h"


@interface BlueViewController ()
@property (nonatomic, strong) BridgeDelegate *bridgeDelegate;

@end

@implementation BlueViewController

- (instancetype)init {
  if (self = [super init]) {
    self.bridgeDelegate = [BridgeDelegate new];
  }
  return self;
}

- (void)initializeReactNativeApp {


  UIView *rootView = [_bridgeDelegate createRootViewWithModuleName:@"rn073BridgeInvalidation" launchOptions:@{} application:UIApplication.sharedApplication];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  if(_vc != nil){
    _vc.view = rootView;
  }else{
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view = rootView;
   _vc =rootViewController;
  }

}

- (void)invalidate {
  [_bridgeDelegate.bridge invalidate];
}

@end
