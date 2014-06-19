//
//  monthCalenderViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 16/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "NVDate.h"
#import "monthCalenderCell.h"
#import "jsonReader.h"
#import "Session.h"
#import "calenderViewController.h"

@protocol monthCalenderDelegate <NSObject>

-(void)sendDateToAgendaWithDate:(NSDate *) Date;

@end

@interface monthCalenderViewController : UIViewController



@property UIView *currentCalenderView;

@property NSDate *dayDate;
@property NSDate *todayDate;
@property NVDate *firstDateOfCalender;
@property NVDate *calDate;

@property (weak, nonatomic) id<SelectDateDelegate> monthCalenderDelegate;
@property bool hasResized;

@end
