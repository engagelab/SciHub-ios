//
//  LoginPickerViewController.h
//  rollcall.login.ios
//
//  Created by Anthony Perritano on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;
@interface LoginPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSMutableArray *arrStatus; 
    __weak IBOutlet UIButton *startButton;
    
    __weak IBOutlet UILabel *groupLabel;
    Reachability *internetReachable;
    Reachability *hostReachable;
}
- (IBAction)startAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

-(void) checkNetworkStatus:(NSNotification *)notice;

@end
