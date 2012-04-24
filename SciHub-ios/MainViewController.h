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
#import "AppDelegate.h"

//This where much of the work is done. Showing the camera and uploading the video. 
@interface MainViewController : UIViewController<UIImagePickerControllerDelegate, AVAudioPlayerDelegate, SciHubMessageDelegate, SciHubOnlineDelegate>{
    
    AVAudioPlayer *player;
    UIActionSheet *baseSheet;
    UIProgressView *uploadProgress;
    UIImagePickerController *videoPickerController;
    NSString *savedVideoPath;
    NSString *savedTitle;
    NSString *videoToken;
    NSString *taskName;
    UIImage *taskImage;
    IBOutlet UIView *swipeView;
    IBOutlet UILabel *userNameLabel;
   
}
- (IBAction)hideSwipeView:(id)sender;

@property (nonatomic, retain) UIActionSheet *baseSheet;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic, retain) NSString *savedTitle;
@property (nonatomic, retain) NSString *taskName;
@property (nonatomic, retain) UIImage *taskImage;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;



- (IBAction)checkInWithQR:(id)sender;

//camera methods
- (IBAction)showCamera:(id)sender;
- (IBAction)showVideoList:(id)sender;

//video message
- (IBAction)showVideoTitleModal:(id)sender;

//agent methods
- (IBAction)testAgent:(id)sender;
- (void)sendGroupMessageWith:(NSString *)event;

//upload methods
- (IBAction)doYouTube:(id)sender;
- (void)showProgressSheet;

- (AppDelegate *)appDelegate;



@end
