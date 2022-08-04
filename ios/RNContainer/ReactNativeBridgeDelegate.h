#import <Foundation/Foundation.h>

#if __has_include(<React/RCTBridgeDelegate.h>)
#import <React/RCTBridgeDelegate.h>
#elif __has_include("RCTBridgeDelegate.h")
#import "RCTBridgeDelegate.h"
#else
#import "React/RCTBridgeDelegate.h"   // Required when used as a Pod in a Swift project
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ReactNativeBridgeDelegate : NSObject <RCTBridgeDelegate>

- (instancetype)initWithModuleURL:(NSURL *)url;
NS_ASSUME_NONNULL_END
@end
