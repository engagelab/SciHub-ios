
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
#import "VideoMessageViewController.h"
#import "UploadViewController.h"

#import "GDataServiceGoogleYouTube.h"
#import "GDataMediaCategory.h"
#import "GDataMediaGroup.h"
#import "GDataEntryYouTubeUpload.h"
#import "GTMHTTPFetcher.h"

#import "URLParser.h"

@implementation MainViewController
@synthesize loginButton;
@synthesize baseSheet;
@synthesize savedTitle;

NSString *const uploadProgressTitleStart = @"Upload Progress";
NSString *const uploadProgressTitleEnd = @"Upload Done!";



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
    
    videoPickerController = [[UIImagePickerController alloc] init ];

    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];

    userNameLabel.text = username;
    
    [GTMHTTPFetcher setLoggingEnabled:YES];
}

- (void)viewDidUnload
{

    [self setLoginButton:nil];
    swipeView = nil;
    userNameLabel = nil;
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
//    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
//        
//        LoginViewController *targetViewController = segue.destinationViewController;
//        targetViewController.self = self.appDelegate.sciHubOnlineDelegate;
//        
//       
//    }
}

#pragma mark - Random String


NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *)genRandStringLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
    }
    
    return randomString;
}

#pragma mark - message event methods methods

-(void) sendVideoTokenEvent {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    NSString *eventType = @"\"eventType\": \"got_client_token\""; 
    
    
    
    videoToken = [self genRandStringLength:arc4random() % 10 ];
    
    NSString *uuid = [[NSString alloc] initWithFormat:@"\"token\": \"%@\"",videoToken];
    
    NSString *event = [[NSString alloc] initWithFormat:@"{ %@, \"payload\": { %@ }, \"origin\":\"%@\"}",eventType, uuid, username]; 
    
    DDLogVerbose(event);
    
    [self sendGroupMessageWith: event];
}

-(void) sendVideoReadyEvent: (NSString*)url {
    
    //{ eventType: 'video_ready', payload: { token: 'upload token', url: 'http://youtube.com/lakjsdflkjsdfklj'}, origin: 'bob' }
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    NSString *eventType = @"\"eventType\": \"video_ready\""; 
    
    NSString *uuid = [[NSString alloc] initWithFormat:@"\"token\": \"%@\"",videoToken];
    
    NSString *vurl = [[NSString alloc] initWithFormat:@"\"url\": \"%@\"",url];
    
      DDLogVerbose(@"YOU TUBE %@",vurl);
    
    NSString *event = [[NSString alloc] initWithFormat:@"{ %@, \"payload\": { %@,%@ }, \"origin\":\"%@\"}",eventType, uuid,vurl, username]; 
    
    DDLogVerbose(event);
    
    [self sendGroupMessageWith: event];
    

    
}


#pragma mark - YouTube uploader methods

- (IBAction)doYouTube:(id)sender {
    
    [self sendVideoTokenEvent];    

    NSString *videoTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"videoTitle"];
    NSString *videoPath = [[NSUserDefaults standardUserDefaults] objectForKey:@"videoPath"];
    
    
    [self showProgressSheet];
    
    
    GDataServiceGoogleYouTube *service = [[GDataServiceGoogleYouTube alloc] init];
    [service setUserAgent:@"iOS uploader"]; 
    [service setServiceShouldFollowNextLinks:YES]; 
    [service setIsServiceRetryEnabled:YES]; 

    [service setUserCredentialsWithUsername:@"encoresignup@gmail.com" password:@"enc0relab"];
    [service setYouTubeDeveloperKey:@"AI39si5ks7j5bAJYbTpdjCDECT3m7r_wx5ZV7vM8ZY0wCayYqpajmWwVgHkscRtMvkfbvM1GgAkigqMPyXNi-0PAHvr_BmdPAQ"];
    
    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];

    
    // load the file data
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"YouTubeTest" ofType:@"m4v"]; 
    NSData *data = [NSData dataWithContentsOfFile:videoPath];
    NSString *filename = [videoPath lastPathComponent];
    
    // gather all the metadata needed for the mediaGroup
    
    if( videoTitle == nil ) {
        
        int value = (arc4random() % 600);
        videoTitle = [[NSString alloc] initWithFormat:@"Video %d-%@",value,videoToken];
    }

    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:videoTitle];
    

    GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:@"Entertainment"];
   // [category setScheme:kGDataCategoryScheme];
    
    NSString *descStr = @"some video";
    GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:descStr];
    
    NSString *keywordsStr = @"cars, funny";
    GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithString:keywordsStr];
    
    GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
    [mediaGroup setMediaTitle:title];
    [mediaGroup setMediaDescription:desc];
    [mediaGroup addMediaCategory:category];
    [mediaGroup setMediaKeywords:keywords];

    [mediaGroup setIsPrivate:NO];

    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:videoPath
                                               defaultMIMEType:@"video/quicktime"];
    
    // create the upload entry with the mediaGroup and the file
    GDataEntryYouTubeUpload *entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                    data:data
                                                      MIMEType:mimeType
                                                          slug:filename];
    
    [entry addAccessControl:[GDataYouTubeAccessControl 
                                  accessControlWithAction:@"list" permission:@"denied"]]; 


    SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
    [service setServiceUploadProgressSelector:progressSel];
    
    GDataServiceTicket *ticket;
    ticket = [service fetchEntryByInsertingEntry:entry
                                      forFeedURL:url
                                        delegate:self
                               didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
 
    
    [uploadProgress setProgress: 0.0];
}
- (void)ticket:(GDataServiceTicket *)ticket
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead 
ofTotalByteCount:(unsigned long long)dataLength {
    
    double p = (double)numberOfBytesRead / (double)dataLength;
     DDLogVerbose(@"progress %d",p);
    
    [uploadProgress setProgress:p animated:YES];
    
    if( p == 0 ) {
        baseSheet.title = uploadProgressTitleEnd; 
    }
}

- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeUpload *)videoEntry
               error:(NSError *)error {
    
    [uploadProgress setProgress: 0.0];
    [baseSheet setTitle:uploadProgressTitleStart];
    [baseSheet dismissWithClickedButtonIndex:0 animated:YES]; 
    
    [self hideSwipeView:nil];
     
    
    if (error == nil) {
     
        NSString *videoUrl;
        // Code to get the URL of uploaded videos 
        NSArray *mediaPlayers = [[videoEntry mediaGroup] 
                                 mediaPlayers]; 

        if([mediaPlayers count] > 0) 
        { 
             videoUrl = [[mediaPlayers objectAtIndex: 0] URLString]; 
            
        } 
        
              
        URLParser *parser = [[URLParser alloc] initWithURLString:videoUrl];
        
        NSString *v = [parser valueForVariable:@"v"];
        
        NSString *yurl = [[NSString alloc] initWithFormat:@"http://www.youtube.com/v/%@",v];
        
        [self sendVideoReadyEvent:yurl];
        
         DDLogVerbose(@"WE WON!!!!");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                        message:@"Video Successfully Uploaded"
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        
        [alert show];

        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:[NSString stringWithFormat:@"Error: %@", 
                                                                 [error description]] 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        
        [alert show];
  
    }
    
   
    
    
  
}

- (void)showProgressSheet {
    if (!self.baseSheet) {
		baseSheet = [[UIActionSheet alloc] 
					 initWithTitle:uploadProgressTitleStart
					 delegate:self 
					 cancelButtonTitle:nil 
					 destructiveButtonTitle: nil
					 otherButtonTitles: nil];
        uploadProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(50.0f, 40.0, 220.0f, 45.0f)];
        uploadProgress.trackTintColor = [UIColor grayColor];
        [uploadProgress setProgressViewStyle: UIProgressViewStyleBar];
        baseSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [baseSheet addSubview:uploadProgress];
        
		[baseSheet showInView:self.view]; 
        [baseSheet setBounds:CGRectMake(0,0,320, 100)];
	} else {
        [baseSheet showInView:self.view]; 
        [baseSheet setBounds:CGRectMake(0,0,320, 100)];
    }
}



#pragma mark - Agent methods

- (IBAction)testAgent:(id)sender {
    
    NSString *event = @"{'eventType':'hello', 'payload': {}, 'origin':'obama'}";
    
    [[[self appDelegate] xmppRoom ]sendMessage:event];
    
}

- (void)sendGroupMessageWith:(NSString *)event {
    if( event != nil )
        [[[self appDelegate] xmppRoom ]sendMessage:event];
}


#pragma mark - Camera methods

- (IBAction)showVideoList:(id)sender {
    
    if( videoPickerController == nil ) {
        videoPickerController = [[UIImagePickerController alloc] init ];
    }
    
    videoPickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    videoPickerController.delegate = self;
    videoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:videoPickerController animated:YES];
}

- (IBAction)showCamera:(id)sender {

    if( videoPickerController == nil ) {
        videoPickerController = [[UIImagePickerController alloc] init ];
    }

        videoPickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        videoPickerController.delegate = self;
        videoPickerController.sourceType = UIImagePickerControllerCameraCaptureModeVideo;
        videoPickerController.startVideoCapture;
        videoPickerController.showsCameraControls = YES;
    
        [videoPickerController performSelector:@selector(startVideoCapture) withObject:nil afterDelay:5];
    
        [self presentModalViewController:videoPickerController animated:YES];
    
        
    
    
}

#pragma mark - Audio delegate methods


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
      DDLogVerbose(@"did finish playing sound");
}

#pragma mark - UIImagePickerControllerDelegate delegate methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Access the uncropped image from info dictionary
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    if( videoURL != nil ) {
        UISaveVideoAtPathToSavedPhotosAlbum([videoURL path], self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    } else {
        
        // ADD: get the decode results
        id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            // EXAMPLE: just grab the first barcode
            break;
        
        // EXAMPLE: do something useful with the barcode data
        
        if( symbol.data != nil ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:symbol.data
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        
        
        //resultText.text = symbol.data;
        
        // EXAMPLE: do something useful with the barcode image
        //    resultImage.image =
        //    [info objectForKey: UIImagePickerControllerOriginalImage];
        
        // ADD: dismiss the controller (NB dismiss from the *reader*!)
        [picker dismissModalViewControllerAnimated: YES];
    }

    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    if (!videoPath && error) {
        NSLog(@"Error saving video to saved photos roll: %@, %@", error, [error userInfo]);
        // Handle error;
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:videoPath forKey:@"videoPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [videoPickerController dismissModalViewControllerAnimated:YES];
    
    swipeView.hidden = NO;
    
//    UIStoryboard *storyb = [UIStoryboard storyboardWithName:@"MainStoryBoard_iPhone" bundle:nil]; 
//    //    
//    UploadViewController *videoMessageController = [storyb instantiateViewControllerWithIdentifier:@"uploadViewController"];
//    
//    
//    [self presentModalViewController:videoMessageController animated:YES];

    //[self showVideoTitleModal];
    
}

- (IBAction)showVideoTitleModal:(id)sender {

//    UIStoryboard *storyb = [UIStoryboard storyboardWithName:@"MainStoryBoard_iPhone" bundle:[NSBundle mainBundle]]; 
//    
//    VideoMessageViewController *videoMessageController = [storyb instantiateViewControllerWithIdentifier:@"videoMessageController"];
    
    
   // [self presentModalViewController:videoMessageController animated:YES];
}

#pragma mark - sciHubMessageDelegate delegate methods

- (void)newMessageReceived:(NSDictionary *)messageContent {
    DDLogVerbose(@"new Message received!");
}

- (void)replyMessageTo:(NSString *)from {
    
//    UIStoryboard *storyb = [UIStoryboard storyboardWithName:@"MainStoryBoard_iPhone" bundle:[NSBundle mainBundle]]; 
//    
//    MessageViewController *messageController = [storyb instantiateViewControllerWithIdentifier:@"messageController"];
//    
//    messageController.from = from;
//    
//    [self presentModalViewController:messageController animated:YES];
  
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




- (IBAction)hideSwipeView:(id)sender {
    swipeView.hidden = YES;
}

#pragma mark -
#pragma mark ZBarMethods


- (IBAction)checkInWithQR:(id)sender {
    [self sendVideoTokenEvent];
    [self sendVideoReadyEvent:@"http://www.youtube.com/v/YPb9eRNyIrQ"];
    // ADD: present a barcode reader that scans from the camera feed
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    // TODO: (optional) additional reader configuration here
//    
//    // EXAMPLE: disable rarely used I2/5 to improve performance
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    
//    // present and release the controller
//    [self presentModalViewController: reader
//                            animated: YES];


    
}
@end
