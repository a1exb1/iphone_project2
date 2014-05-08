//
//  ViewController.h
//  DSLCalendarViewExample
//
//  Created by Pete Callaway on 12/08/2012.
//  Copyright (c) 2012 Pete Callaway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"
#import "AgendaViewController.h"

@protocol SelectDateDelegate <NSObject>

-(void)sendDateToAgendaWithDate:(NSDate *) Date;

@end

@interface SelectDateViewController : UIViewController <DSLCalendarViewDelegate>

@property (weak, nonatomic) id<SelectDateDelegate> selectDateViewControllerDelegate;
@end
