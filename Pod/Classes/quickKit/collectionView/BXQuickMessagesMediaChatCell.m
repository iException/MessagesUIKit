//
//  BXQuickMessagesMediaChatCell.m
//  Baixing
//
//  Created by hyice on 15/3/30.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesMediaChatCell.h"
#import "UIView+BXMessagesKit.h"

@interface BXQuickMessagesMediaChatCell()

@property (strong, nonatomic) id<BXQuickMessageMedia> displayingMedia;

@end

@implementation BXQuickMessagesMediaChatCell

- (void)setupCellWithMedia:(id<BXQuickMessageMedia>)media
{
    self.displayingMedia = media;
    
    self.unreadBadge.hidden = ![media displayUnreadBadgeBeforeTap];
    
    self.contentDescriptionLabel.text = [media contentDescription];
    
    UIView *mediaView = [media mediaView];
    
    [self updateSizeConstraintsForMedia:media];
    
    UIColor *borderColor;
    if ([media respondsToSelector:@selector(borderColorForBubleMask)]) {
        borderColor = [media borderColorForBubleMask];
    }
    
    if ([media displayWithBubleMask]) {
        [self addViewToContentContainer:mediaView bubleType:BXQuickMessagesChatCellContentWithBubleMask borderColor:borderColor];
    }else {
        [self addViewToContentContainer:mediaView bubleType:BXQuickMessagesChatCellContentInsideBuble borderColor:borderColor];
    }
}

- (void)setupCellWithMessage:(BXQuickMessage *)message
{
    [self setupCellWithMedia:message.media];
}

- (void)updateSizeConstraintsForMedia:(id<BXQuickMessageMedia>)media
{
    UIView *mediaView = [media mediaView];
    CGSize displaySize = CGSizeZero;
    if ([media respondsToSelector:@selector(displaySize)]) {
        displaySize = media.displaySize;
    }

    mediaView.bounds = CGRectMake(0, 0, displaySize.width, displaySize.height);
    mediaView.clipsToBounds = YES;
    
    mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [mediaView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == mediaView && constraint.secondItem == nil
            && (constraint.firstAttribute == NSLayoutAttributeWidth || constraint.firstAttribute == NSLayoutAttributeHeight)) {
            [mediaView removeConstraint:constraint];
        }
    }];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:mediaView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:MIN(displaySize.width, self.maxContentWidth)];
    widthConstraint.priority = 999;
    [mediaView addConstraint:widthConstraint];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:mediaView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:displaySize.height];
    heightConstraint.priority = 999;
    [mediaView addConstraint:heightConstraint];
    
}

@end
