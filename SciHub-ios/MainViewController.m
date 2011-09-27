
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


#import "GDataServiceGoogleYouTube.h"
#import "GDataMediaCategory.h"
#import "GDataMediaGroup.h"
#import "GDataEntryYouTubeUpload.h"
#import "GTMHTTPFetcher.h"
/**
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"
#import "GDataFeedPhoto.h"

**/
@implementation MainViewController
@synthesize loginButton;
@synthesize baseSheet;

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



- (IBAction)doYouTube:(id)sender {
//    
    [self createProgressView];
    [GTMHTTPFetcher setLoggingEnabled:YES];
    
    GDataServiceGoogleYouTube *service = [[GDataServiceGoogleYouTube alloc] init];
    [service setUserAgent:@"iOS uploader"]; 
    [service setServiceShouldFollowNextLinks:YES]; 
    [service setIsServiceRetryEnabled:YES]; 

    [service setUserCredentialsWithUsername:@"encoresignup@gmail.com" password:@"enc0relab"];
    [service setYouTubeDeveloperKey:@"AI39si5ks7j5bAJYbTpdjCDECT3m7r_wx5ZV7vM8ZY0wCayYqpajmWwVgHkscRtMvkfbvM1GgAkigqMPyXNi-0PAHvr_BmdPAQ"];
    
    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];

    
    // load the file data
    NSString *path = [[NSBundle mainBundle] pathForResource:@"YouTubeTest" ofType:@"m4v"]; 
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filename = [path lastPathComponent];
    
    // gather all the metadata needed for the mediaGroup
    NSString *titleStr = @"new viddddo";
    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:titleStr];
    

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

    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:path
                                               defaultMIMEType:@"video/mp4"];
    
    // create the upload entry with the mediaGroup and the file
    GDataEntryYouTubeUpload *entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                    data:data
                                                      MIMEType:mimeType
                                                          slug:filename];
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


// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {
    
    [uploadProgress setProgress: 0.0];
    [baseSheet setTitle:uploadProgressTitleStart];
    [baseSheet dismissWithClickedButtonIndex:0 animated:YES]; 
    if (error == nil) {
        // tell the user that the add worked
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uploaded!"
//                                                        message:[NSString stringWithFormat:@"%@ succesfully uploaded"]
//                                                                                     
//                                                       delegate:nil 
//                                              cancelButtonTitle:@"Ok" 
//                                              otherButtonTitles:nil];
//        
//        [alert show];
        
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



-(void) didFinish:(id)sender  {
    DDLogVerbose(@"UPLOADED MOTHER FUCKERRRRRRRRRR");

}

- (void)createProgressView {
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
	
    //	UIProgressView *progbar = (UIProgressView *)[self.view viewWithTag:PROGRESS_BAR];
    //	[progbar setProgress:(amountDone = 0.0f)];
    //    [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(incrementBar:) userInfo: nil repeats: YES];
}

- (IBAction)showSheet:(id)sender {

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
