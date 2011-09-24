//
//  MessageViewController.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/23/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import "MessageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation MessageViewController
@synthesize textView;
@synthesize from;

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

- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    textView.layer.cornerRadius = 10;
    textView.delegate = self;
    [textView becomeFirstResponder];
}


- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doReply {
    if( textView.text != nil ) {
        NSMutableDictionary *messageInfo = [[NSMutableDictionary alloc] init];
        [messageInfo setObject:textView.text forKey:@"body"];
        [messageInfo setObject:from forKey:@"sender"];
        [[self appDelegate] sendMessage:messageInfo ];
    }  
}

#pragma mark - textview delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        
          DDLogVerbose(@"replying.....");
        [self doReply];
        [self dismissModalViewControllerAnimated:YES];
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

#pragma mark - SchiHubMessageDelegate

- (IBAction)reply:(id)sender {
    
    DDLogVerbose(@"replying.....");

   [self doReply];
   [self dismissModalViewControllerAnimated:YES];
}
@end
