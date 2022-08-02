#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>
#import <React/RCTBridgeDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReactNativeBridge : NSObject<RCTBridgeDelegate> {
    void (^_onBundleLoaded)(void);
}

@property (nonatomic, copy) NSString *entryFile;
@property (nonatomic, copy) NSString *bundlePath;
@property (nonatomic) RCTBridge *bridge;

+(ReactNativeBridge*)shared;

-(void)startReactNative;
-(void)startReactNative:(void(^_Nullable)(void))onBundleLoaded;
-(void)startReactNative:(void(^_Nullable)(void))onBundleLoaded launchOptions:(NSDictionary * _Nullable)launchOptions;

@end

NS_ASSUME_NONNULL_END
