#import "ReactNativeViewController.h"

#if __has_include(<React/RCTRootView.h>)
#import <React/RCTRootView.h>
#elif __has_include("RCTRootView.h")
#import "RCTRootView.h"
#else
#import "React/RCTRootView.h"   // Required when used as a Pod in a Swift project
#endif

#import "ReactNativeBridge.h"

@implementation ReactNativeViewController

@synthesize moduleName = _moduleName;
@synthesize initialProperties = _initialProperties;

-(instancetype)initWithModuleName:(NSString *)moduleName {
    return [self initWithModuleName:moduleName andInitialProperties:nil];
}

-(instancetype)initWithModuleName:(NSString *)moduleName
             andInitialProperties:(NSDictionary* _Nullable)initialProperties {
    self = [super init];
    _moduleName = moduleName;
    _initialProperties = initialProperties;
    
    return self;
}

-(void)viewDidLoad {
    if (_moduleName) {
      self.view = [[ReactNativeBridge shared]rootViewWithName:_moduleName properties:_initialProperties];
    }
}

@end
