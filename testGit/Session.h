//
//  Session.h
//  testGit
//
//  Created by Alex Bechmann on 12/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"
#import "Tutor.h"
#import "calenderViewController.h"

@interface Session : NSObject

@property Client *client;
@property Tutor *tutor;
@property bool hasSetAgendaToDetail;
@property UIViewController *calController;
@property bool shouldHideMasterInLandscape;
@property bool shouldHideMasterInPortrait;

@property UIBarButtonItem *menuButtonStyle;

@property UISplitViewController *mainSplitViewController;

@end
