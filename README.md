# NPush SDK for IOS 
NP6 IOS SDK for Push Notification - The game changing libraries for building Blazingly fast 🚀 Highly interactives notification user experiences. Made with ❤️ 

## Introduction 
This library is a part of NP6 Push Notifications service, it allow you to interact with your users via Push Notifications sended via NP6 CM. 

## Table of content
1.	[Prerequisites](https://github.com/NP6/npush-ios#prerequisites)
2.	[Installation](https://github.com/NP6/npush-ios#installation)
    * [Notification Service]()
    * [App Delegate]()
    * [Contact Subscription]()
        * [Native implementation]()
        * [React native implementation](https://github.com/NP6/npush-ios/#react-native-implementation)
        * [Flutter implementation]()
3.	[Troubleshooting]()


## Prerequisites
Whe are going to review all the steps needed to be done before installing NPush SDK.


### Apple Push Notifications certificates

Before continuing, you need to add remote push notification permissions for your application. If you haven't done this step before please follow this 
[tutorial]().

### Add dependency 

Right click on project tree -> Add Packages -> tap **https://github.com/NP6/npush-ios/** in search bar
and get latest swift package dependency


### Add Notification Service Extension

Click on File -> Target -> Notification Service Extension , choose a product name and cancel service scheme activation. 


Note : don't forget to add sdk dependency to this target. 

<details>

<summary>Swift</summary>
    
```swift
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        
        NPush.instance.didReceive(request: request, contentHandler: contentHandler)
    }
}
```

</details>
                        
<details>

<summary>Objective-c</summary>
    
```objective-c

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;    
}

@end
```


</details>

 
### Objective-c

### Add AppDelegate 

Add the following lines of code to your project. If your already have an application delegate, skip this part.

<details>

<summary>Swift</summary>
    
    
```swift 
class MyAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true;
    }
}

@main
struct demoApp: App {
    
    @UIApplicationDelegateAdaptor(MyApplicationDelegate.self) var appDelegate
    
    ...
}
```

</details>

<details>

<summary>Objective-c</summary>

```objective-c 
@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}


@end
```    
    
</details>



## Installation 

### Implement notification service extension methods

<details>

<summary>Swift</summary>
    
```swift 
...
    var contentHandler: ((UNNotificationContent) -> Void)?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        
        NPush.instance.didReceive(request: request, contentHandler: contentHandler)
    }
    
    ...

```
    
</details>

<details>

<summary>Objective-c</summary>

```objective-c
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    NPush *npush = [NPush instance];
    [npush didReceiveWithRequest:request contentHandler: contentHandler];

}

@end
```

</details>

### Implement specific AppDelegate methods

In your application delegate add following lines of code :

#### Swift

Create and set your configuration 

<details>

<summary>Swift</summary>

```swift 
class MyAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      NPush.requestNotificationAuthorization(application)
      
      let config = Config("<identity>", application: UUID(uuidString: "<application-id>") ?? throw ...)
      NPush.instance.InitWithConfig(config: config)

      return true;
    }
    
    ...
}

```

</details>

Handle delegate Notification Center  

<details>

<summary>Objective-c</summary>
```swift 
class MyAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    ...
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        defer {
            completionHandler(.newData)
        }
        NPush.instance.willPresent(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            completionHandler()
        }
        NPush.instance.didReceive(response)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        defer {
            completionHandler([.badge, .alert])
        }
        NPush.instance.willPresent(notification.request.content.userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NPush.instance.SetToken(deviceToken: deviceToken)

    }
    
    ...
}

```


</details>

<details>

<summary>Objective-c</summary>

```objective-c

@import npush; // Add sdk dependencie 

@interface AppDelegate () <UNUserNotificationCenterDelegate>


@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Request notifications authorizations 
    [NPush requestNotificationAuthorization:application];

    [[UIApplication sharedApplication] registerForRemoteNotifications];


    NSUUID *uuid = [[NSUUID UUID] initWithUUIDString:@"<application-id>"];

    Config* config = [[Config alloc] init:@"<identity>" application: uuid];
    
    NPush *npush = [NPush instance];
    
    [npush InitWithConfigWithConfig:config];
    return YES;
}

- (void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken
{
    [NPush SetTokenWithDeviceToken:devToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [NPush willPresent:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    [NPush willPresent:notification.request.content.userInfo];
    completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    [NPush didReceive:response];
    completionHandler();
}

@end
```


</details>

### Attach contact to device subscription 

Suppose we have an application with a login & register form and we want to attach the current device subscription to the logged user.
We could only identify the users by hash, id or unicity criteria. 

**Note : All of these identifiers are strongly linked to the NP6 CM platform.**

Please be sure to have one of this 3 identifiers in your user representation before continue. 

#### Native implementation

Example attaching device subscription by hash

<details>

<summary>Swift</summary>

  ```swift

      NPush.instance.SetContact(type: .HashRepresentation, value: <hash>)

```
</details>
    
<details>

<summary>Objective-c</summary>

```objective-c

    NPush *npush = [NPush instance];

    [npush SetContactWithType :ContactTypeHashRepresentation value:@<hash>];

```

</details>

Example attaching device subscription by unicity

<details>

<summary>Swift</summary>

```swift

      NPush.instance.SetContact(type: .UnicityRepresentation, value:<unicity>)

```

</details>

<details>

<summary>Objective-c</summary>

```objective-c

    NPush *npush = [NPush instance];

    [npush SetContactWithType :ContactTypeUnicityRepresentation value:@<unicity>];

```

</details>

Example attaching device subscription by id

<details>

<summary>Swift</summary>

```swift

      NPush.instance.SetContact(type: .IdRepresentation, value:<id>)

```

</details>

<details>

<summary>Objective-c</summary>

```objective-c

    NPush *npush = [NPush instance];

    [npush SetContactWithType :ContactTypeIdRepresentation value:@<id>];

```

</details>

### React Native Implementation 

### Create react package  

Declare a new ReactPackage by creating a new file implementation file called **NPushModule.h**

<details>

<summary>Objective-c</summary>

```objective-c
#import <React/RCTBridgeModule.h>
@interface RCTNPushModule : NSObject <RCTBridgeModule>
@end
```

</details>

let’s start implementing the native module. Create the corresponding implementation file, RCTNPushModule.m, in the same folder and include the following content:

<details>

<summary>Objective-c</summary>

```objective-c
#import <Foundation/Foundation.h>
#import "RCTNPushModule.h"

@implementation RCTNPushModule

// To export a module named RCTNPushModule
RCT_EXPORT_MODULE(RCTNPushModule);

@end
```

</details>

The native module can then be accessed in JS like this:

<details>

<summary>javascript</summary>

```objective-c
const {NPushModule} = ReactNative.NativeModules;
```

</details>

### Implement contact methods   

Use one of these functions depending on the type of credential you are using.

Example attaching device subscription by hash

<details>

<summary>Objective-c</summary>

```objective-c
RCT_EXPORT_METHOD(setContactByHash:(NSString *)hash)
{
    [npush SetContact :ContactTypeUnicityRepresentation value:@<hash>];
}
```

</details>

 Example attaching device subscription by unicity
 
 <details>

<summary>Objective-c</summary>

```objective-c
RCT_EXPORT_METHOD(setContactByUnicity:(NSString *)unicity)
{
    [npush SetContact :ContactTypeUnicityRepresentation value:@<unicity>];
}
```

</details>

Example attaching device subscription by id
 
<details>

<summary>Objective-c</summary>

```objective-c
RCT_EXPORT_METHOD(setContactById:(NSString *)id)
{
    [npush SetContact :ContactTypeIdRepresentation value:@<id>];
}
```

</details>

The last step is calling one of previous declarated methods in react native as follow :
</details>

Example attaching device subscription by id
 
<details>

<summary>javascript</summary>

``` javascript
// Example using native module attaching device subscription by id 
const {NPushModule} = ReactNative.NativeModules;
...  
 NPushModule.setContactById('000T39KL');
...  

```

</details>

### Flutter Implementation


### Create Flutter module 

Let's create a new dart class called NPush and add a new method as follow : 
<details>

<summary>dart</summary>

```dart
class NPush {
  static const platform = MethodChannel('np6.messaging.npush/contact');

  Future<void> setContactById(String value) async {
    var result = await platform
        .invokeMethod('SetContactWithUnicityValue', {"value": value});

    return result;
  }
}
```

</details>

### Create native channel


Open the AppDelegate.swift file and override **application:didFinishLaunchingWithOptions:** as follow :

<details>

<summary>swift</summary>

```swift
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

      let npushChannel = FlutterMethodChannel(name: "np6.messaging.npush/contact", binaryMessenger: controller.binaryMessenger)
      npushChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
         
         
      })    
      
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
```

</details>

Next, Add the following code depending the kind of contact identification needed in this example we are gonna use an id representation :

<details>

<summary>swift</summary>

```swift
      ...

      npushChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
          guard call.method == "SetContactById" else {
            result(FlutterMethodNotImplemented)
            return
          }

          if let args = call.arguments as? Dictionary<String, Any>,
            let value = args["value"] as? String {
            
              NPush.instance.SetContact(type: ContactType.IdRepresentation, value: value)
              
              result(nil)
          } else {
            result(FlutterError.init(code: "errorSetContact", message: "data or format error", details: nil))
          }

      })    
   }
   
   ...

```

</details>


If everything is done. You will see the following lines in your application log :

```
I/np6-messaging: Subscription created successfully
```

