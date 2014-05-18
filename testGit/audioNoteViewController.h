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
#import "AudioNote.h"
#import "Session.h"
#import "Tools.h"
#import <iAd/iAd.h>

@interface audioNoteViewController : UIViewController <AVAudioRecorderDelegate, UIWebViewDelegate, ADBannerViewDelegate>

@property Lesson *lesson;
@property (weak, nonatomic) IBOutlet UILabel *recStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *recButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *playbackTimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *existingPlayBtn;

@property AudioNote *note;

@property bool isRecording;
@property bool isPlaying;

@property NSInteger secondsSinceStart;
@property NSInteger PlaybackSecondsSinceStart;
@property NSTimer *timer;

@property NSURL *tempRecFile;

@property AVAudioRecorder *recorder;
@property AVAudioPlayer *player;
-(IBAction)recording;
-(IBAction)playback;

-(IBAction)existingFilePlayback;

@property NSMutableData *data;
@property NSArray *saveResultArray;
@property NSArray *noteSaveArray;

@property int recordedSoundLength;
@end
