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

-(void)jsonRequestGetData
{
    //self.mainTableView.hidden = YES;
    
    _data = [[NSMutableData alloc]init];
    _lessons = [[NSArray alloc] init];
    [_mainTableView reloadData];
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=notesbystudent&id=%li&ts=%f", [[_lesson student] studentID], [[NSDate date] timeIntervalSince1970]];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    //[Tools showLoader];
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self jsonRequestGetData];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIBarButtonItem *textNoteBtn = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addTextNote)];
    
     UIBarButtonItem *audioNoteBtn = [[UIBarButtonItem alloc]  initWithTitle: @"Add audio note" style:UIBarButtonItemStyleBordered target:self action:@selector(addAudioNote)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:textNoteBtn,audioNoteBtn, nil]];
    
    
    [_mainTableView addPullToRefreshWithActionHandler:^{
        [self jsonRequestGetData];
    }];
    
    
    textNotes = [[NSMutableArray alloc] init];
    audioNotes = [[NSMutableArray alloc] init];
    NSArray *allNotes = [[NSArray alloc] initWithObjects:textNotes, audioNotes, nil];
    [_lesson setNotes:allNotes];
    
}

-(void)addAudioNote
{
    audioNoteViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"audioNoteView"];
    view.lesson = _lesson;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)addTextNote
{
    textNoteViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"textNoteView"];
    view.lesson = _lesson;
    [self.navigationController pushViewController:view animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    int r = 0;
    if(section == 0){
        if([textNotes  count] > 0){
            r = 40;
        }
    }
    else if(section == 1){
        if([textNotes  count] > 0){
            r = 40;
        }
    }
    return r;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"Written notes";
    }
    else{
        return @"Audio notes";
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_lesson Notes] objectAtIndex:section] count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[[[_lesson Notes] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Note"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImage *image;
    
    if(indexPath.section == 0) {
        image =  [UIImage imageNamed:@"text_note_icon_large.png"];
    }
    else {
        image =  [UIImage imageNamed:@"audio_icon.png"];
    }

    UIImage *buttonBk = [Tools scaleImage:image toSize:CGSizeMake(60,88.0)];
    cell.imageView.image = buttonBk;

    return cell;
}

- (void)updateSwitchAtIndexPath{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    indexViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"dayView"];
//    view.studentCourseLink = _studentCourseLinkSender;
//    
//    [self.navigationController pushViewController:view animated:YES];
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
    [_mainTableView.pullToRefreshView stopAnimating];
    [Tools hideLoader];
    
    _lessons = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    textNotes = [[NSMutableArray alloc] init];
    audioNotes = [[NSMutableArray alloc] init];
    
    for(id obj in _lessons)
    {
        if ([[obj objectForKey:@"type"] isEqualToString:@"text"])
        {
            [textNotes addObject: obj];
        }
        else if ([[obj objectForKey:@"type"] isEqualToString:@"audio"])
        {
            [audioNotes addObject: obj];
        }
    }
    
    NSArray *allNotes = [[NSArray alloc] initWithObjects:textNotes, audioNotes, nil];
    [_lesson setNotes:allNotes];
    [self.mainTableView reloadData];
    
    if ([_lessons count] == 0) {
        _statusLbl.hidden = NO;
        _statusLbl.text = @"No notes";
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _statusLbl.hidden = YES;
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [Tools hideLoader];
    [_mainTableView.pullToRefreshView stopAnimating];
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

@end
