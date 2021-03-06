//
//  loginViewController.h
//  testGit
//
//  Created by Thomas Kjær Christensen on 12/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "Session.h"
#import "AgendaViewController.h"

@interface loginViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (strong, nonatomic) UITabBarController *tabController;

@property NSArray *clientArray;
@property NSMutableData *data;
-(IBAction)login:(id)sender;

@property UITabBarController *tabBar;

@property BOOL hasJustLoggedOut;

@end
