//
//  tutor.m
//  testGit
//
//  Created by Alex Bechmann on 27/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "Tutor.h"

@implementation Tutor

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.tutorID = 0;
        self.accountType = 2;
    }
    
    return self;
    
}

-(void)load{
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=login&id=0&username=bm.fiona&password=fff&ts=%f", [[NSDate date] timeIntervalSince1970]];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc]init];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    _array = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [_delegate finishLoading];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
}


@end
