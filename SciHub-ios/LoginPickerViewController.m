//
//  LoginPickerViewController.m
//  rollcall.login.ios
//
//  Created by Anthony Perritano on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginPickerViewController.h"

@implementation LoginPickerViewController
@synthesize pickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    if( row == 0 ) {
        startButton.enabled = NO;
    } else {
        startButton.enabled = YES;
        [[NSUserDefaults standardUserDefaults] setObject:groupLabel.text forKey:@"group"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrStatus = [[NSArray alloc] initWithObjects:@"Choose your Group.",@"one", @"two", @"three", @"four", @"five", @"six", @"seven", nil];
    groupLabel.text = [arrStatus objectAtIndex:0];
    startButton.enabled = NO;
}

- (void)viewDidUnload
{
    [self setPickerView:nil];
    groupLabel = nil;
    startButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)startAction:(id)sender {
}
@end
