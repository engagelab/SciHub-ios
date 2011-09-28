//
//  VideoMessageViewController.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/27/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import "VideoMessageViewController.h"

@implementation VideoMessageViewController

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        
        DDLogVerbose(@"replying.....");
        [self reply:nil];
        [self dismissModalViewControllerAnimated:YES];
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (IBAction)reply:(id)sender {
    
    DDLogVerbose(@"messaging.....");
    
    NSString *videoTitle = self.textView.text;
    
    if( self.textView.text == nil ) {
        videoTitle = @"no video title for you.";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:videoTitle forKey:@"videoTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
