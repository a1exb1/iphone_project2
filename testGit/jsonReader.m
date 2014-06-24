//
//  jsonReader.m
//  PlanIt!
//
//  Created by Alex Bechmann on 14/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "jsonReader.h"

@implementation jsonReader

+(NSArray*)jsonRequestWithUrl:(NSString*)urlString
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    NSArray *arr = [[NSArray alloc] init];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (response == nil) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorView show];
    } else {
        arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return arr;
}

+(NSArray*)jsonAsyncRequestWithUrl:(NSString*)urlString
{
    NSArray *arr = [[NSArray alloc] init];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (response == nil) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorView show];
    } else {
        arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    return arr;
}

-(void)jsonAsyncRequestWithDelegateAndUrl:(NSString*)urlString;
{
    __block NSArray *arr = [[NSArray alloc] init];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    //NSURLResponse *response = nil;
    //NSError *error = nil;
    
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (response == nil) {
//        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [errorView show];
//    } else {
//        arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    }
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){

        if (response == nil) {
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorView show];
        } else {
            arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate finished:@"load" withArray:arr];
        });
    }];
}


@end
