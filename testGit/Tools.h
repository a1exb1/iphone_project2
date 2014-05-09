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

+(void)setNavigationHeaderColorWithNavigationController: (UINavigationController *)view  andTabBar: (UITabBar*)tabBar andBackground: (UIColor *)bgCol andTint: (UIColor *)tint theme: (NSString *)theme;

+(void)addShadowToViewWithView:(UIView *)view;

+(UIColor *) defaultNavigationBarColour;

+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size;

+ (NSDate *)getFirstDayOfTheWeekFromDate:(NSDate *)givenDate;
+ (NSDate *)getLastDayOfTheWeekFromDate:(NSDate *)givenDate;

@end
