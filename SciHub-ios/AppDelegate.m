//
//  AppDelegate.m
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/8/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import "AppDelegate.h"

#import <CFNetwork/CFNetwork.h>



@implementation AppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppRoom;
@synthesize sciHubMessageDelegate;
@synthesize sciHubOnlineDelegate;

@synthesize window = _window;

NSString * const serverName = @"imediamac28.uio.no";

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //temp
    [[NSUserDefaults standardUserDefaults] setObject:@"obama@imediamac28.uio.no" forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"obama" forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] setObject:@"obama" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Configure logging framework
	
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [self setupStream];
    [self connect];
    [self goOnline];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	// 
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.
	
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    #if TARGET_IPHONE_SIMULATOR
        DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
    #endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)]) 
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - XMPP delegates 

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
	
	isOpen = YES;
	NSError *error = nil;
	[[self xmppStream] authenticateWithPassword:password error:&error];
	
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
	
	[self goOnline];
	
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	
	return NO;
	
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	
    if( [message isChatMessageWithBody] ) {
        NSString *msg = [[message elementForName:@"body"] stringValue];
        
        
        NSString *from = [[message attributeForName:@"from"] stringValue];
        
        lastMessageDict = [[NSMutableDictionary alloc] init];
        [lastMessageDict setObject:msg forKey:@"msg"];
        [lastMessageDict setObject:from forKey:@"sender"];
     
        //if it is one on one chat pop up
        if ([from rangeOfString:@"conference"].location == NSNotFound) {
            DDLogVerbose(@"string does not contain bla");
            
            NSString* username = [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[username stringByAppendingString:@" says:"]
                                                                message:msg 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Close" 
                                                      otherButtonTitles:nil];
            [alertView addButtonWithTitle:@"Reply"];
            [alertView show];
        }
        
        
        [sciHubMessageDelegate newMessageReceived:lastMessageDict];
    }
	
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	
	NSString *presenceType = [presence type]; // online/offline
	NSString *myUsername = [[sender myJID] user];
	NSString *presenceFromUser = [[presence from] user];
	
	if ([presenceFromUser isEqualToString:myUsername]) {
		
		if ([presenceType isEqualToString:@"available"]) {
            
            NSString *t = [NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"];
            DDLogVerbose(t);
			
            [sciHubOnlineDelegate isAvailable:YES];
            [self joinChatRoom];
			//[_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"]];
			
		} else if ([presenceType isEqualToString:@"unavailable"]) {
			
            NSString *t = [NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"];
            DDLogVerbose(t);

            [sciHubOnlineDelegate isAvailable:NO];
			//[_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"]];
			
		}
		
	}
	
}

#pragma mark - XMPP Room Delegate

- (void)xmppRoomDidCreate:(XMPPRoom *)sender {
    DDLogVerbose(@"xmpp room did create");

}
- (void)xmppRoomDidEnter:(XMPPRoom *)sender {
        DDLogVerbose(@"xmpp room did enter");
}
- (void)xmppRoomDidLeave:(XMPPRoom *)sender {
        DDLogVerbose(@"xmpp room did leave");
}
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromNick:(NSString *)nick {
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
    [messageDictionary setObject:msg forKey:@"body"];
    [messageDictionary setObject:nick forKey:@"sender"];
    [sciHubMessageDelegate newGroupMessageReceived:messageDictionary];
    DDLogVerbose(@"xmpp room did receiveMessage");
}
- (void)xmppRoom:(XMPPRoom *)sender didChangeOccupants:(NSDictionary *)occupants {
    DDLogVerbose(@"xmpp room did receiveMessage");
}



#pragma mark - Private

- (void)setupStream {
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	// 
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		// 
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	// 
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
   
    
    
	
	// Setup roster
	// 
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	//xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
//    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
//	
//	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
//	
//	xmppRoster.autoFetchRoster = YES;
//	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	// 
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
//	xmppvCardStorage = [[XMPPvCardCoreDataStorage sharedInstance] retain];
//	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
//	
//	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
//	
	// Setup capabilities
	// 
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	// 
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	// 
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
//	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
//    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
//    
//    xmppCapabilities.autoFetchHashedCapabilities = YES;
//    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
   // [xmppRoom              activate:xmppStream];
	//[xmppRoster            activate:xmppStream];
	//[xmppvCardTempModule   activate:xmppStream];
	//[xmppvCardAvatarModule activate:xmppStream];
	//[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	//[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	// 
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	// 
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	// 
	// If you don't specify a hostPort, then the default (5222) will be used.
	
    [xmppStream setHostName:serverName];
    [xmppStream setHostPort:5222];	
	
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)sendMessage:(NSDictionary *)messageInfo {
	
	NSString *bodyString = [messageInfo objectForKey:@"body"];
    NSString *to = [messageInfo objectForKey:@"sender"];
    if(bodyString != nil && to != nil) {
		
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:bodyString];
		
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:to];
        [message addChild:body];
		
        [self.xmppStream sendElement:message];
		
    }
	
	
}

- (void)teardownStream {
	[xmppStream removeDelegate:self];
    [xmppRoom removeDelegate:self];
//	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
    [xmppRoom deactivate];
//	[xmppRoster            deactivate];
//    [xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	
	xmppStream = nil;
    
//	xmppReconnect = nil;
    xmppRoster = nil;
    xmppRoom = nil;
//	xmppRosterStorage = nil;
//	xmppCapabilities = nil;
//	xmppCapabilitiesStorage = nil;
}

- (void)goOnline {
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline {
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

- (void)joinChatRoom {
    
    if( xmppRoom.isJoined == NO ) {
        
        
        
        NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
        NSString* username = [[myJID componentsSeparatedByString:@"@"] objectAtIndex:0];
        
        NSString *roomName = [NSString stringWithFormat:@"%@%@", @"scihub@conference.", serverName];
        
        xmppRoom = [[XMPPRoom alloc] initWithRoomName:roomName nickName:username];
        [xmppRoom activate:xmppStream];
        [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [xmppRoom createOrJoinRoom];
    }

}


#pragma mark - Connect/disconnect

- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"];
    
//    
    //NSString *myJID = @"obama@ime.mo";
	//NSString *myPassword = @"obama";
    
	//
	// If you don't want to use the Settings view to set the JID, 
	// uncomment the section below to hard code a JID and password.
	//
	// Replace me with the proper JID and password:
	//	myJID = @"user@gmail.com/xmppframework";
	//	myPassword = @"";
    
	if (myJID == nil || myPassword == nil) {
		DDLogWarn(@"JID and password must be set before connecting!");
        
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting" 
		                                                    message:@"See console for error details." 
		                                                   delegate:nil 
		                                          cancelButtonTitle:@"Ok" 
		                                          otherButtonTitles:nil];
		[alertView show];
	
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
    
    
	return YES;
}

- (void)disconnect {
    [self goOffline];
    
    [xmppStream disconnect];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
       DDLogVerbose(@"%d",buttonIndex);
    
    if (buttonIndex == 1) {
        NSString *from = [lastMessageDict objectForKey:@"sender"];
       [sciHubMessageDelegate replyMessageTo:from ];
    }
}

@end
