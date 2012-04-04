//
//  LoginPickerViewController.h
//  rollcall.login.ios
//
//  Created by Anthony Perritano on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;
@interface LoginPickerViewController : UIViewController {
    
    Reachability *internetReachable;
    Reachability *hostReachable;
}
- (IBAction)startAction:(id)sender;



-(void) checkNetworkStatus:(NSNotification *)notice;

@end
