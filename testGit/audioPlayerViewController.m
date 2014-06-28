//
//  audioPlayerViewController.m
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 28/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "audioPlayerViewController.h"

@interface audioPlayerViewController ()

@end

@implementation audioPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[AFSoundManager sharedManager]setDelegate:self];
    [self startPlayback];
}

-(void)startPlayback
{
    [[AFSoundManager sharedManager]startStreamingRemoteAudioFromURL:@"http://www.royaltyfreemusic.com/music_clips/free/Big_Blues_Rock_60.mp3" andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        
        if (!error) {
            NSLog(@"%d", percentage);
            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"mm:ss"];
//            
//            NSDate *elapsedTimeDate = [NSDate dateWithTimeIntervalSinceReferenceDate:elapsedTime];
//            _elapsedTime.text = [formatter stringFromDate:elapsedTimeDate];
//            
//            NSDate *timeRemainingDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeRemaining];
//            _timeRemaining.text = [formatter stringFromDate:timeRemainingDate];
//            
//            _slider.value = percentage * 0.01;
        } else {
            
            NSLog(@"There has been an error playing the remote file: %@", [error description]);
        }
        
    }];
}

-(void)currentPlayingStatusChanged:(AFSoundManagerStatus)status {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillDisappear:(BOOL)animated
{
    [[AFSoundManager sharedManager]stop];
}

@end
