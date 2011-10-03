//
//  UploadViewController.h
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/19/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface UploadViewController : UIViewController <UIGestureRecognizerDelegate> {

    MainViewController *mainViewController;
    
}

@property (strong, nonatomic) MainViewController *mainViewController;

-(IBAction)closeWindow:(id)sender; 
-(IBAction)uploadVideo:(id)sender; 

@end
