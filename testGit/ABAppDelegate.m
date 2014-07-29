//
//  ABAppDelegate.m
//  testGit
//
//  Created by Alex Bechmann on 17/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "ABAppDelegate.h"



@implementation ABAppDelegate

Session *session;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[application setStatusBarStyle:UIBarStyleBlackOpaque];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Override point for customization after application launch.
    Client *client = [[Client alloc]init];
    Tutor *tutor = [[Tutor alloc] init];
    
    session = [[Session alloc] init];
    [session setClient:client];
    [session setTutor:tutor];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//        splitViewController.delegate = (id)navigationController.topViewController;
//        
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        //
        self.detailViewManager = [[DetailViewManager alloc] init];
        self.detailViewManager.splitViewController = splitViewController;
        self.detailViewManager.detailViewController = splitViewController.viewControllers.lastObject;
        splitViewController.delegate = self.detailViewManager;
        //
        if ([splitViewController respondsToSelector:@selector(setPresentsWithGesture:)])
            //[splitViewController setPresentsWithGesture:YES];
        
        return YES;
}
    
//    ManageTableViewController * leftDrawer = [[ManageTableViewController alloc] init];
//    testViewController * center = [[testViewController alloc] init];
//    //UIViewController * rightDrawer = [[UIViewController alloc] init];
//    
//    MMDrawerController * drawerController = [[MMDrawerController alloc]
//                                             initWithCenterViewController:center
//                                             leftDrawerViewController:leftDrawer];
//    
//    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    self.drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    
    return YES;
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
    
    session.didEnterForground = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
