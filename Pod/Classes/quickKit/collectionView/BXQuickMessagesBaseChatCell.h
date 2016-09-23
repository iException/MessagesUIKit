//
//  BXQuickMessagesBaseChatCell.h
//  Baixing
//
//  Created by hyice on 15/3/25.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

@import UIKit;
#import "BXQuickMessagesBubleModel.h"
#import "BXQuickMessage.h"

@class BXQuickMessagesBaseChatCell;

typedef NS_ENUM(NSInteger, BXQuickMessagesChatCellAvatarPostion) {
    BXQuickMessagesChatCellAvatarPostion_Unknown = 0,
    BXQuickMessagesChatCellAvatarPostion_LeftTop,
    BXQuickMessagesChatCellAvatarPostion_LeftBottom,
    BXQuickMessagesChatCellAvatarPostion_RightTop,
    BXQuickMessagesChatCellAvatarPostion_RightBottom
};

typedef NS_ENUM(NSInteger, BXQuickMessagesChatCellContentBubleType) {
    BXQuickMessagesChatCellContentInsideBuble,
    BXQuickMessagesChatCellContentWithBubleMask
};

@protocol BXQuickMessagesChatCellDelegate <NSObject>

- (void)bxQuickMessagesChatCellDidTappedAvatar:(BXQuickMessagesBaseChatCell *)cell;
- (void)bxQuickMessagesChatCellDidTappedBuble:(BXQuickMessagesBaseChatCell *)cell;
- (void)bxQuickMessagesChatCellDidTappedResendButton:(BXQuickMessagesBaseChatCell *)cell;

@end

@interface BXQuickMessagesBaseChatCell : UICollectionViewCell

@property (strong, nonatomic, readonly) UIImageView *avatar;

/**
 *  Default YES.
 */
@property (assign, nonatomic) BOOL showAvatar;

/**
 *  Default BXQuickMessagesChatCellAvatarPostion_LeftTop.
 */
@property (assign, nonatomic) BXQuickMessagesChatCellAvatarPostion avatarPosition;

/**
 *  Default 40 * 40.
 */
@property (assign, nonatomic) CGSize avatarSize;

/**
 *  Default @"avator".
 */
@property (copy, nonatomic) NSString *defaultAvataImagerName;

@property (strong, nonatomic, readonly) UILabel *senderName;

/**
 *  Default YES.
 */
@property (assign, nonatomic) BOOL showSenderName;

/**
 *  Default 15.
 */
@property (assign, nonatomic) CGFloat senderNameHeight;

@property (assign, nonatomic) CGFloat paddingOfSenderNameAndAvatar;

@property (strong, nonatomic, readonly) UIImageView *contentContainer;

@property (strong, nonatomic) BXQuickMessagesBubleModel *buble;

@property (assign, nonatomic) CGFloat maxContentWidth;

@property (nonatomic, readonly) UIView *unreadBadge;

@property (nonatomic, readonly) UILabel *contentDescriptionLabel;

@property (weak, nonatomic) id<BXQuickMessagesChatCellDelegate> delegate;

@property (assign, nonatomic) BXQuickMessageSendStatus sendStatus;
/**
 *  Can Only Add One View!
 */
- (void)addViewToContentContainer:(UIView *)view
                        bubleType:(BXQuickMessagesChatCellContentBubleType)bubleType
                      borderColor:(UIColor *)borderColor;

- (void)showTimeWithDate:(NSDate *)date;

- (void)setupCellWithMessage:(BXQuickMessage *)message;

@end
