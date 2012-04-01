//
//  IntroViewController.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 3/29/12.
//  Copyright (c) 2012 .t. All rights reserved.
//

#import "IntroViewController.h"
#import "MainViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    

    
    
    if ([segue.identifier isEqualToString:@"Sykkelpumpe"])
    {
        MainViewController *mainController = [segue destinationViewController];
        mainController.taskName = [segue identifier];
        mainController.title = [segue identifier];
        mainController.taskImage = [UIImage imageNamed: @"Sykkelpumpe.png"];
    } else if ([segue.identifier isEqualToString:@"Sprayflaske"]) {
        MainViewController *mainController = [segue destinationViewController];
        mainController.taskName = [segue identifier];
        mainController.title = [segue identifier];
        mainController.taskImage =[UIImage imageNamed: @"Sprayflaske.png"];        
    } else if ([segue.identifier isEqualToString:@"Sprøyte"]) {
        MainViewController *mainController = [segue destinationViewController];
        mainController.taskName = [segue identifier];
        mainController.title = [segue identifier];
        mainController.taskImage =[UIImage imageNamed: @"Sprøyte.png"];
    } else if ([segue.identifier isEqualToString:@"Varmepumpe"]) {
        MainViewController *mainController = [segue destinationViewController];
        mainController.taskName = [segue identifier];
        mainController.title = [segue identifier];
        mainController.taskImage =[UIImage imageNamed: @"Varmepumpe.png"];
    } else if ([segue.identifier isEqualToString:@"Energioverføring"]) {
        MainViewController *mainController = [segue destinationViewController];
        mainController.taskName = [segue identifier];
        mainController.title = [segue identifier];
        mainController.taskImage =[UIImage imageNamed: @"Energioverføring.png"];
        
    } else if ([segue.identifier isEqualToString:@"Bærekrafting utvikling"]) {
        MainViewController *mainController = [segue destinationViewController];
        mainController.taskName = [segue identifier];
        mainController.title = [segue identifier];
        mainController.taskImage =[UIImage imageNamed: @"Bærekraftig utvikling.png"];
    }

}

@end
