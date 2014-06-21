//
//  jsonReader.h
//  PlanIt!
//
//  Created by Alex Bechmann on 14/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol jsonDelegate <NSObject>
- (void) finished:(NSString *)status withArray:(NSArray *)array;
@end



@interface jsonReader : NSObject

@property (nonatomic, assign) id<jsonDelegate> delegate;

+(NSArray*)jsonRequestWithUrl:(NSString*)urlString;
+(NSArray*)jsonAsyncRequestWithUrl:(NSString*)urlString;
-(void)jsonAsyncRequestWithDelegateAndUrl:(NSString*)urlString;

@end
