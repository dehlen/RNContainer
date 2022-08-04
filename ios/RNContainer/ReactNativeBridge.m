#import <Foundation/Foundation.h>
#if __has_include(<React/RCTBundleURLProvider.h>)
#import <React/RCTBundleURLProvider.h>
#elif __has_include("RCTBundleURLProvider.h")
#import "RCTBundleURLProvider.h"
#else
#import "React/RCTBundleURLProvider.h"   // Required when used as a Pod in a Swift project
#endif

#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#elif __has_include("RCTBridge.h")
#import "RCTBridge.h"
#else
#import "React/RCTBridge.h"   // Required when used as a Pod in a Swift project
#endif

#if __has_include(<React/RCTRootView.h>)
#import <React/RCTRootView.h>
#elif __has_include("RCTRootView.h")
#import "RCTRootView.h"
#else
#import "React/RCTRootView.h"   // Required when used as a Pod in a Swift project
#endif

#import "ReactNativeBridge.h"
#import "ReactNativeBridgeDelegate.h"

@interface ReactNativeBridge ()
@property (nonatomic) RCTBridge *bridge;
@end

@implementation ReactNativeBridge

@synthesize entryFile = _entryFile;
@synthesize bridge;

+ (ReactNativeBridge*)shared {
    static ReactNativeBridge *sharedBridgeManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBridgeManager = [self new];
    });
    
    return sharedBridgeManager;
}

- (id)init {
    if (self = [super init]) {
        _entryFile = @"index";
    }
    return self;
}

- (void)startReactNative {
    [self startReactNative:nil];
}

- (void)startReactNative:(void(^_Nullable)(void))onBundleLoaded {
    [self startReactNative:onBundleLoaded launchOptions:nil];
}

- (void)startReactNative:(void(^_Nullable)(void))onBundleLoaded launchOptions:(NSDictionary * _Nullable)launchOptions {
    if (bridge != nil) {
        return;
    }
    
    ReactNativeBridgeDelegate *delegate = [[ReactNativeBridgeDelegate alloc] initWithModuleURL:[self sourceURL]];
    bridge = [[RCTBridge alloc] initWithDelegate:delegate launchOptions:launchOptions];
    
    if (onBundleLoaded != nil) {
        _onBundleLoaded = [onBundleLoaded copy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jsLoaded:) name:RCTJavaScriptDidLoadNotification object:nil];
    }
}

- (void)jsLoaded:(NSNotification*)notification {
    _onBundleLoaded();
    _onBundleLoaded = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSURL *)sourceURL {
    #if DEBUG
    NSURL *url = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:_entryFile fallbackExtension:nil];
    if (!url) {
        return [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios&dev=true&minify=false"];
    } else {
        return url;
    }
    #else
        return [[NSBundle bundleForClass:[ReactNativeBridge class]] URLForResource:@"main" withExtension:@"jsbundle"];
    #endif
}

- (UIView *)rootViewWithName:(NSString *)name properties:(NSDictionary *)properties {
    if (self.bridge == nil) {
        [NSException raise:@"BridgeNotInitialized" format:@"You need to start React Native in order to use ReactNativeViewController, make sure to run [[BridgeManager shared] startReactNative] before instantiating it."];
    }
    return [[RCTRootView alloc] initWithBridge:bridge moduleName:name initialProperties:properties];
}
@end
