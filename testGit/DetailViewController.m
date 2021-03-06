//
//  DetailViewController.m
//  MasterDetail1
//
//  Created by Alex Bechmann on 20/03/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "DetailViewController.h"
#import "Tools.h"
#import "Session.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

extern Session *session;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

-(void)changed
{
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    if ([[session client]clientID] == 0) {
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        
        [self presentViewController:view animated:NO completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = self.splitViewController;
        splitViewController.delegate = self;
    }
    
    [Tools addECSlidingDefaultSetupWithViewController:self ];
    
    //self.splitViewController.delegate = (id)self;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    _detailShowMasterButton = barButtonItem;
    
    //[self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    _detailShowMasterButton = barButtonItem;
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (BOOL)splitViewController: (UISplitViewController*)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    //This method is only available in iOS5
    
    return NO;
}

@end
