//
//  MessageViewController.h
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/23/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciHubMessageDelegate.h"

@interface MessageViewController : UIViewController<UITextViewDelegate> {

    NSString *from;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *from;

- (IBAction)cancel:(id)sender;
- (IBAction)reply:(id)sender;

@end
