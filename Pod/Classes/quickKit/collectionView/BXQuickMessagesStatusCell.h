//
//  BXQuickMessagesStatusCell.h
//  Baixing
//
//  Created by hyice on 15/3/31.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

@import UIKit;

@class BXQuickMessage;
@class BXQuickMessagesStatusLabel;

@interface BXQuickMessagesStatusCell : UICollectionViewCell

@property (strong, nonatomic, readonly) BXQuickMessagesStatusLabel *statusLabel;

- (void)showTimeWithDate:(NSDate *)date;

- (void)setupCellWithMessage:(BXQuickMessage *)message;

@end
