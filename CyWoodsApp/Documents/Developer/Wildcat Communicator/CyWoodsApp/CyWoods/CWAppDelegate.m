//
//  CWAppDelegate.m
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWAppDelegate.h"

@implementation CWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    loadingViews = [NSMutableArray array];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    CWHomeController *home = [[CWHomeController alloc] init] ;
    grade = [[CWGradeController alloc] init];
    CWTeacherController *teach = [[CWTeacherController alloc] init];
    CWExtraController *extra = [[CWExtraController alloc] init];
    
    UINavigationController *hcon = [[UINavigationController alloc]
                                    initWithRootViewController: home];
    gcon = [[UINavigationController alloc]
                                     initWithRootViewController: grade];
    tcon = [[UINavigationController alloc]
                                      initWithRootViewController: teach];
    UINavigationController *econ = [[UINavigationController alloc]
                                initWithRootViewController: extra];
    
    [teach setup];
    [grade setup];
    [home setup];
    [extra setup];
    
    [grade refresh];
    
    tabs = [[UITabBarController alloc] init];
    tabs.delegate = self;
    
    [tabs setViewControllers:[NSArray arrayWithObjects:hcon, gcon, tcon, econ, nil]];
    
    self.window.rootViewController = tabs;
    
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //self.window.tintColor = [UIColor blackColor];
    
    NSDictionary *pushNotificationPayload = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(pushNotificationPayload) {
        [self application:application didReceiveRemoteNotification:pushNotificationPayload];
    }
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"SIMULATOR");
    [[CWDataStore sharedInstance] setDevid:@"6f502bc97dcc867a5c4ae6def5de7d6a368b58da722906fa40644de8a29b4def"];
#endif
    
    return YES;
}

-(void)addLoading:(NSString *)msg{
    CGRect frame = tabs.tabBar.frame;
    CGRect f2 = self.window.frame;
    CWLoadingView *loading = [[CWLoadingView alloc] initWithFrame:CGRectMake(0, f2.size.height-frame.size.height-20, frame.size.width, 20)];
    loading.label.text = msg;
    [self.window addSubview:loading];
    [loadingViews addObject:loading];
}

-(void)stopLoading{
    [[loadingViews objectAtIndex:loadingViews.count-1] hide];
    [loadingViews removeObjectAtIndex:loadingViews.count-1];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if( gcon == tabBarController.selectedViewController && [gcon.topViewController isKindOfClass:[CWLoginController class]] )
        return viewController != tabBarController.selectedViewController;
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	//NSLog(@"My token is: %@", deviceToken);
    NSString *devid = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    devid = [devid stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[CWDataStore sharedInstance] setDevid:devid];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	//NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[CWDataStore sharedInstance] refresh];
    //NSLog(@"ACTIVE");
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    /*[[CWDataStore sharedInstance] gradesClear];
    [grade refresh];*/
    id dict = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString * msg = nil;
    if( [dict isKindOfClass:[NSDictionary class]])
        msg = [dict objectForKey:@"body"];
    else
        msg = dict;
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
