
//
//  ViewController.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/8/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation MainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
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
@end
