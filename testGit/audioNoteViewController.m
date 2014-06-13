//
//  audioNoteViewController.m
//  testGit
//
//  Created by Alex Bechmann on 10/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "audioNoteViewController.h"
#import "Tools.h"


@interface audioNoteViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *playbackWebView;
@property (weak, nonatomic) IBOutlet ADBannerView *banner;

@end



@implementation audioNoteViewController

extern Session *session;

@synthesize secondsSinceStart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)existingFilePlayback
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(320, 568); // size of view in popover
    self.preferredContentSize = size;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
     [super viewDidLoad];
    _isRecording = NO;
    _playButton.hidden = YES;
    _recStateLabel.text = @"Not Recording";
    _playbackTimerLabel.hidden = YES;
    
    //CREATE NEW AUDIO SESSION
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    self.title = @"Record audio note";
    
    _existingPlayBtn.hidden = YES;
    
    if ([_note studentNoteID] > 0) {
        _playButton.hidden = YES;
        _recButton.hidden = YES;
        _timerLabel.hidden = YES;
         [self startPlayback];
        _recStateLabel.hidden = YES;
        self.title = @"Audio note";
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteNote)];
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: deleteBtn, nil]];
    }
    else{

    }
    
    //this bit maybe unnecessary
    if ([[session client] premium] == 1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [self.banner setAlpha:1];
        [UIView commitAnimations];
    }
    
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"%d", [[session client] premium]);
    if ([[session client] premium] == 1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [banner setAlpha:1];
        [UIView commitAnimations];
    }
    
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}

-(void)deleteNote
{
    [Tools showLoader];
    
    _data = [[NSMutableData alloc]init];
    _noteSaveArray = [[NSArray alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=textnote&id=%li&delete=delete&clientid=%li&ts=%f", [_note studentNoteID], [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    
    NSLog(@"%@", urlString);
    
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
    [Tools hideLoader];
    _saveResultArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"0"])
    {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error with saving." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorView show];
        
    }
    
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error with saving." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorView show];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [Tools hideLoader];
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
}


- (void) save
{
    [Tools showLoader];
    
    //GET FILE FROM TEMPOARY LOCATION AND CONVERT TO NSDATA FOR DATA TRANSMISSION
    NSURL *pathURL = _tempRecFile; //File Url of the recorded audio
    NSData *voiceData = [[NSData alloc]initWithContentsOfURL:pathURL];
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/upload_file.aspx?datatype=audio&id=0&studentid=%li&lessonid=%li&clientid=%li", [[_lesson student] studentID], [_note lessonID], [[session client] clientID]]; // You can give your url here for uploading
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    
    @try
    {
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\".wav\"\r\n"]dataUsingEncoding:NSUTF8StringEncoding]]; // .caf ?
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:voiceData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        NSError *error = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
        UIAlertView *alert = nil;
        if(error)
        {
            alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Error in Uploading the File" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            //NSLog(@"Success %@",returnString);
            ///alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"File get uploaded" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [alert show];
        alert = nil;
        returnString = nil;
        boundary = nil;
        contentType = nil;
        body = nil;
    }
    @catch (NSException * exception)
    {
        NSLog(@"pushLoader in ViewController :Caught %@ : %@",[exception name],[exception reason]);
    }
    @finally
    {
        voiceData = nil;
        pathURL = nil;
        urlString = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{

    NSFileManager *fileHandler = [NSFileManager defaultManager];
    [fileHandler removeItemAtPath:[NSString stringWithFormat:@"%@", _tempRecFile] error:nil];
    _recorder=nil;
    _tempRecFile=nil;
    _playButton.hidden = YES;
}

-(void) startRecording{
    
    _isRecording = YES;
    [_recButton setImage:[UIImage imageNamed:@"Button Record Active.png"]  forState:UIControlStateNormal];
    _playButton.hidden = YES;
    _recStateLabel.text = @"Recording";
    
    //SET TEMPORARY RECORDING FILE
    _tempRecFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"VoiceFile"]];
    
    //SETTINGS
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,// kAudioFormatLinearPCM
                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                              [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                              [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,nil];
    
    //ALLOCATE RECORDER WITH TEMPORARY FILE AND SETTINGS DICTIONARY
    _recorder = [[AVAudioRecorder alloc]initWithURL:_tempRecFile settings: recordSettings error:nil];
    
    //SET DELEGATE AND PREPARE FOR RECORDING
    [_recorder setDelegate:self];
    [_recorder prepareToRecord];
    
    //RECORD
    [_recorder record];

    _timerLabel.text = @"00:00";
    secondsSinceStart = (NSInteger)[[NSDate date] timeIntervalSinceDate:[[NSDate alloc]init]];
    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    
    _timerLabel.hidden = NO;
    _playbackTimerLabel.hidden = YES;
    [self updateRecordLabel];
}


-(void) stopRecording{
    _isRecording = NO;
    [_recButton setImage:[UIImage imageNamed:@"Button Record.png"] forState:UIControlStateNormal];
    _playButton.hidden = NO;
    _recStateLabel.text = @"Not Recording";
    [_recorder stop];
    [_playButton setImage:[UIImage imageNamed:@"Button Play.png"]  forState:UIControlStateNormal];
    [_timer invalidate];
    _playbackTimerLabel.text = [NSString stringWithFormat:@"00:00 / %@", [Tools convertSecondsToTimeStringWithSeconds:(int)_recordedSoundLength]];
    _playbackTimerLabel.hidden = NO;
    _timerLabel.hidden = YES;
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, nil]];
    
    
}

-(void)showUpgradeAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Record time exceeded!"
                                                    message:@"To record more than 15 seconds, upgrade to premium."
                                                   delegate:self    // <------
                                          cancelButtonTitle:@"Maybe later"
                                          otherButtonTitles:@"Upgrade now", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [[session client] setPremium:1];
        
    }
    
}

-(void) startPlayback{
    if ([_note studentNoteID] == 0) {
        _isPlaying = YES;
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:_tempRecFile error:nil];
        _player.volume =1;
        [_player play];
        [_playButton setImage:[UIImage imageNamed:@"Button White Stop.png"] forState:UIControlStateNormal];
        _recStateLabel.text = @"Playing";
        _PlaybackSecondsSinceStart = (NSInteger)[[NSDate date] timeIntervalSinceDate:[[NSDate alloc]init]];
        _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePlayback:) userInfo:nil repeats:YES];
        [self updatePlaybackFunction];
    }
    else{
        //NSLog(@"%@", [_note filename]);
        _existingPlayBtn.hidden = YES;
        NSString *stream = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/uploads/%li/audio_files/%@", [[session client] clientID], [_note filename]]; //000045_75c1ab.mp3
        
        NSLog(@"%@", stream);
        
        NSURL *url = [NSURL URLWithString:stream];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_playbackWebView loadRequest:request];
    }
}

-(void) stopPlayback{
    _isPlaying = NO;
    _player = [[AVAudioPlayer alloc]init ];
    [_playButton setImage:[UIImage imageNamed:@"Button Play.png"] forState:UIControlStateNormal];
    _recStateLabel.text = @"Stopped";
    _playbackTimerLabel.text = [NSString stringWithFormat:@"00:00 / %@", [Tools convertSecondsToTimeStringWithSeconds:(int)_recordedSoundLength]];
    [_timer invalidate];
}

-(IBAction)recording{
    if(_isRecording == NO){
        [self startRecording];
    }
    else{
        [self stopRecording];
    }

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[Tools hideLoader];
}



-(IBAction)playback{

    if(_isPlaying ==NO){
        [self startPlayback];
    }
    
    else{
        [self stopPlayback];
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
    
   
    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(onTick:)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
    [inv setTarget: self];
    [inv setSelector:@selector(onTick:)];
    
    NSTimer *t = [NSTimer timerWithTimeInterval: 1.0
                                     invocation:inv
                                        repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: t forMode: NSDefaultRunLoopMode];

    
    
  
}

-(void)onTick:(NSTimer *)timer {
    [self updateRecordLabel];

}

-(void)updateRecordLabel{
    int maxCount = 15;
    if([[session client] premium] ==0){
        maxCount = 30;
        
    }
    int secondsFromMax = maxCount - (int)secondsSinceStart;
    if(secondsFromMax == -1)
    {
        [self stopRecording];
        // premium 0 = premium account & 1 = standard account
        if([[session client] premium] == 1 && [[session tutor] accountType] <=1){
            
            [self showUpgradeAlert];
        }
    }
    
    
    
    
    NSInteger seconds = secondsFromMax % 60;
    NSInteger minutes = (secondsFromMax / 60) % 60;
    NSInteger hours = secondsFromMax / (60 * 60);
    NSString *result = nil;
    if (hours > 0) {
        result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    }
    else {
        result = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }
    _timerLabel.text = result;
    _recordedSoundLength = (int)secondsSinceStart;
    NSLog(@"%ld", (long)secondsSinceStart);
    secondsSinceStart++;
}


-(void)updatePlayback:(NSTimer *)timer {
    [self updatePlaybackFunction];
    
}

-(void)updatePlaybackFunction{
    if (_PlaybackSecondsSinceStart < secondsSinceStart) {
        
        NSInteger seconds = _PlaybackSecondsSinceStart % 60;
        NSInteger minutes = (_PlaybackSecondsSinceStart / 60) % 60;
        NSInteger hours = _PlaybackSecondsSinceStart / (60 * 60);
        NSString *result = nil;
        if (hours > 0) {
            result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
        }
        else {
            result = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
        }
        _playbackTimerLabel.text = [NSString stringWithFormat:@"%@ / %@", result, [ Tools convertSecondsToTimeStringWithSeconds:(int)_recordedSoundLength]];
        _PlaybackSecondsSinceStart++;
    }
    else{
        [self stopPlayback];
    }
}



@end
