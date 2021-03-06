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
@synthesize pickerView;
@synthesize activityView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        [self requestPickerData];
        // initialize what you need here
    }
    
    return self;
    
}

-(void)requestPickerData {
    NSString *runId = @"2";
    arrStatus = [[NSMutableArray alloc] init];
    NSString * myURLString = [NSString stringWithFormat:@"http://scihub.uio.no:9000/groupnames/%@",runId];
    
    NSURL *url =[NSURL URLWithString:myURLString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    
    [activityView startAnimating];
    
    //request.didReceiveDataSelector = @selector(parseObjects:);
    request.didFinishSelector = @selector(parseObjects:);
    //request.didFailSelector = @selector(resultCitiesError:);
    
    [request startAsynchronous];
}

-(void)parseObjects :(ASIHTTPRequest *)request {
    
    NSString *responseData = [request responseString];
    
    NSError *error = nil;
    
    NSString *data = @"{'groups': [ 'group1','group2','group3','group4','group5','group6']}";
    
    NSData *jsonData = [responseData dataUsingEncoding:NSUTF8StringEncoding];

     NSArray *array = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
    
    
    
    
    for( NSDictionary* d in array ) { 
        
        NSString *s = [d objectForKey:@"name"];
      
        [arrStatus addObject:s];
        

    }
    
    [pickerView reloadAllComponents];
    groupLabel.text = [arrStatus objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:[arrStatus objectAtIndex:0]forKey:@"group"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    startButton.enabled = YES;
    //NSArray *dictionary = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
    //NSDictionary *session = [dictionary objectForKey:@"session"];
    
    
     NSLog(@"%@",jsonData);
    
    [activityView stopAnimating];

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //set number of rows
    return arrStatus.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //set item per row
    return [arrStatus objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"the %d row was selected in the %d component", row, component);
    
    groupLabel.text = [arrStatus objectAtIndex:row];
    
     NSLog(@"%@",[arrStatus objectAtIndex:row]);
           startButton.enabled = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[arrStatus objectAtIndex:row]forKey:@"group"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //arrStatus = [[NSArray alloc] initWithObjects:@"Choose your Group.",@"one", @"two", @"three", @"four", @"five", @"six", @"seven", nil];
   //groupLabel.text = [arrStatus objectAtIndex:0];
    startButton.enabled = NO;
}

- (void)viewDidUnload
{
    [self setPickerView:nil];
    groupLabel = nil;
    startButton = nil;
    [self setActivityView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)startAction:(id)sender {
    
    

//    
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"b" forKey:@"a"]; 
//    NSString *jsonString = [[CJSONSerializer serializer] serializeObject:dictionary];
//    
    // Default becomes POST when you use appendPostData: / appendPostDataFromFile: / setPostBody:
    //[request setRequestMethod:@"PUT"];
    
    
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostname: @"www.apple.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
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
            [[UIAlertView alloc] initWithTitle: @"Connection Problem"
                                       message: @"The internet is down."
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
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Connection Problem"
                                       message: @"The internet is down."
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");

            
            break;
        }
    }
}
@end
