#import "BasemodelPlugin.h"
#if __has_include(<firebase_basemodel/firebase_basemodel-Swift.h>)
#import <firebase_basemodel/firebase_basemodel-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "firebase_basemodel-Swift.h"
#endif

@implementation BasemodelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBasemodelPlugin registerWithRegistrar:registrar];
}
@end
