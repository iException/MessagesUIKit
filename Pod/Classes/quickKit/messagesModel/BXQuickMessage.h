//
//  BXQuickMessage.h
//  Baixing
//
//  Created by hyice on 15/3/25.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXQuickMessageMedia.h"

typedef NS_ENUM(NSInteger, BXQuickMessageSendStatus) {
    BXQuickMessageSendStatus_Unknown = 0,
    BXQuickMessageSendStatus_Sending = 1,
    BXQuickMessageSendStatus_Sended = 2,
    BXQuickMessageSendStatus_Failed = 3
};

typedef NS_ENUM(NSInteger, BXQuickMessageType) {
    BXQuickMessageType_Unknown,
    BXQuickMessageType_Status,
    BXQuickMessageType_Text,
    BXQuickMessageType_Media,
    BXQuickMessageType_Other
};

@interface BXQuickMessage : NSObject

@property (copy, nonatomic) NSString *messageId;

@property (copy, nonatomic) NSString *senderId;

@property (copy, nonatomic) NSString *text;

@property (strong, nonatomic) NSDate *date;

@property (assign, nonatomic) BXQuickMessageSendStatus sendStatus;

@property (assign, nonatomic) BXQuickMessageType messageType;

@property (strong, nonatomic) id<BXQuickMessageMedia> media;

@property (strong, nonatomic) id extra;

@end
