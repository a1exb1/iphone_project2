//
//  Tools.h
//  testGit
//
//  Created by Alex Bechmann on 04/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVPullToRefresh.h"
#import "NVDate.h"
#import "Session.h"

@protocol ToolsDelegate <NSObject>

-(void)completion;

@end

@interface Tools : NSObject

@property id<ToolsDelegate> ToolsDelegate;

+(void)showLoader;
+(void)showLightLoader;
+(void)showLoaderWithView:(UIView *) view;
+(void)showLightLoaderWithView:(UIView *) view;

+(void)hideLoader;
+(void)hideLoaderFromView:(UIView *) view;

+(void)lockInputWithFrame: (CGRect)frame;
+(void)unlockInputWithView;

+(void)showActivityIndicator;
+(void)hideActivityIndicator;

// Assumes input like "#00FF00" (#RRGGBB)
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

+ (BOOL) isOrientationLandscape;

+(NSString *) nowIsBetweenDate1: (NSDate *) date1 andDuration:(int)duration;

+ (NSDate *)beginningOfDay:(NSDate *)date;

+(NSArray *)daysOfWeekArray;
+(NSArray *)daysOfWeekArraySundayFirst;

+(void)setModalSizeOfView:(UIView *)view;

+(int)currentDayOfWeekFromDate:(NSDate *)date;

+(NSString *)monthName:(int)month;
//+(NSDateComponents *)dateComponentFromDate: (NSDate *)date;

+ (void)marginedtableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

+(NSString *)formatDate:(NSDate *)Date withFormat:(NSString *)format;

+(NSDate *) dateRoundedDownTo5Minutes:(NSDate *)dt;
@end
