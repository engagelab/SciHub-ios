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

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate, AVAudioPlayerDelegate, SciHubMessageDelegate, SciHubOnlineDelegate>{
    
    AVAudioPlayer *player;
    
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;

- (IBAction)showCamera:(id)sender;
- (IBAction)showVideoList:(id)sender;

- (AppDelegate *)appDelegate;



@end
