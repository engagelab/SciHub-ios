//
//  SciHubMessageDelegate.h
//  SciHub-ios
//
//  Created by Anthony Perritano on 9/23/11.
//  Copyright (c) 2011 .t. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SciHubMessageDelegate

- (void)newMessageReceived:(NSDictionary *)messageContent;

- (void)replyMessageTo:(NSString *)from;

@end
