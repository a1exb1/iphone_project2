//
//  tutor.h
//  testGit
//
//  Created by Alex Bechmann on 27/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "User.h"
#import "jsonReader.h"

@protocol tutorDelegate <NSObject>
- (void) finishLoading;
@end

@interface Tutor : User

@property long tutorID;
@property int accountType;
@property NSString *username;

@property (nonatomic, assign) id<tutorDelegate> delegate;
@property NSArray *array;
@property NSMutableData *data;

@property NSArray *courses;


-(void)load;

-(void)loadCoursesAsyncWithDelegate:(id)loadDelegate;

-(NSArray*)loadLessonsForDate:(NSDate *)date;
-(void)loadAgendaAsyncWithDelegate:(id)loadDelegate forDate:(NSDate *)date;

@end
