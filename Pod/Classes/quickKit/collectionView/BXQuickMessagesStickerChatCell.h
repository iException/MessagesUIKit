//
//  BXQuickMessagesStickerChatCell.h
//  Pods
//
//  Created by Xiang Li on 10/28/15.
//
//

#import "BXQuickMessagesBaseChatCell.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface BXQuickMessagesStickerChatCell : BXQuickMessagesBaseChatCell

@property (nonatomic, strong) UIImageView *staticImageView;
@property (nonatomic, strong) NSLayoutConstraint *staticImageWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *staticImageHeightConstraint;

@property (nonatomic, strong) FLAnimatedImageView *dynamicImageView;
@property (nonatomic, strong) NSLayoutConstraint *dynamicImageWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *dynamicImageHeightConstraint;

- (void)stopAnimation;
- (void)startAnimation;

@end
