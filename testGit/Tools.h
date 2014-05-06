//
//  Tools.h
//  testGit
//
//  Created by Alex Bechmann on 04/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVPullToRefresh.h"

@interface Tools : NSObject

+(void)showLoader;
+(void)hideLoader;

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString;

+(void)setNavigationHeaderColorWithNavigationController: (UINavigationController *)view  andBackground: (UIColor *)bgCol andTint: (UIColor *)tint theme: (NSString *)theme;


@end
