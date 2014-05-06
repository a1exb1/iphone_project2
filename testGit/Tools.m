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

+(void)showLoader{
    if(indicator != NULL){
        [self hideLoader];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = window.rootViewController.view;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = view.center;
    [view addSubview:indicator];
    //[view.window addSubview:indicator];
    [indicator bringSubviewToFront:view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
}

+(void)hideLoader{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //_statusLbl.hidden = YES;
    [indicator stopAnimating];
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
    else if (tint != nil && tint != [UIColor whiteColor]) {
        tabCol = tint;
    }
    else{
        tabCol = bgCol;
    }
    
    [tabBar setTintColor:tabCol];
}

@end
