//
//  Tools.m
//  testGit
//
//  Created by Alex Bechmann on 04/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "Tools.h"

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

@end
