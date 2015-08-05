//
//  BXMessagesInputRecordView.h
//  Baixing
//
//  Created by hyice on 15/3/23.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BXMessagesInputRecordViewType) {
    BXMessagesInputRecordViewUnknownType = 0,
    BXMessagesInputRecordViewRecordType,
    BXMessagesInputRecordViewCacelType
};

@interface BXMessagesInputRecordView : UIView

@property (assign, nonatomic) BXMessagesInputRecordViewType type;

@property (assign, nonatomic) CGFloat volumnRate;

@end
