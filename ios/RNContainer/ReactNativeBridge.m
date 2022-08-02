#import <Foundation/Foundation.h>
#import <React/RCTBundleURLProvider.h>

#import "ReactNativeBridge.h"

@implementation ReactNativeBridge

@synthesize entryFile = _entryFile;
@synthesize bundlePath = _bundlePath;
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
        _bundlePath = @"main.jsbundle";
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
    
    bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
    
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

#pragma mark - RCTBridgeDelegate Methods

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    #if DEBUG
      return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:_entryFile fallbackExtension:nil];
    #else
        NSArray<NSString *> *resourceURLComponents = [_bundlePath componentsSeparatedByString:@"."];
        NSRange withoutLast;
    
        withoutLast.location = 0;
        withoutLast.length = [resourceURLComponents count] - 2;
    
        NSArray<NSString *> *resourceURLComponentsWithoutExtension = [resourceURLComponents subarrayWithRange:withoutLast];
    
        return [[NSBundle mainBundle]
                    URLForResource:[resourceURLComponentsWithoutExtension componentsJoinedByString:@""]
                    withExtension:resourceURLComponents[resourceURLComponents.count - 1]
               ];
    #endif
}

@end
