//
//  NotesViewController.m
//  testGit
//
//  Created by Alex Bechmann on 07/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "NotesViewController.h"
#import "textNoteViewController.h"
#import "audioNoteViewController.h"
#import "TextNote.h"
#import "AudioNote.h"

@interface NotesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

NSMutableArray *textNotes;
NSMutableArray *audioNotes;

@implementation NotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//
//-(void)jsonRequestGetData
//{
//    _thisLessonNotes = [[NSMutableArray alloc] init];
//    _otherLessonNotes =[[NSMutableArray alloc] init];
//    _allNotes = [[NSArray alloc] init];
//    
//    _notes = [[NSMutableArray alloc]init];
//    [_notes addObject:_thisLessonNotes];
//    [_notes addObject:_otherLessonNotes];
//    [_lesson setNotes:_notes];
//
//    NSIndexPath *indexPath = _mainTableView.indexPathForSelectedRow;
//    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    _data = [[NSMutableData alloc]init];
//    //[_mainTableView reloadData];
//    
//    [_lesson loadNotes];
//    
//}

-(void)viewWillAppear:(BOOL)animated
{
    //CGSize size = CGSizeMake(320, 568); // size of view in popover
    //self.preferredContentSize = size;
    
    
    [super viewWillAppear:animated];
    _statusLbl.center = self.view.center;
    [self jsonRequestGetData];
    
}

-(void)jsonRequestGetData
{
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    [Tools showLoaderWithView:self.view];
    [_lesson loadNotes];
    [self.mainTableView reloadData];

    if ([[[_lesson Notes] objectAtIndex:0] count] == 0 &&
        [[[_lesson Notes] objectAtIndex:1] count] == 0) {
        _statusLbl.hidden = NO;
        _statusLbl.text = @"No notes";
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _statusLbl.hidden = YES;
    }
    
    [Tools hideLoaderFromView:self.view];
    [Tools hideLoader];
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIBarButtonItem *textNoteBtn = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addTextNote)];
    
     UIBarButtonItem *audioNoteBtn = [[UIBarButtonItem alloc]  initWithTitle: @"Add audio note" style:UIBarButtonItemStyleBordered target:self action:@selector(addAudioNote)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:textNoteBtn,audioNoteBtn, nil]];
    
    
    if(![Tools isIpad])
    {
        [_mainTableView addPullToRefreshWithActionHandler:^{
            [_lesson loadNotes];
        }];
    }
    else{
        
        
        UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(jsonRequestGetData)];
        
        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
        
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:closeBtn, refreshBtn, nil];
        
        [Tools setNavigationHeaderColorWithNavigationController:self.navigationController andTabBar:nil andBackground:nil andTint:[Tools colorFromHexString:@"#4473b4"] theme:@"light"];
        
        //[self.navigationController.navigationBar setTranslucent:NO];
        //self.navigationController.view.backgroundColor = [UIColor clearColor];
        //self.view.backgroundColor = [UIColor clearColor];
    }
    
    
}

-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addAudioNote
{
    audioNoteViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"audioNoteView"];
    view.lesson = _lesson;
    AudioNote *note = [[AudioNote alloc] init];
    [note setLessonID:[_lesson LessonID]];
    view.note = note;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)addTextNote
{
    textNoteViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"textNoteView"];
    view.lesson = _lesson;
    TextNote *note = [[TextNote alloc] init];
    [note setLessonID:[_lesson LessonID]];
    view.note = note;
    [self.navigationController pushViewController:view animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor clearColor]];
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_lesson Notes] objectAtIndex:section ] count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[_lesson Notes] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"EnteredDate"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImage *image;
    
    if([[[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"NoteType"] isEqualToString:@"text"]) {
        image =  [UIImage imageNamed:@"text_note_icon_large.png"];
    }
    else {
        image =  [UIImage imageNamed:@"audio_icon.png"];
    }

    cell.backgroundColor = [UIColor whiteColor];
    
    UIImage *buttonBk = [Tools scaleImage:image toSize:CGSizeMake(60,88.0)];
    cell.imageView.image = buttonBk;
    
    return cell;
}

- (void)updateSwitchAtIndexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([[[_lesson Notes] objectAtIndex:section ] count] == 0) {
        return 0;
    }
    else{
        return 40;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;

    if(section == 0 && [[[_lesson Notes] objectAtIndex:0] count] != 0){
        sectionName = @"Notes for this lesson";
    }
    else if([[[_lesson Notes] objectAtIndex:1] count] != 0){
        sectionName = @"All notes";
    }
    
    return sectionName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"NoteType"] isEqualToString:@"text"]){
        TextNote *note = [[TextNote alloc] init];
        [note setStudentNoteID: [[[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"StudentNoteID"] intValue]];
        [note setNote: [[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"Note"]];
        [note setLessonID: [[[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"LessonID"] intValue]];
        
        textNoteViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"textNoteView"];
        view.note = note;
        view.lesson = _lesson;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if([[[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"NoteType"] isEqualToString:@"audio"]){

        AudioNote *note = [[AudioNote alloc] init];
        [note setFilename: [[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"Filename"]];
        
        [note setStudentNoteID: [[[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"StudentNoteID"] intValue]];

        [note setLessonID: [[[[[_lesson Notes] objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"LessonID"] intValue]];
        
        audioNoteViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"audioNoteView"];
        
        //audioPlayerViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"audioPlayer"];
        view.note = note;
        view.lesson = _lesson;
        [self.navigationController pushViewController:view animated:YES];
        
    }
}

//-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
//{
//    _data = [[NSMutableData alloc]init];
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
//{
//    [_data appendData:theData];
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    [_mainTableView.pullToRefreshView stopAnimating];
//    [Tools hideLoaderFromView:self.view];
//    
//    _thisLessonNotes = [[NSMutableArray alloc] init];
//    _otherLessonNotes =[[NSMutableArray alloc] init];
//    
//    _allNotes = [[NSArray alloc] init];
//    _allNotes = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
//    
//    for (int c=0; c < [_allNotes count]; c++) {
//        if ([[[_allNotes objectAtIndex:c] objectForKey:@"LessonID"] isEqualToString:[NSString stringWithFormat:@"%li", [_lesson LessonID]]]) {
//            [_thisLessonNotes addObject:[_allNotes objectAtIndex:c]];
//        }
//        else{
//            [_otherLessonNotes addObject:[_allNotes objectAtIndex:c]];
//        }
//    }
//    
//    _notes = [[NSMutableArray alloc]init];
//    [_notes addObject:_thisLessonNotes];
//    [_notes addObject:_otherLessonNotes];
//    [_lesson setNotes:_notes];
//    
//    NSLog(@"%@", _notes);
//    
//    [self.mainTableView reloadData];
//    
//    if ([_allNotes count] == 0) {
//        _statusLbl.hidden = NO;
//        _statusLbl.text = @"No notes";
//        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
//    }
//    else{
//        [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//        _statusLbl.hidden = YES;
//    }
//}
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [errorView show];
//    [Tools hideLoaderFromView:self.view];
//    [_mainTableView.pullToRefreshView stopAnimating];
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
