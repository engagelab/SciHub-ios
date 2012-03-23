//
//  LoginViewController.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/19/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
//#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"

@implementation LoginViewController

@synthesize loginField;
@synthesize passwordField;
@synthesize errorLabel;
@synthesize overlay;
@synthesize activityIndicator;
@synthesize loginButton;

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( [[self appDelegate] connect] ) {
        loginButton.title = @"Logout";
    } else {
        loginButton.title = @"Login";
    }


}

- (void)isAvailable:(BOOL)available {
    
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
    
//    
//    if( [[self appDelegate] connect] ) {
//        [[self appDelegate] disconnect ];
//        loginButton.title = @"Login";
//    } else {
//        [[self appDelegate] superConnect ];
//        loginButton.title = @"Logout";
//    }
    
    
    [self dismissModalViewControllerAnimated:YES];
    
    
//    [self dismissModalViewControllerAnimated:YES];
//    
//    [self.view bringSubviewToFront:overlay];
//    
//    overlay.hidden = NO;
//    if( loginField.text == nil || passwordField.text == nil ) {
//        errorLabel.text = @"username or password is blank.";
//    } else {
//        [[NSUserDefaults standardUserDefaults] setObject:loginField.text forKey:@"userID"];
////        [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:@"rollcallPassword"];
//        
//        NSString* username = [[loginField.text componentsSeparatedByString:@"@"] objectAtIndex:0];
//
//        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
//
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
        
//        NSURL *url = [NSURL URLWithString:@"http://rollcall.proto.encorelab.org/login.json"];
//        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//        [request addPostValue:username forKey:@"session[login]"];
//        [request addPostValue:passwordField.text forKey:@"session[password]"];
//        [request setCompletionBlock:^{
//            // Use when fetching text data
//            NSString *responseString = [request responseString];
//            
//            // Use when fetching binary data
//            NSData *responseData = [request responseData];
//            
//            NSError *error = nil;
//            NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:&error];
//            NSDictionary *session = [dictionary objectForKey:@"session"];
//            
//            NSString *token = [session objectForKey:@"token"];
//            NSNumber *sessionId = [session objectForKey:@"id"];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
//            [[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:@"sessionId"];
//            
//            NSDictionary *account = [session objectForKey:@"account"];
//            NSString *ePassword = [account objectForKey:@"encrypted_password"];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:ePassword forKey:@"ePassword"];
//            [[NSUserDefaults standardUserDefaults] setObject:ePassword forKey:@"userPassword"];
//
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            BOOL connected = [[self appDelegate] connect]; 
//            
//            if( connected ) {
//                [[self appDelegate] goOnline]; 
//            }
//            
//            
//            [activityIndicator stopAnimating];
//            overlay.hidden = YES;
//        }];
//        [request setFailedBlock:^{
//            NSError *error = [request error];
//            [activityIndicator stopAnimating];
//        }];
//        [activityIndicator startAnimating];
//        [request startAsynchronous];
        
//        [self dismissModalViewControllerAnimated:YES];
        
/*        
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
 */
//        overlay.hidden = YES;
//        [activityIndicator stopAnimating];
//        [self dismissModalViewControllerAnimated:YES];
//    }
    
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
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


@end
