#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReactNativeBridge : NSObject {
    void (^_onBundleLoaded)(void);
}

@property (nonatomic, copy) NSString *entryFile;

+(ReactNativeBridge*)shared;

-(void)startReactNative;
-(void)startReactNative:(void(^_Nullable)(void))onBundleLoaded;
-(void)startReactNative:(void(^_Nullable)(void))onBundleLoaded launchOptions:(NSDictionary * _Nullable)launchOptions;

-(UIView *)rootViewWithName:(NSString *)name properties:(NSDictionary *_Nullable)properties;
@end

NS_ASSUME_NONNULL_END
