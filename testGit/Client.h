//
//  Client.h
//  testGit
//
//  Created by Thomas Kjær Christensen on 12/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "User.h"


@protocol clientDelegate <NSObject>
- (void) finishLoading;
@end

@interface Client : User


@property int premium;
@property long clientID;
@property NSString *clientUserName;

@property (nonatomic, assign) id<clientDelegate> delegate;
@property NSArray *array;
@property NSMutableData *data;


-(void)loadTutors;

@end
