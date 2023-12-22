#import "BridgeDelegate.h"

#import <React/RCTBundleURLProvider.h>
#if __has_include(<React_RCTAppDelegate/RCTAppSetupUtils.h>)
// for importing the header from framework, the dash will be transformed to underscore
#import <React_RCTAppDelegate/RCTAppSetupUtils.h>
#else
#import <React-RCTAppDelegate/RCTAppSetupUtils.h>
#endif

//#import <React/RCTRuntimeExecutorFromBridge.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <react/renderer/runtimescheduler/RuntimeScheduler.h>
#if __has_include(<React_RCTAppDelegate/RCTAppSetupUtils.h>)
// for importing the header from framework, the dash will be transformed to underscore
#import <React_RCTAppDelegate/RCTAppSetupUtils.h>
#else
#import <React-RCTAppDelegate/RCTAppSetupUtils.h>
#endif

#ifdef RCT_NEW_ARCH_ENABLED
#import <memory>

#import <React/CoreModulesPlugins.h>
#import <React/RCTSurfacePresenter.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <ReactCommon/RCTTurboModuleManager.h>
#import <react/config/ReactNativeConfig.h>

#import <react/renderer/runtimescheduler/RuntimeSchedulerCallInvoker.h>

@interface BridgeDelegate () <RCTTurboModuleManagerDelegate> {
  std::shared_ptr<const facebook::react::ReactNativeConfig> _reactNativeConfig;
  facebook::react::ContextContainer::Shared _contextContainer;
}
@end

static NSString *const kRNConcurrentRoot = @"concurrentRoot";

#endif

@interface RCTAppDelegate (BridgeDelegate)

- (void)unstable_registerLegacyComponents;

@end

@interface BridgeDelegate () <RCTCxxBridgeDelegate> {
  std::shared_ptr<facebook::react::RuntimeScheduler> _runtimeScheduler;
}
@end

@implementation BridgeDelegate

#if RCT_NEW_ARCH_ENABLED
- (instancetype)init
{
  if (self = [super init]) {
    _contextContainer = std::make_shared<facebook::react::ContextContainer const>();
    _reactNativeConfig = std::make_shared<facebook::react::EmptyReactNativeConfig const>();
    _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
  }
  return self;
}
#endif

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self getBundleURL];
}

- (NSURL *)getBundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}


- (RCTRootView *)createRootViewWithModuleName:(NSString *)moduleName launchOptions:(NSDictionary * _Nullable)launchOptions application:(UIApplication *)application{
    BOOL enableTM = NO;
#if RCT_NEW_ARCH_ENABLED
    enableTM = YES;
#endif

    RCTAppSetupPrepareApp(application, enableTM);

    self.bridge = [self createBridgeAndSetAdapterWithLaunchOptions:launchOptions];

    NSMutableDictionary *initProps = [NSMutableDictionary new];
#ifdef RCT_NEW_ARCH_ENABLED
    initProps[kRNConcurrentRoot] = @YES;
#endif

    return [super createRootViewWithBridge:self.bridge moduleName:moduleName initProps:initProps];
}


- (RCTBridge *)createBridgeAndSetAdapterWithLaunchOptions:(NSDictionary * _Nullable)launchOptions {
  self.bridge = [self createBridgeWithDelegate:self launchOptions:launchOptions];

#ifdef RCT_NEW_ARCH_ENABLED
  self.bridgeAdapter = [[RCTSurfacePresenterBridgeAdapter alloc] initWithBridge:self.bridge
                                                               contextContainer:_contextContainer];
  self.bridge.surfacePresenter = self.bridgeAdapter.surfacePresenter;

  [self unstable_registerLegacyComponents];
#endif

  return self.bridge;
}

#pragma mark - RCTCxxBridgeDelegate
- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge
{
#if RCT_NEW_ARCH_ENABLED
  _runtimeScheduler = std::make_shared<facebook::react::RuntimeScheduler>(RCTRuntimeExecutorFromBridge(bridge));
  std::shared_ptr<facebook::react::CallInvoker> callInvoker =
      std::make_shared<facebook::react::RuntimeSchedulerCallInvoker>(_runtimeScheduler);
  RCTTurboModuleManager *turboModuleManager = [[RCTTurboModuleManager alloc] initWithBridge:bridge delegate:self jsInvoker:callInvoker];
  _contextContainer->erase("RuntimeScheduler");
  _contextContainer->insert("RuntimeScheduler", _runtimeScheduler);
  return RCTAppSetupDefaultJsExecutorFactory(bridge, turboModuleManager, _runtimeScheduler);
#else
//  if (self.runtimeSchedulerEnabled) {
//    _runtimeScheduler = std::make_shared<facebook::react::RuntimeScheduler>(RCTRuntimeExecutorFromBridge(bridge));
//  }
  return RCTAppSetupJsExecutorFactoryForOldArch(bridge, _runtimeScheduler);
#endif
}

@end
