//
//  Tools.m
//  testGit
//
//  Created by Alex Bechmann on 04/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "Tools.h"
#import "ABAppDelegate.h"


@implementation Tools

UIActivityIndicatorView *indicator;
UIView *blockView;
NSMutableArray *loaderViews;

+(void)showLoader{
    if(indicator != NULL){
        [self hideLoader];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = window.rootViewController.view;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    indicator.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    [indicator setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.25]];
    indicator.center = view.center;
    [window addSubview:indicator];
    //[view.window addSubview:indicator];
    [indicator bringSubviewToFront:view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
}

+(void)showLightLoader{
   
    if(indicator != NULL){
        [self hideLoader];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = window.rootViewController.view;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //CGRect screenBound = [[UIScreen mainScreen] bounds];
    //CGSize screenSize = screenBound.size;

    
    //indicator.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    //[indicator setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.25]];
    indicator.center = view.center;
    [window addSubview:indicator];
    //[view.window addSubview:indicator];
    [indicator bringSubviewToFront:view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
}

+(void)showLightLoaderWithView:(UIView *)view{
    
    UIActivityIndicatorView *UILoaderView;
    
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //UIView *view = window.rootViewController.view;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UILoaderView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    UILoaderView.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height);
    [UILoaderView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.25]];
    UILoaderView.center = view.center;
    UILoaderView.accessibilityValue = @"loader";
    [view addSubview:UILoaderView];
    //[view.window addSubview:indicator];
    [view bringSubviewToFront:UILoaderView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [UILoaderView startAnimating];
}

+(void)showLoaderWithView:(UIView *)view{
    
    UIActivityIndicatorView *UILoaderView;
    
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //UIView *view = window.rootViewController.view;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UILoaderView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    UILoaderView.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height);
    //[UILoaderView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.25]];
    UILoaderView.center = view.center;
    UILoaderView.accessibilityValue = @"loader";
    [view addSubview:UILoaderView];
    //[view.window addSubview:indicator];
    [view bringSubviewToFront:UILoaderView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [UILoaderView startAnimating];
}

+(void)hideLoaderFromView:(UIView *)view
{
    for (UIActivityIndicatorView *ca in view.subviews) {
        if ([ca.accessibilityValue isEqualToString: @"loader"]) {
            [ca removeFromSuperview];
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


+(void)hideLoader{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //_statusLbl.hidden = YES;
    [indicator stopAnimating];
}



+(void)unlockInputWithView
{
    blockView.hidden = YES;
}

+(void)lockInputWithFrame: (CGRect)frame
{
    if(blockView != NULL){
        [self unlockInputWithView];
    }
    blockView.hidden = NO;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = window.rootViewController.view;
    
    
    blockView = [[UIView alloc] init];
        
    blockView.frame = frame;
    [blockView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.25]];
    blockView.center = view.center;
    [view addSubview:blockView];
    //[view.window addSubview:indicator];
    [view bringSubviewToFront:blockView];


}

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(void)setNavigationHeaderColorWithNavigationController: (UINavigationController *)view andTabBar: (UITabBar*)tabBar andBackground: (UIColor *)bgCol andTint: (UIColor *)tint theme: (NSString *)theme
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if([theme isEqualToString:@"dark"])
    {
        //status bar
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        //title colour
        view.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
    else{
        //status bar
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        //title colour
        view.navigationBar.barStyle = UIBarStyleDefault;
    }

    view.navigationBar.barTintColor = bgCol;
    view.navigationBar.tintColor = tint;
    [view.navigationBar setTranslucent:YES];
    
    UIColor *tabCol;
    
    if (bgCol != nil && bgCol != [UIColor whiteColor]) {
        tabCol = bgCol;
    }
    else if (tint != nil && tint != [UIColor whiteColor] && tint != [self defaultNavigationBarColour]) {
        tabCol = tint;
    }
    else{
        tabCol = bgCol;
    }
    
    [tabBar setTintColor:tabCol];
}

+(void)addShadowToViewWithView:(UIView *)view
{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(4, 4);
    view.layer.shadowRadius = 2;
    view.layer.shadowOpacity = 0.15;
}

+(UIColor *) defaultNavigationBarColour{
//   return [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    return [self colorFromHexString:@"#f8f8f8"];
}

+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSString * )convertSecondsToTimeStringWithSeconds: (int)secondsFrom
{
    NSInteger seconds = secondsFrom % 60;
    NSInteger minutes = (secondsFrom / 60) % 60;
    NSInteger hours = secondsFrom / (60 * 60);
    NSString *result = nil;
    if (hours > 0) {
        result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    }
    else {
        result = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }
    
    return result;

}

+(NSString *) convertSecondsToTimeStringWithSecondsWithAlternativeStyle: (int) secondsFrom
{
    NSInteger seconds2 = secondsFrom % 60;
    NSInteger minutes2 = (secondsFrom / 60) % 60;
    NSInteger hours2 = secondsFrom / (60 * 60);
    NSString *result = nil;
    if (hours2 > 0) {
        result = [NSString stringWithFormat:@"%lih %lim", (long)hours2, (long)minutes2];
    }
    else {
        result = [NSString stringWithFormat:@"%lim %lis", (long)minutes2, (long)seconds2];
    }
    
    return result;
}

+(NSString *) convertDateToTimeStringWithDate:(NSDate *)date;
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@""];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
}

+(UIImage*)colorAnImage:(UIColor*)color :(UIImage*)image{
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+(void)addECSlidingDefaultSetupWithViewController:(UIViewController *)vc
{
//    [vc.slidingViewController.topViewController.view addGestureRecognizer:vc.slidingViewController.panGesture];
//    
//    vc.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
//    
//    vc.view.layer.shadowOpacity = 0.75f;
//    vc.view.layer.shadowRadius = 10.0f;
//    vc.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

+(BOOL)isIpad
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return YES;
        
    }
    else{
        return NO;
    }
}

+ (BOOL) isOrientationLandscape
{
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        return YES;
    }else{
        return NO;
    }
}

+ (NSDate *)beginningOfDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
    
    return [calendar dateFromComponents:comp];
}

+(NSString *) nowIsBetweenDate1:(NSDate *)date1 andDuration:(int)duration
{
    NSString *r;
    
    //int startTime;
    //int endTime;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date1];
   // NSInteger lessonDateHour = [components hour];
    //NSInteger lessonDateMinute = [components minute];
   
    
    NVDate *lessonDate = [[NVDate alloc] initUsingDate:date1];
    NSDate *lessonEnd = lessonDate.date;
    lessonEnd = [lessonDate.date dateByAddingTimeInterval:duration*60];
    NVDate *nowDate = [[NVDate alloc] initUsingToday];
    
    NSString *dayDesc;
    
    
    if ([[self beginningOfDay:lessonDate.date] isEqualToDate:[self beginningOfDay:nowDate.date]])
    {
        if (
            ([nowDate.date timeIntervalSinceReferenceDate] > [lessonDate.date timeIntervalSinceReferenceDate]) &&
            ([nowDate.date timeIntervalSinceReferenceDate] < [lessonEnd timeIntervalSinceReferenceDate])
            ) {
            NSTimeInterval secondsBetween = [lessonEnd timeIntervalSinceDate:nowDate.date];
            dayDesc = [NSString stringWithFormat:@"Now (%@ left)", [Tools convertSecondsToTimeStringWithSecondsWithAlternativeStyle:secondsBetween]];
            
            r = @"now";
        }
        
        else if ([nowDate.date timeIntervalSinceReferenceDate] > [lessonDate.date timeIntervalSinceReferenceDate]) {
            r = @"earlier today";
        }
        
        else if ([nowDate.date timeIntervalSinceReferenceDate] < [lessonEnd timeIntervalSinceReferenceDate]) {
            //NSTimeInterval secondsBetween = [lessonDate.date timeIntervalSinceDate:nowDate.date];
            r = @"later today";
        }
    }
    
    else if ([nowDate.date timeIntervalSinceReferenceDate] > [lessonDate.date timeIntervalSinceReferenceDate]) {
        r = @"completed";
    }
    
    else if ([nowDate.date timeIntervalSinceReferenceDate] < [lessonEnd timeIntervalSinceReferenceDate]) {
        //NSTimeInterval secondsBetween = [lessonDate.date timeIntervalSinceDate:nowDate.date];
        r = @"upcoming";
    }
    
    
        return r;
}

+(NSArray *)daysOfWeekArray
{
    return [[NSArray alloc] initWithObjects:
                       @"Monday",
                       @"Tuesday",
                       @"Wednesday",
                       @"Thursday",
                       @"Friday",
                       @"Saturday",
                       @"Sunday",
                       nil];
}

+(void)setModalSizeOfView:(UIView *)view
{
    int longSide = 987;
    int shortSide = 717;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        [view.superview setBounds:CGRectMake(0, 0, shortSide, longSide)];
    }
    else{
        [view.superview setBounds:CGRectMake(0, 0, longSide, shortSide)];
    }
    
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.2f
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseOut
     
                     animations:^{
                         if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
                         {
                             [view.superview setBounds:CGRectMake(0, 0, shortSide, longSide)];
                         }
                         else{
                             [view.superview setBounds:CGRectMake(0, 0, longSide, shortSide)];
                         }
                     }
                     completion:^(BOOL finished){
                         //[self.ToolsDelegate completion];
                     }];
}

+(int)currentDayOfWeekFromDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    long weekday = [[gregorian components:NSWeekdayCalendarUnit fromDate:date] weekday];
    weekday --;
    return (int)weekday;
}

//+(NSDateComponents *)dateComponentFromDate: (NSDate *)date
//{
//    return
//}

+(NSString *)monthName:(int)month
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    return [[df monthSymbols] objectAtIndex:(month-1)];
}


@end
