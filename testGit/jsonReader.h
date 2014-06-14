//
//  jsonReader.h
//  PlanIt!
//
//  Created by Alex Bechmann on 14/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jsonReader : NSObject

+(NSArray*)jsonRequestWithUrl:(NSString*)urlString;

@end
