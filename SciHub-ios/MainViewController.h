//
//  ViewController.h
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/8/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "SciHubMessageDelegate.h"
#import "SciHubOnlineDelegate.h"

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate, AVAudioPlayerDelegate, SciHubMessageDelegate, SciHubOnlineDelegate, UIActionSheetDelegate>{
    
    AVAudioPlayer *player;
    UIActionSheet *baseSheet;
    UIProgressView *uploadProgress;
    
}

@property (nonatomic, retain)	UIActionSheet *baseSheet;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;

- (IBAction)showSheet:(id)sender;

- (IBAction)showCamera:(id)sender;
- (IBAction)showVideoList:(id)sender;
- (IBAction)testAgent:(id)sender;
- (IBAction)doYouTube:(id)sender;

- (void)didFinish:(id)sender;
- (void)createProgressView;

- (AppDelegate *)appDelegate;



@end
