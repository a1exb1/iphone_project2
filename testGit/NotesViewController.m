//
//  NotesViewController.m
//  testGit
//
//  Created by Alex Bechmann on 07/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "NotesViewController.h"

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

-(void)viewWillAppear:(BOOL)animated
{
    
    
    //[Tools showLoader];
}

- (void)viewDidLoad
{
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    [super viewDidLoad];
    
    textNotes = [[NSMutableArray alloc ]initWithObjects:
                 @"text note 1",
                 @"text note 2",
                 @"text note 3",
                 @"text note 4",
                 nil];
    
    audioNotes = [[NSMutableArray alloc ]initWithObjects:
                  @"audio note 1",
                  @"audio note 2",
                  @"audio note 3",
                  @"audio note 4",
                  nil];
    
    NSArray *allNotes = [[NSArray alloc] initWithObjects:textNotes, audioNotes, nil];
    [_lesson setNotes:allNotes];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
    
    cell.textLabel.text = [[[_lesson Notes] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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
    //[_mainTableView.pullToRefreshView stopAnimating];
    [Tools hideLoader];
    
    _lessons = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
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
