//
//  LoginViewController.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/19/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@implementation LoginViewController

@synthesize loginField;
@synthesize passwordField;
@synthesize errorLabel;
@synthesize overlay;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)closeWindow:(id)sender {

    
//    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
//	[activityIndicator setCenter:CGPointMake(300.0f,350.0f)];
//    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//	[self.view addSubview:activityIndicator];
//    [self.view bringSubviewToFront:activityIndicator];
//    [activityIndicator startAnimating];
     [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doLogin:(id)sender {
    
    [self.view bringSubviewToFront:overlay];
    
    overlay.hidden = NO;
    if( loginField.text == nil || passwordField.text == nil ) {
        errorLabel.text = @"username or password is blank.";
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:loginField.text forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:@"userPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        BOOL connected = [[self appDelegate] connect]; 
        
        
//        [activityIndicator startAnimating];
//        [self.view bringSubviewToFront:activityIndicator];
        
        if( connected ) {
           

            [[self appDelegate] goOnline]; 
//            while([[[self appDelegate] xmppStream]isConnected] == false ) {
//                DDLogVerbose(@"not online yet!!!!!!!!!!!!!!!!!");
//
//            }
            //[activityIndicator stopAnimating];
            
            
        }
        [self dismissModalViewControllerAnimated:YES];
//        overlay.hidden = YES;
//        [activityIndicator stopAnimating];
//        [self dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidUnload
{

    [self setErrorLabel:nil];
    [self setLoginField:nil];
    [self setPasswordField:nil];
    activityIndicator = nil;
    [self setOverlay:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


@end
