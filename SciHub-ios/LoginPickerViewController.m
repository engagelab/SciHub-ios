//
//  LoginPickerViewController.m
//  rollcall.login.ios
//
//  Created by Anthony Perritano on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginPickerViewController.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "ASIHTTPRequest.h"
#import "CJSONSerializer.h";
#import "Reachability.h"
@implementation LoginPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
       
        // initialize what you need here
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidUnload {

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void) viewWillAppear:(BOOL)animated {
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostname: @"www.apple.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"%@",[segue identifier]);
    [[NSUserDefaults standardUserDefaults] setObject:[segue identifier] forKey:@"group"];
    [NSUserDefaults standardUserDefaults];
    
    
    
    
    
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Internet Problem"
                                       message: @"Closed the application and check the Wifi"
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
     
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
     
            
            break;
        }
    }
    
}
@end
