//
//  Tools.h
//  testGit
//
//  Created by Alex Bechmann on 04/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVPullToRefresh.h"

#import "Session.h"

@interface Tools : NSObject

+(void)showLoader;
+(void)showLightLoader;
+(void)showLoaderWithView:(UIView *) view;

+(void)hideLoader;
//+(void)hideLoaderFromView:(UIView *) view;

+(void)lockInputWithFrame: (CGRect)frame;
+(void)unlockInputWithView;

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString;

+(void)setNavigationHeaderColorWithNavigationController: (UINavigationController *)view  andTabBar: (UITabBar*)tabBar andBackground: (UIColor *)bgCol andTint: (UIColor *)tint theme: (NSString *)theme;

+(void)addShadowToViewWithView:(UIView *)view;

+(UIColor *) defaultNavigationBarColour;

+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size;

//+ (NSDate *)getFirstDayOfTheWeekFromDate:(NSDate *)givenDate;
//+ (NSDate *)getLastDayOfTheWeekFromDate:(NSDate *)givenDate;

+(NSString *) convertSecondsToTimeStringWithSeconds: (int) seconds;
+(NSString *) convertSecondsToTimeStringWithSecondsWithAlternativeStyle: (int) seconds;
+(NSString *) convertDateToTimeStringWithDate: (NSDate *) date;

+(UIImage*)colorAnImage:(UIColor*)color :(UIImage*)image;

+(void)addECSlidingDefaultSetupWithViewController:(UIViewController *)ViewController;

+(BOOL)isIpad;

@property NSMutableArray *loaderViews;


@end
