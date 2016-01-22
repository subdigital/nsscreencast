Purpose
--------------

FXReachability is a lightweight reachability class for Mac and iOS. It is designed to be as simple as possible, with no extraneous bells and whistles.


Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 8.1 / Mac OS 10.10 (Xcode 6.0, Apple LLVM compiler 6.0)
* Earliest supported deployment target - iOS 5.0 / Mac OS 10.7
* Earliest compatible deployment target - iOS 4.3 / Mac OS 10.6

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

FXReachability requires ARC. If you wish to use FXReachability in a non-ARC project, just add the -fobjc-arc compiler flag to the FXReachability.m class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click FXReachability.m in the list and type -fobjc-arc into the popover.

If you wish to convert your whole project to ARC, comment out the #error line in FXReachability.m, then run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for (including FXReachability.m) are checked.


Thread Safety
--------------

FXReachability instances are designed to be accessed only from the main thread. Notifications will always be sent on the main thread, regardless of which thread the FXReachability instance was created on.


Installation
---------------

To use FXReachability, just drag the class files into your project and add the SystemConfiguration framework to your build phases. FXReachability is a self-instantiating singleton, so there's no need to create an instance of it.


Usage
-----------------

FXReachability automatically creates and runs a shared instance when your application launches. You can access this via the `[FXReachability sharedInstance]` method. You cannot delete this instance, but you can change the host that it is looking for, or create additional FXReachability instances to look for other hosts.

To use FXReachability, just add an observer for the `FXReachabilityStatusDidChangeNotification` notification, as follows:

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myUpdateMethod:) name:FXReachabilityStatusDidChangeNotification object:nil];

The object parameter can be set to a specific FXReachability instance, or set to nil to observe all instances. In your notification handler method, you can then use the following code to determine if the device has a network connection:

    FXReachability *reachability = notification.object;
    BOOL reachable = [reachability isReachable];

Or, if you are using the shared FXReachability instance, you can just use the following:

    BOOL reachable = [FXReachability isReachable];

To find out the exact status, use the following:
    
    FXReachability *reachability = notification.object;
    FXReachabilityStatus status = reachability.status;

You can also poll these properties and methods at any time to determine the current status.



Methods
----------------

The FXReachability class has the following methods  and properties:

    - (instancetype)initWithHost:(NSString *)hostDomain;

This method initializes a new FXReachability instance and immediately begins a search for the specified host, after which a notification will be sent. It is the responsiblity of the caller to retain a reference to the returned instance. If the FXReachability instance is released, no further notifications will be sent for that host.

    - (BOOL)isReachable;

This method returns YES if the host is reachable, and NO if it isn't. Note that reachability is inherently *optimistic* - a return value of NO means that you definitely can't make a network connection, but a value of YES only means that you *may* be able to (for example, the site you are trying to connect to may be down). For this reason, `-isReachable` will return YES if the status is currently unknown, to prevent spurious errors.

    + (instancetype)sharedInstance;

This returns the singleton shared instance of the FXReachability class. By default, this is set to use the apple.com host, but you can override this to use a different host.

    + (BOOL)isReachable;

This is a convenience method that calls `-isReachable` on the shared FXReachability instance.

    @property (nonatomic, readonly) FXReachabilityStatus status;

This property returns the current reachability status. For obvious reasons, it's read-only. For a list of possible status values, see below.

    @property (nonatomic, copy) NSString *host;

This property gets the current host that is being used for checking reachability. This is a read/write property. Setting this property will cause the FXReachability instance to stop observing the previous host and start observing the new one. Settting this property will immediately set the status to `FXReachabilityStatusUnknown`, but no notifications will be sent until the new host has either been successfuly contacted, or deemed to be inaccessible.


FXReachabilityStatus
-------------------------

The `[FXReachability sharedInstance].status` property is a constant which can have one of the following values:

    FXReachabilityStatusUnknown
    
This means that the status is not currently known. This is usually the case prior to the first time that the `FXReachabilityStatusDidChangeNotification` has fired, but will not usually occur otherwise.
    
    FXReachabilityStatusNotReachable
    
This means that the device does not currently have access to the internet.
    
    FXReachabilityStatusReachableViaWWAN
    
This means that the device currently has a mobile data connection (e.g. 3G) and may therefore have poor bandwidth and/or metered data. You may wish to pause large downloads or reduce the quality of streaming video in this case. Note that this status is only supported on iOS devices - a Mac that is using a tethered connection or a 3G dongle will not report that this is the case.
    
    FXReachabilityStatusReachableViaWiFi
    
This means that the device has either a WiFi or ethernet broadband connection, and can be presumed to have reasonable bandwidth and/or unmetered access. Note that a Mac will report that is has this status even if it is actually sharing a mobile data connection from an iPhone or 3G dongle.


Release Notes
------------------

Version 1.3.1

- Minor cleanup

Verson 1.3

- Added ability to set and get the host used for reachability testing
- Added the ability to create new/multiple FXReachability instances with different hosts
- Added `FXReachabilityNotificationHostKey` to the notification's userInfo
- Now requires ARC

Version 1.2

- Added `FXReachabilityNotificationPreviousStatusKey` to the notification's userInfo

Version 1.1.1

- Now complies with -Weverything warning level

Version 1.1

- Added `+isReachable` convenience method

Version 1.0

- Initial release