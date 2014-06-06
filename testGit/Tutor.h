//
//  tutor.h
//  testGit
//
//  Created by Alex Bechmann on 27/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "User.h"

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

-(void)load;


@end
