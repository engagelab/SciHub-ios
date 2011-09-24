//
//  AppDelegate.h
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/8/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "XMPPFramework.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import <CoreData/CoreData.h>
#import "SciHubMessageDelegate.h"
#import "SciHubOnlineDelegate.h"

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate, UIAlertViewDelegate> {
    
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	
    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;

    BOOL isXmppConnected;
    BOOL isOpen;
    
    NSMutableDictionary *lastMessageDict;
    NSString *password;

    id <SciHubMessageDelegate> __weak sciHubMessageDelegate;
    id <SciHubOnlineDelegate> __weak sciHubOnlineDelegate;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, weak) id <SciHubMessageDelegate> sciHubMessageDelegate;
@property (nonatomic, weak) id <SciHubOnlineDelegate> sciHubOnlineDelegate;


- (BOOL)connect;
- (void)disconnect;
- (void)setupStream;

- (void)goOnline;
- (void)goOffline;

@end
