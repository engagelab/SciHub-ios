//
//  UploadViewController.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/19/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import "UploadViewController.h"
#import "AppDelegate.h"

@implementation UploadViewController

@synthesize mainViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(IBAction)closeWindow:(id)sender {
     [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)uploadVideo:(id)sender{
    
    /**
    { eventType: 'video_upload_requested', payload: {}, origin: 'mzukowski'
    }
    **/
    NSString *payload = @"payload:{}";
    NSString *eventType = @"eventType: 'video_upload_requested'"; 
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];


    NSString *event = [[NSString alloc] initWithFormat:@"{ %@, %@, origin:'%@'}",eventType, payload, username]; 
    
    
//[[[self appDelegate] xmppRoom ]sendMessage:event];
 
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
