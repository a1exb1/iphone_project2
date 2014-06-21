//
//  Client.h
//  testGit
//
//  Created by Thomas Kjær Christensen on 12/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "User.h"
#import "jsonReader.h"

@protocol clientDelegate <NSObject>
- (void) finishLoading; // not used any more ?
@end

@interface Client : User


@property int premium;
@property long clientID;
@property NSString *clientUserName;

@property (nonatomic, assign) id<clientDelegate> delegate;
@property NSArray *array;
@property NSMutableData *data;
@property NSArray *courses;

-(void)loadTutors;
-(void)loadTutorsAsyncWithDelegate:(id)loadDelegate;

-(void)loadCourses;
-(void)loadCoursesAsyncWithDelegate:(id)loadDelegate;

-(void)loadStudents;



@end
