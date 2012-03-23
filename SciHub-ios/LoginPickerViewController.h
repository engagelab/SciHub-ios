//
//  LoginPickerViewController.h
//  rollcall.login.ios
//
//  Created by Anthony Perritano on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSArray *arrStatus; 
    __weak IBOutlet UIButton *startButton;
    
    __weak IBOutlet UILabel *groupLabel;
}
- (IBAction)startAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end
