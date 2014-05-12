//
//  audioNoteViewController.h
//  testGit
//
//  Created by Alex Bechmann on 10/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface audioNoteViewController : UIViewController <AVAudioRecorderDelegate>

@property Lesson *lesson;
@property (weak, nonatomic) IBOutlet UILabel *recStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *recButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property bool isRecording;
@property bool isPlaying;

@property NSURL *tempRecFile;

@property AVAudioRecorder *recorder;
@property AVAudioPlayer *player;
-(IBAction)recording;
-(IBAction)playback;
@end
