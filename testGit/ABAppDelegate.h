//
//  ABAppDelegate.h
//  testGit
//
//  Created by Alex Bechmann on 17/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

#import "DetailViewManager.h"

#import "loginViewController.h"
#import "ManageTableViewController.h"



@class ViewController;

@interface ABAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) DetailViewManager *detailViewManager;

@end
