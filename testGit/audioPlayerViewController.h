//
//  audioPlayerViewController.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 28/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioNote.h"
#import "AFSoundManager.h"
#import "Session.h"

@interface audioPlayerViewController : UIViewController <AFSoundManagerDelegate>

@property AudioNote *note;
@property Lesson *lesson;

@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *pauseButton;


@property (nonatomic, strong) IBOutlet UILabel *elapsedTime;
@property (nonatomic, strong) IBOutlet UILabel *timeRemaining;
@property (nonatomic, strong) IBOutlet UISlider *slider;

@end
