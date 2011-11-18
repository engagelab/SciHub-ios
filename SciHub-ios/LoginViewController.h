//
//  LoginViewController.h
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/19/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciHubOnlineDelegate.h"

@interface LoginViewController : UIViewController <SciHubOnlineDelegate>{
   
    
}

@property (strong, nonatomic) IBOutlet UITextField *loginField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIView *overlay;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;



- (IBAction)closeWindow:(id)sender;

- (IBAction)doLogin:(id)sender;

@end
