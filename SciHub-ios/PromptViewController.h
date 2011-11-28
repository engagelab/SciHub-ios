//
//  PromptViewController.h
//  SciHub-ios
//
//  Created by Anthony Perritano on 11/28/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)cancelAction:(id)sender;


@end
