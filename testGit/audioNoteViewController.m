//
//  audioNoteViewController.m
//  testGit
//
//  Created by Alex Bechmann on 10/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "audioNoteViewController.h"

@interface audioNoteViewController ()

@end

@implementation audioNoteViewController

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
    _isRecording = NO;
    _playButton.hidden = YES;
    _recStateLabel.text = @"Not Recording";
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
   
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [audioSession setActive:YES error:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{

    NSFileManager *fileHandler = [NSFileManager defaultManager];
    [fileHandler removeItemAtPath:_tempRecFile error:nil];
    _recorder=nil;
    _tempRecFile=nil;
    _playButton.hidden = YES;
    


}

-(IBAction)recording{
    if(_isRecording == NO){
        _isRecording = YES;
        [_recButton setImage:[UIImage imageNamed:@"Button Record Active.png"]  forState:UIControlStateNormal];
        _playButton.hidden = YES;
        _recStateLabel.text = @"Recording";
        _tempRecFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"VoiceFile"]];
        _recorder = [[AVAudioRecorder alloc]initWithURL:_tempRecFile settings: nil error:nil];
        
        [_recorder setDelegate:self];
        [_recorder prepareToRecord];
        [_recorder record];
    }
    
    else{
        _isRecording = NO;
        [_recButton setImage:[UIImage imageNamed:@"Button Record.png"] forState:UIControlStateNormal];
        _playButton.hidden = NO;
        _recStateLabel.text = @"Not Recording";
        [_recorder stop];
        [_playButton setImage:[UIImage imageNamed:@"Button Play.png"]  forState:UIControlStateNormal];
    }

}

-(IBAction)playback{

    if(_isPlaying ==NO){
        _isPlaying = YES;
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:_tempRecFile error:nil];
        _player.volume =1;
        [_player play];
        [_playButton setImage:[UIImage imageNamed:@"Button White Stop.png"] forState:UIControlStateNormal];
         _recStateLabel.text = @"Playing";
    }
    
    else{
        _isPlaying = NO;
        _player = [[AVAudioPlayer alloc]init ];
        [_playButton setImage:[UIImage imageNamed:@"Button Play.png"] forState:UIControlStateNormal];
         _recStateLabel.text = @"Stopped";
    }
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

-(void)recordingInterval{
    
    
    
    
//    minutes = floor(326.4/60)
//    seconds = round(326.4 - minutes * 60)
}



@end
