//
//  Client.m
//  testGit
//
//  Created by Thomas Kjær Christensen on 12/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "Client.h"

@implementation Client



//extern Session *session;

//-(void)loadTutors{
//    
//    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%ld&ts=%f", self.clientID, [[NSDate date] timeIntervalSince1970]];
//    
//    NSURL *url = [NSURL URLWithString: urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection connectionWithRequest:request delegate:self];
//    
//}
//
//-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
//{
//    _data = [[NSMutableData alloc]init];
//    
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
//{
//    [_data appendData:theData];
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    
//    _array = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
//    [_delegate finishLoading];
//    
//}
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [errorView show];
//}

-(void)loadTutorsAsyncWithDelegate:(id)loadDelegate
{
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%ld", self.clientID ]; // untested
    jsonReader *reader = [[jsonReader alloc] init];
    reader.delegate = loadDelegate;
    [reader jsonAsyncRequestWithDelegateAndUrl:urlString];
}

-(void)loadCourses
{
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsandcoursesbyclient&id=%li", [self clientID]];
    
    
    self.courses = [jsonReader jsonRequestWithUrl:urlString];
    
    
}

-(void)loadCoursesAsyncWithDelegate:(id)loadDelegate
{
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsandcoursesbyclient&id=%li", [self clientID]];
    jsonReader *reader = [[jsonReader alloc] init];
    reader.delegate = loadDelegate;
    [reader jsonAsyncRequestWithDelegateAndUrl:urlString];
    
}

-(void)loadStudents
{
    //NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=studentsbytutor&id=%li&", [[self tutor] tutorID]];
}

@end
