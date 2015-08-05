//
//  BXQuickMessagesStatusCell.h
//  Baixing
//
//  Created by hyice on 15/3/31.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXQuickMessage;

@interface BXQuickMessagesStatusCell : UICollectionViewCell

- (void)showTimeWithDate:(NSDate *)date;

- (void)setupCellWithMessage:(BXQuickMessage *)message;

@end
