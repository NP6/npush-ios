# NPush SDK for IOS 
NP6 IOS SDK for Push Notification

## Introduction 
This library is a part of NP6 Push Notifications service, it allow you to interact with your users via Push Notifications sended via NP6 CM. 

## Table of content
1.	[Prerequisites](https://github.com/NP6/npush-ios#prerequisites)
2.	[Installation](https://github.com/NP6/npush-ios#installation)
    * [Notification Service]()
    * [App Delegate]()
    * [Contact Subscription]()
        * [Native implementation](https://github.com/NP6/npush-ios/tree/main#native-implementation)
        * [React native implementation](https://github.com/NP6/npush-ios/tree/main#implement-contact-methods)
        * [Flutter implementation](https://github.com/NP6/npush-ios/tree/main#flutter-implementation)
3.	[Troubleshooting]()


## Prerequisites
We will go through all the necessary steps that need to be completed prior to installing the NPush SDK.


### Apple Push Notifications certificates

Before continuing, you need to add remote push notification permissions for your application. If you haven't done this step before please follow this 
[tutorial]().

### Add dependency 

To integrate the NPush SDK for iOS using the latest Swift package dependency, you can follow these steps: 
Firstly, right-click on the project tree, then choose "Add Packages." Next, use the search bar to locate https://github.com/NP6/npush-ios/.
After you have found it, click on it to add the latest Swift package dependency.



### Add Notification Service Extension

To configure the Notification Service Extension, navigate to the "File" menu, select "Target," and choose "Notification Service Extension." From there, choose a suitable product name and disable the service scheme activation. It's crucial to add the SDK dependency to this target. Please keep this in mind.

<details>

<summary>Swift</summary>
    
```swift
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
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

 
### Add AppDelegate 

If you do not have an existing application delegate, add the following lines of code to your project. However, if you already have one, you may skip this step.

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

You can implement the notification service extension methods by following these steps:

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

### Initialize SDK

To create and set your configuration in the application delegate, you can add the following code snippet:

<details>

<summary>Swift</summary>

```swift 
class MyAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         
        // request notification permission 
        
        UNUserNotificationCenter.current().delegate = self
            
        let config = Config.init(identity: "<identity>", application: UUID(uuidString: "<application id>") ?? UUID())
        
        NPush.instance.initialize(config: config)
        
        return true;
    }
    
    ...
}

```

</details>

<details>

<summary>Objetive-c</summary>

```objective-c 
@interface AppDelegate () <UNUserNotificationCenterDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    NSUUID *uuid = [[NSUUID UUID] initWithUUIDString:@""];
    
    Config* config = [[Config alloc] initWithIdentity:@"MCOM032" application: uuid];
    
    NPush *npush = [NPush instance];
    
    [npush initializeWithConfig: config];
    
    return YES;
}

...

```

</details>

In this code, you can replace <identity> with the identity of your configuration, and <application id> with the ID of your application. Once you have set up your configuration, you can call the initialize method of the NPush instance to initialize your SDK.


### Implement Notification Center delegate

You can handle the Notification Center delegate methods in your application delegate by adding the following code:

<details>

<summary>swift</summary>

```swift 
class MyAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    ...

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        defer {
            completionHandler(.newData)
        }
        
        NPush.instance.didReceiveRemoteNotification(application, userInfo: userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            completionHandler()
        }
        NPush.instance.didReceive(response: response)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .banner, .sound])
    }
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NPush.instance.handleRegistrationToken(deviceToken: deviceToken)
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


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NPush *npush = [NPush instance];
    [npush didReceiveRemoteNotification:application userInfo:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionList);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NPush *npush = [NPush instance];
    [npush didReceiveWithResponse:response];
    completionHandler();
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NPush *npush = [NPush instance];
    [npuh handleRegistrationTokenWithDeviceToken:deviceToken]

}
```


</details>

In this code, you can handle the didReceiveRemoteNotification, didReceive, willPresent, and didRegisterForRemoteNotificationsWithDeviceToken delegate methods of the Notification Center by calling the corresponding methods of the NPush instance. This allows you to handle various notification events and integrate them into your application's functionality.


### Attach contact to device subscription 

If you want to attach the current device subscription to the logged-in user in your application, you need to have a way to identify the user. This can be achieved through a hash, an ID, or any unique identifier associated with the user in the NP6 platform.

Please note that these identifiers are specific to the NP6 platform. Before proceeding, make sure that you have one of these identifiers in your user representation. This will enable you to attach the device subscription to the correct user.

### Native implementation

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

To implement NPush SDK in your React Native application, follow these steps:

### Create react package  

Create a new file implementation file called NPushModule.h.

<details>

<summary>Objective-c</summary>

```objective-c
#import <React/RCTBridgeModule.h>
@interface RCTNPushModule : NSObject <RCTBridgeModule>
@end
```

</details>

Create a new implementation file called RCTNPushModule.m in the same folder.

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

This code sets up the basic structure of the module and exports it with the name "RCTNPushModule".


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

To implement the NPush SDK in Flutter, you can create a new dart class called NPush.dart and add the following method to it:
    
<details>

<summary>dart</summary>

```dart
class NPush {
  static const platform = MethodChannel('np6.messaging.npush/contact');

  static Future<void> setContactById(String value) async {
    var result = await platform
        .invokeMethod('SetContactById', {"value": value});

    return result;
  }
}
```

</details>

This method uses the MethodChannel class to communicate with the native platform, and the setContactById function takes a string parameter, which should be the identifier of the user you want to attach the device subscription to.

To use this method, simply import the NPush.dart file into your Flutter project and call the setContactById function with the appropriate user identifier value.


### Implement native channel

To implement the native channel for Flutter, you'll need to open the AppDelegate.swift file and override the application(_:didFinishLaunchingWithOptions:) method.

First, create a FlutterViewController and get the binaryMessenger property from it.

Next, create a FlutterMethodChannel with a unique name (in this example, we use np6.messaging.npush/contact). Set the method call handler for this channel to handle incoming method calls.

In this example, we create a SetContactById method call to set the user's contact by ID. We guard against any other method calls and return FlutterMethodNotImplemented if the method name doesn't match.

We then extract the value of the contact from the arguments passed in the method call and set the contact using NPush.instance.SetContact(type: ContactType.IdRepresentation, value: value).

If there are any errors during the process, we return a FlutterError.

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
      
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
```

</details>

The call the dart module **NPush.dart** inside the flutter application : 
   
<details>

<summary>dart</summary>

```dart
NPush.setContactById("000T315");
```

</details>
 
 
If everything is done. You will see the following lines in your application log :

```
I/np6-messaging: Subscription created successfully
```

