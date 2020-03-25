#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"samples.flutter.dev/battery"
                                            binaryMessenger:controller.binaryMessenger];

    __weak typeof(self) weakSelf = self;
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      // Note: this method is invoked on the UI thread.
      // TODO
        if ([@"getBatteryLevel" isEqualToString:call.method]) {
          int batteryLevel = [weakSelf getBatteryLevel];
 
          if (batteryLevel == -1) {
            result([FlutterError errorWithCode:@"UNAVAILABLE"
                                       message:@"Battery info unavailable"
                                       details:nil]);
          } else {
            result(@(batteryLevel));
          }
        }
        if([@"playAudio" isEqualToString:call.method]){
            AVAudioPlayer *player;
            NSString *path = [[NSBundle mainBundle] pathForResource: @"song" ofType: @"mp3"];
            NSURL *url = [NSURL URLWithString:path];
            player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            [player play];
        
        }else {
          result(FlutterMethodNotImplemented);
        }
    }];

    
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return (int)(device.batteryLevel * 100);
  }
}

@end
