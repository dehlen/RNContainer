#import "ReactNativeBridgeDelegate.h"

@interface ReactNativeBridgeDelegate ()
@property (nonatomic, copy) NSURL *sourceURL;
@end

@implementation ReactNativeBridgeDelegate

- (instancetype)initWithModuleURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.sourceURL = url;
    }

    return self;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    return self.sourceURL;
}

@end
