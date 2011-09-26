
//
//  ViewController.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/8/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "MessageViewController.h"

/**
#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"
#import "GDataFeedPhoto.h"
#import "GDataEntryYouTubeUpload.h"
**/
@implementation MainViewController
@synthesize loginButton;


-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    if ((self = [super initWithNibName:nibName bundle:bundle])) {

            DDLogVerbose(@"startup of bundle.....");
    }
    
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.appDelegate.sciHubMessageDelegate = self;
    self.appDelegate.sciHubOnlineDelegate = self;
}

- (void)viewDidUnload
{

    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{ 
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        
        //LoginViewController *targetViewController = segue.destinationViewController;
        //targetViewController.delegate = self;
        
       
    }
    
}

- (void)doYouTube {
//    
//    GDataServiceGoogleYouTube service = [[GDataServiceGoogleYouTube alloc] init];
//
//    [service setUserCredentialsWithUsername:@"encoresignup@gmail.com"
//                                   password:@"enc0relab"]; 
    //[service setD
    
}

- (IBAction)showCamera:(id)sender {
    
 
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init ];
        pickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        pickerController.delegate = self;

        pickerController.sourceType = UIImagePickerControllerCameraCaptureModeVideo;
        pickerController.showsCameraControls = YES;
    
        [self presentModalViewController:pickerController animated:YES];
    
    
}

- (IBAction)showVideoList:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init ];
    pickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    pickerController.delegate = self;
    
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   // pickerController.showsCameraControls = YES;
    
    [self presentModalViewController:pickerController animated:YES];
}

- (IBAction)testAgent:(id)sender {
    
    NSString *event = @"{'eventType':'hello', 'payload': {}, 'origin':'obama'}";
    
    [[[self appDelegate] xmppRoom ]sendMessage:event];
    
}

#pragma mark - Audio delegate methods


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
      DDLogVerbose(@"did finish playing sound");
}

#pragma mark - sciHubMessageDelegate delegate methods

- (void)newMessageReceived:(NSDictionary *)messageContent {
    DDLogVerbose(@"new Message received!");
}

- (void)replyMessageTo:(NSString *)from {
    
    UIStoryboard *storyb = [UIStoryboard storyboardWithName:@"MainStoryBoard_iPhone" bundle:nil]; 
    
    MessageViewController *messageController = [storyb instantiateViewControllerWithIdentifier:@"messageController"];
    
    messageController.from = from;
    
    [self presentModalViewController:messageController animated:YES];
    
}

#pragma mark - sciHubOnlineDelegate delegate methods

- (void)isAvailable:(BOOL)available {
    DDLogVerbose(@"Your available!!");
    
    UIImage *image;
    if( available ) {
        image = [UIImage imageNamed:@"icon-status-available.png"];
    
    
        NSString *spath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"On.aif"];
        NSURL *url = [NSURL fileURLWithPath:spath];
        NSError *error;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [player play];
    } else {
        image = [UIImage imageNamed:@"icon-status-cancelled.png"];
    }
    
    loginButton.image = image;
}

- (void)newGroupMessageReceived:(NSDictionary *)messageContent {
    
    NSString *message = [messageContent objectForKey:@"body"];
    NSString *sender = [messageContent objectForKey:@"sender"];
    DDLogVerbose(@"message %@,%@", message, sender);
}

#pragma mark - UIImagePickerControllerDelegate delegate methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Access the uncropped image from info dictionary
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    UISaveVideoAtPathToSavedPhotosAlbum(videoURL.absoluteString, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    

    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    if (!videoPath && error)
    {
        NSLog(@"Error saving video to saved photos roll: %@, %@", error, [error userInfo]);
        // Handle error;
        return;
    }
    
    // Video was saved properly. UI may need to be updated here.
}


@end
