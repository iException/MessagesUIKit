//
//  BXQuickMessagesBaseChatCell.m
//  Baixing
//
//  Created by hyice on 15/3/25.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesBaseChatCell.h"
#import "BXQuickMessagesTimeLabel.h"
#import "BXQuickMessage.h"
#import "UIView+BXMessagesKit.h"
#import "NSBundle+MessagesUIKit.h"
#import "UIImage+MessagesUIKit.h"

@interface BXQuickMessagesBaseChatCell()

@property (strong, nonatomic) UIImageView *avatar;
@property (weak, nonatomic) NSLayoutConstraint *avatarHorizontalMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *avatarVerticalMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *avatarWidthConstraint;
@property (weak, nonatomic) NSLayoutConstraint *avatarHeightConstraint;

@property (strong, nonatomic) UILabel *senderName;
@property (weak, nonatomic) NSLayoutConstraint *senderNameHorizontalMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *senderNameVerticalMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *senderNameWidthConstraint;
@property (weak, nonatomic) NSLayoutConstraint *senderNameHeightConstraint;

@property (strong, nonatomic) UIImageView *contentContainer;
@property (weak, nonatomic) NSLayoutConstraint *contentContainerHorizontalMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *contentContainerWidthConstraint;
@property (weak, nonatomic) NSLayoutConstraint *contentContainerTopMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *contentContainerBottomMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *contentViewLeftMargin;
@property (weak, nonatomic) NSLayoutConstraint *contentViewRightMargin;

@property (strong, nonatomic) UIActivityIndicatorView *sendingIndicator;
@property (weak, nonatomic) NSLayoutConstraint *sendingIndicatorLeftMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *sendingIndicatorRightMarginConstraint;

@property (strong, nonatomic) UIButton *actionButton;
@property (weak, nonatomic) NSLayoutConstraint *actionButtonLeftMarginConstraint;
@property (weak, nonatomic) NSLayoutConstraint *actionButtonRightMarginConstraint;

@property (strong, nonatomic) BXQuickMessagesTimeLabel *timeLabel;
@property (weak, nonatomic) NSLayoutConstraint *timeLabelHeightConstraint;

@property (strong, nonatomic) UIView *unreadBadge;
@property (weak, nonatomic) NSLayoutConstraint *unreadBadgeHorizontalConstraint;

@property (strong, nonatomic) UILabel *contentDescriptionLabel;
@property (weak, nonatomic) NSLayoutConstraint *contentDescriptionHorizontalConstraint;

@property (assign, nonatomic) BXQuickMessagesChatCellContentBubleType bubleType;

@end

@implementation BXQuickMessagesBaseChatCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initViews];
        [self addTapGesture];
    }
    
    return self;
}

- (void)initViews
{
    [self initTimeLabel];
    [self initAvatar];
    [self initSenderName];
    [self initContentContainer];
    [self initSendingIndicator];
    [self initActionButton];
    [self initUnreadBadge];
    [self initContentDescriptionLabel];
}

#pragma mark - time label
- (void)initTimeLabel
{
    [self addSubview:self.timeLabel];
    
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:7]];
    self.timeLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    self.timeLabelHeightConstraint.priority = 999;
    [self addConstraint:self.timeLabelHeightConstraint];
}

- (BXQuickMessagesTimeLabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[BXQuickMessagesTimeLabel alloc] initWithInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    }
    
    return _timeLabel;
}

- (void)showTimeWithDate:(NSDate *)date
{
    if (date == nil) {
        self.timeLabelHeightConstraint.constant = 0;
        return;
    }
    
    [self.timeLabel showTimeWithDate:date];
    self.timeLabelHeightConstraint.constant = 15;
}

#pragma mark - avatar
- (void)initAvatar
{
    [self addSubview:self.avatar];
    
    self.avatar.translatesAutoresizingMaskIntoConstraints = NO;
    
    _showAvatar = YES;
    _avatarPosition = BXQuickMessagesChatCellAvatarPostion_LeftTop;
    _avatarSize = CGSizeMake(40, 40);
    
    [self updateMarginConstraintsForAvatar];
    [self updateSizeConstraintsForAvatar];
    
    self.defaultAvataImagerName = @"avator";
}

- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.userInteractionEnabled = YES;
        _avatar.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _avatar;
}

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar == showAvatar) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(showAvatar))];
    _showAvatar = showAvatar;
    [self didChangeValueForKey:NSStringFromSelector(@selector(showAvatar))];
    
    self.avatar.hidden = !showAvatar;
    [self updateSizeConstraintsForAvatar];
}

- (void)setAvatarPosition:(BXQuickMessagesChatCellAvatarPostion)avatarPosition
{
    if (_avatarPosition == avatarPosition) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(avatarPosition))];
    _avatarPosition = avatarPosition;
    [self didChangeValueForKey:NSStringFromSelector(@selector(avatarPosition))];
    
    [self updateMarginConstraintsForAvatar];
    [self updateMarginConstraintsForSenderName];
    [self updateMarginConstraintsForContentContainer];
    [self updateMarginConstraintForSendingIndicator];
    [self updateMarginConstraintForActionButton];
    [self updateBubleImage];
    [self updateMarginValueForContentView];
    [self updateUnreadBadgeHorizontalConstraint];
    [self updateContentDescriptionLabelConstraint];
}

- (void)setAvatarSize:(CGSize)avatarSize
{
    if (_avatarSize.width == avatarSize.width
        && _avatarSize.height == avatarSize.height) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(avatarSize))];
    _avatarSize = avatarSize;
    [self didChangeValueForKey:NSStringFromSelector(@selector(avatarSize))];
    
    [self updateSizeConstraintsForAvatar];
}

- (void)setDefaultAvataImagerName:(NSString *)defaultAvataImagerName
{
    if ([_defaultAvataImagerName isEqualToString:defaultAvataImagerName]) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(defaultAvataImagerName))];
    _defaultAvataImagerName = defaultAvataImagerName;
    [self didChangeValueForKey:NSStringFromSelector(@selector(defaultAvataImagerName))];
    
    self.avatar.image = [UIImage buk_imageNamed:defaultAvataImagerName];
}

- (void)updateMarginConstraintsForAvatar
{
    if (!_avatar) {
        return;
    }

    if (self.avatarVerticalMarginConstraint) {
        [self removeConstraint:self.avatarVerticalMarginConstraint];
    }
    
    if (self.avatarHorizontalMarginConstraint) {
        [self removeConstraint:self.avatarHorizontalMarginConstraint];
    }
    
    BOOL isTop = [self isTop];
    BOOL isLeft = [self isLeft];
    
    self.avatarVerticalMarginConstraint = [NSLayoutConstraint constraintWithItem:self.avatar
                                                                       attribute:isTop? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:isTop? self.timeLabel : self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:isTop? 3 :  -10];
    [self addConstraint:self.avatarVerticalMarginConstraint];
    
    self.avatarHorizontalMarginConstraint = [NSLayoutConstraint constraintWithItem:self.avatar
                                                                         attribute:isLeft? NSLayoutAttributeLeft : NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:isLeft? NSLayoutAttributeLeft : NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:isLeft? 10 : -10];
    [self addConstraint:self.avatarHorizontalMarginConstraint];
}

- (void)updateSizeConstraintsForAvatar
{
    if (!_avatar) {
        return;
    }
    
    if (!self.avatarWidthConstraint) {
        self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatar
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0
                                                                   constant:self.avatarSize.width];
        [self addConstraint:self.avatarWidthConstraint];
    }
    
    if (!self.avatarHeightConstraint) {
        self.avatarHeightConstraint = [NSLayoutConstraint constraintWithItem:self.avatar
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1.0
                                                                    constant:self.avatarSize.height];
        [self addConstraint:self.avatarHeightConstraint];
    }
    
    self.avatarWidthConstraint.constant = self.showAvatar? self.avatarSize.width : 0;
    self.avatarHeightConstraint.constant = self.avatarSize.height;
}

#pragma mark - sender display name
- (void)initSenderName
{
    [self addSubview:self.senderName];
    
    self.senderName.translatesAutoresizingMaskIntoConstraints = NO;
    
    _showSenderName = NO;
    
    [self updateMarginConstraintsForSenderName];
    [self updateSizeConstraintsForSenderName];
}

- (UILabel *)senderName
{
    if (!_senderName) {
        _senderName = [[UILabel alloc] init];
        _senderName.font = [UIFont systemFontOfSize:13];
        _senderName.textColor = [UIColor colorWithRed:0x89/255.0 green:0x89/255.0 blue:0x89/255.0 alpha:1.0];
        _senderName.text = @"用户";
        _senderName.clipsToBounds = YES;
    }
    
    return _senderName;
}

- (void)setSenderNameHeight:(CGFloat)senderNameHeight
{
    if (_senderNameHeight == senderNameHeight) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(senderNameHeight))];
    _senderNameHeight = senderNameHeight;
    [self didChangeValueForKey:NSStringFromSelector(@selector(senderNameHeight))];
    
    [self updateSizeConstraintsForSenderName];
}

- (void)setShowSenderName:(BOOL)showSenderName
{
    if (_showSenderName == showSenderName) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(showSenderName))];
    _showSenderName = showSenderName;
    [self didChangeValueForKey:NSStringFromSelector(@selector(showSenderName))];
    
    if (_showSenderName) {
        _senderNameHeight = 15;
        _paddingOfSenderNameAndAvatar = 12;
    }else {
        _senderNameHeight = 0;
        _paddingOfSenderNameAndAvatar = 0;
    }
    
    self.senderName.hidden = !showSenderName;
    [self updateSizeConstraintsForSenderName];
}

- (void)setPaddingOfSenderNameAndAvatar:(CGFloat)paddingOfSenderNameAndAvatar
{
    if (_paddingOfSenderNameAndAvatar == paddingOfSenderNameAndAvatar) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(paddingOfSenderNameAndAvatar))];
    _paddingOfSenderNameAndAvatar = paddingOfSenderNameAndAvatar;
    [self didChangeValueForKey:NSStringFromSelector(@selector(paddingOfSenderNameAndAvatar))];
    
    [self updateMarginConstraintsForSenderName];
}

- (void)updateMarginConstraintsForSenderName
{
    if (!_senderName) {
        return;
    }
    
    BOOL isLeft = [self isLeft];
    BOOL isTop = [self isTop];
    
    if (self.senderNameHorizontalMarginConstraint) {
        [self removeConstraint:self.senderNameHorizontalMarginConstraint];
    }
    
    if (self.senderNameVerticalMarginConstraint) {
        [self removeConstraint:self.senderNameVerticalMarginConstraint];
    }
    
    self.senderNameHorizontalMarginConstraint = [NSLayoutConstraint constraintWithItem:self.senderName
                                                                             attribute:isLeft? NSLayoutAttributeLeft : NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.avatar
                                                                             attribute:isLeft? NSLayoutAttributeRight : NSLayoutAttributeLeft
                                                                            multiplier:1.0
                                                                              constant:self.paddingOfSenderNameAndAvatar * (isLeft? 1 : -1)];
    [self addConstraint:self.senderNameHorizontalMarginConstraint];
    
    self.senderNameVerticalMarginConstraint = [NSLayoutConstraint constraintWithItem:self.senderName
                                                                           attribute:isTop? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.avatar
                                                                           attribute:isTop? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:0];
    [self addConstraint:self.senderNameVerticalMarginConstraint];
}

- (void)updateSizeConstraintsForSenderName
{
    if (!_senderName) {
        return;
    }
    
    if (!self.senderNameWidthConstraint) {
        self.senderNameWidthConstraint = [NSLayoutConstraint constraintWithItem:self.senderName
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:200];
        [self addConstraint:self.senderNameWidthConstraint];
    }
    
    if (!self.senderNameHeightConstraint) {
        self.senderNameHeightConstraint = [NSLayoutConstraint constraintWithItem:self.senderName
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:self.senderNameHeight];
        [self addConstraint:self.senderNameHeightConstraint];
    }
    
    self.senderNameHeightConstraint.constant = self.showSenderName? self.senderNameHeight : 0;
}

#pragma mark - content container
- (void)initContentContainer
{
    [self addSubview:self.contentContainer];
    
    self.contentContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.maxContentWidth = self.frame.size.width * 0.65;
    
    [self updateBubleImage];
    
    [self updateMarginConstraintsForContentContainer];
}

- (void)setMaxContentWidth:(CGFloat)maxContentWidth
{
    if (_maxContentWidth == maxContentWidth) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(maxContentWidth))];
    _maxContentWidth = maxContentWidth;
    [self didChangeValueForKey:NSStringFromSelector(@selector(maxContentWidth))];
    
    [self updateWidthConstraintForContentContainer];
}

- (void)addViewToContentContainer:(UIView *)view bubleType:(BXQuickMessagesChatCellContentBubleType)bubleType borderColor:(UIColor *)borderColor
{
    self.bubleType = bubleType;
    
    if (bubleType == BXQuickMessagesChatCellContentWithBubleMask) {
        if (borderColor) {
            [self.contentContainer setImage:[self.buble resizableImageWithMaskColor:borderColor borderColor:borderColor]];
        }else {
            [self.contentContainer setImage:nil];
        }
    }else {
        [self.contentContainer setImage:[self.buble resizableImageWithMaskColor:self.buble.defaultMaskColor borderColor:borderColor? borderColor : self.buble.defaultBorderColor]];
    }
    
    [self.contentContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [self.contentContainer addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentContainer
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:bubleType == BXQuickMessagesChatCellContentInsideBuble? self.buble.bubleContentInsets.top : 0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentContainer
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:bubleType == BXQuickMessagesChatCellContentInsideBuble? -self.buble.bubleContentInsets.bottom : 0]];
    
    self.contentViewLeftMargin = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.contentContainer
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:0];
    [self addConstraint:self.contentViewLeftMargin];
    
    self.contentViewRightMargin = [NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentContainer
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:0];
    [self addConstraint:self.contentViewRightMargin];
    
    [self updateMarginValueForContentView];
    
    if (bubleType == BXQuickMessagesChatCellContentWithBubleMask) {
        UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:[self.buble resizableImageWithBorderColor:[UIColor clearColor]]];
        CGRect maskFrame = view.bounds;
        maskFrame.size.width = MIN(maskFrame.size.width, self.maxContentWidth);
        imageViewMask.frame = maskFrame;
        view.layer.mask = imageViewMask.layer;
        view.layer.masksToBounds = YES;
    }
}

- (UIImageView *)contentContainer
{
    if (!_contentContainer) {
        _contentContainer = [[UIImageView alloc] init];
        _contentContainer.userInteractionEnabled = YES;
    }
    
    return _contentContainer;
}

- (void)setBuble:(BXQuickMessagesBubleModel *)buble
{
    if (_buble == buble) {
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(buble))];
    _buble = buble;
    [self didChangeValueForKey:NSStringFromSelector(@selector(buble))];
    
    [self.contentContainer setImage:buble.resizableImage];

    [self updateWidthConstraintForContentContainer];
}

- (void)updateBubleImage
{
    if (!_contentContainer) {
        return;
    }
    
    BOOL isLeft = [self isLeft];
    BOOL isTop = [self isTop];
    
    self.buble = [BXQuickMessagesBubleModel defaultBubleWithTop:isTop left:isLeft];
}

- (void)updateMarginConstraintsForContentContainer
{
    if (!_contentContainer) {
        return;
    }
    
    BOOL isLeft = [self isLeft];
    BOOL isTop = [self isTop];
    
    if (self.contentContainerHorizontalMarginConstraint) {
        [self removeConstraint:self.contentContainerHorizontalMarginConstraint];
    }
    
    if (self.contentContainerTopMarginConstraint) {
        [self removeConstraint:self.contentContainerTopMarginConstraint];
    }
    
    if (self.contentContainerBottomMarginConstraint) {
        [self removeConstraint:self.contentContainerBottomMarginConstraint];
    }
    
    self.contentContainerHorizontalMarginConstraint = [NSLayoutConstraint constraintWithItem:self.contentContainer
                                                                             attribute:isLeft? NSLayoutAttributeLeft : NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.avatar
                                                                             attribute:isLeft? NSLayoutAttributeRight : NSLayoutAttributeLeft
                                                                            multiplier:1.0
                                                                              constant:12 * (isLeft? 1 : -1)];
    [self addConstraint:self.contentContainerHorizontalMarginConstraint];
    
    
    self.contentContainerTopMarginConstraint = [NSLayoutConstraint constraintWithItem:self.contentContainer
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:isTop? self.senderName : self
                                                                            attribute:isTop? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                                                           multiplier:1.0
                                                                             constant:isTop? 0 : 10];
    [self addConstraint:self.contentContainerTopMarginConstraint];
    
    self.contentContainerBottomMarginConstraint = [NSLayoutConstraint constraintWithItem:self.contentContainer
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:isTop? self : self.senderName
                                                                               attribute:isTop? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:isTop? -10 : 0];
    [self addConstraint:self.contentContainerBottomMarginConstraint];
}

- (void)updateWidthConstraintForContentContainer
{
    if (!self.contentContainerWidthConstraint) {
        self.contentContainerWidthConstraint = [NSLayoutConstraint constraintWithItem:self.contentContainer
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:0];
        [self addConstraint:self.contentContainerWidthConstraint];
    }
    
    self.contentContainerWidthConstraint.constant = _maxContentWidth + self.buble.bubleContentInsets.left + self.buble.bubleContentInsets.right;
}

- (void)updateMarginValueForContentView
{
    if (self.contentViewLeftMargin) {
        self.contentViewLeftMargin.constant = self.bubleType == BXQuickMessagesChatCellContentInsideBuble? self.buble.bubleContentInsets.left : 0;
        self.contentViewRightMargin.constant = self.bubleType == BXQuickMessagesChatCellContentInsideBuble? -self.buble.bubleContentInsets.right : 0;
    }
}

#pragma mark - unread badge
- (void)initUnreadBadge
{
    [self addSubview:self.unreadBadge];
    
    self.unreadBadge.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.unreadBadge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:3]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.unreadBadge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:6]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.unreadBadge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.unreadBadge attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    [self updateUnreadBadgeHorizontalConstraint];
}

- (void)updateUnreadBadgeHorizontalConstraint
{
    if (self.unreadBadgeHorizontalConstraint) {
        [self removeConstraint:self.unreadBadgeHorizontalConstraint];
    }
    
    BOOL isLeft = [self isLeft];
    self.unreadBadgeHorizontalConstraint = [NSLayoutConstraint constraintWithItem:self.unreadBadge
                                                                        attribute:isLeft? NSLayoutAttributeLeft : NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentContainer
                                                                        attribute:isLeft? NSLayoutAttributeRight : NSLayoutAttributeLeft
                                                                       multiplier:1.0
                                                                         constant:isLeft? 3.0f : -3.0f];
    [self addConstraint:self.unreadBadgeHorizontalConstraint];
}

- (UIView *)unreadBadge
{
    if (!_unreadBadge) {
        _unreadBadge = [[UIView alloc] init];
        _unreadBadge.backgroundColor = [UIColor colorWithRed:0.376f green:0.569f blue:0.898f alpha:1.0f];
        _unreadBadge.hidden = YES;
        _unreadBadge.layer.cornerRadius = 3;
        _unreadBadge.clipsToBounds = YES;
    }
    
    return _unreadBadge;
}

#pragma mark - content description
- (void)initContentDescriptionLabel
{
    [self addSubview:self.contentDescriptionLabel];
    
    self.contentDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentDescriptionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-3]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentDescriptionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:13]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentDescriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200]];
    
    [self updateContentDescriptionLabelConstraint];
}

- (void)updateContentDescriptionLabelConstraint
{
    if (self.contentDescriptionHorizontalConstraint) {
        [self removeConstraint:self.contentDescriptionHorizontalConstraint];
    }
    
    BOOL isLeft = [self isLeft];
    self.contentDescriptionHorizontalConstraint = [NSLayoutConstraint constraintWithItem:self.contentDescriptionLabel
                                                                               attribute:isLeft? NSLayoutAttributeLeft : NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.contentContainer
                                                                               attribute:isLeft? NSLayoutAttributeRight : NSLayoutAttributeLeft
                                                                              multiplier:1.0
                                                                                constant:isLeft? 3.0f : -3.0f];
    self.contentDescriptionLabel.textAlignment = isLeft? NSTextAlignmentLeft : NSTextAlignmentRight;
    [self addConstraint:self.contentDescriptionHorizontalConstraint];
}

- (UILabel *)contentDescriptionLabel
{
    if (!_contentDescriptionLabel) {
        _contentDescriptionLabel = [[UILabel alloc] init];
        _contentDescriptionLabel.font = [UIFont systemFontOfSize:12];
        _contentDescriptionLabel.textColor = [UIColor colorWithRed:0x89/255.0 green:0x89/255.0 blue:0x89/255.0 alpha:1.0];
    }
    
    return _contentDescriptionLabel;
}

#pragma mark - sending indicator
- (void)initSendingIndicator
{
    [self addSubview:self.sendingIndicator];
    
    self.sendingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addUnChangeConstraintsForIndicatorOrActionButton:self.sendingIndicator];
    
    [self updateMarginConstraintForSendingIndicator];
}

- (void)addUnChangeConstraintsForIndicatorOrActionButton:(UIView *)view
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

- (UIActivityIndicatorView *)sendingIndicator
{
    if (!_sendingIndicator) {
        _sendingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _sendingIndicator.hidesWhenStopped = YES;
    }
    
    return _sendingIndicator;
}

- (void)updateMarginConstraintForSendingIndicator
{
    if (!_sendingIndicator) {
        return;
    }
    
    if (self.sendingIndicatorLeftMarginConstraint) {
        [self removeConstraint:self.sendingIndicatorLeftMarginConstraint];
    }
    
    if (self.sendingIndicatorRightMarginConstraint) {
        [self removeConstraint:self.sendingIndicatorRightMarginConstraint];
    }
    
    if (self.avatarPosition == BXQuickMessagesChatCellAvatarPostion_LeftTop
        || self.avatarPosition == BXQuickMessagesChatCellAvatarPostion_LeftBottom) {
        self.sendingIndicatorLeftMarginConstraint = [NSLayoutConstraint constraintWithItem:self.sendingIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:3];
        [self addConstraint:self.sendingIndicatorLeftMarginConstraint];
    }else {
        self.sendingIndicatorRightMarginConstraint = [NSLayoutConstraint constraintWithItem:self.sendingIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:3];
        [self addConstraint:self.sendingIndicatorRightMarginConstraint];
    }
}

#pragma mark - action button
- (void)initActionButton
{
    [self addSubview:self.actionButton];
    
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addUnChangeConstraintsForIndicatorOrActionButton:self.actionButton];
    
    [self updateMarginConstraintForActionButton];
}

- (UIButton *)actionButton
{
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        _actionButton.hidden = YES;
        [_actionButton setImage:[UIImage buk_imageNamed:@"warning-button"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _actionButton;
}

- (void)actionButtonPressed:(UIButton *)actionButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessagesChatCellDidTappedResendButton:)]) {
        [self.delegate bxQuickMessagesChatCellDidTappedResendButton:self];
    }
}

- (void)updateMarginConstraintForActionButton
{
    if (!_actionButton) {
        return;
    }
    
    if (self.actionButtonLeftMarginConstraint) {
        [self removeConstraint:self.actionButtonLeftMarginConstraint];
    }
    
    if (self.actionButtonRightMarginConstraint) {
        [self removeConstraint:self.actionButtonRightMarginConstraint];
    }
    
    if (self.avatarPosition == BXQuickMessagesChatCellAvatarPostion_LeftTop
        || self.avatarPosition == BXQuickMessagesChatCellAvatarPostion_LeftBottom) {
        self.actionButtonLeftMarginConstraint = [NSLayoutConstraint constraintWithItem:self.actionButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:3];
        [self addConstraint:self.actionButtonLeftMarginConstraint];
    }else {
        self.actionButtonRightMarginConstraint = [NSLayoutConstraint constraintWithItem:self.actionButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:3];
        [self addConstraint:self.actionButtonRightMarginConstraint];
    }
}

#pragma mark - tap gesture
- (void)addTapGesture
{
    UITapGestureRecognizer *contentContainerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentContainerTapped:)];
    [self.contentContainer addGestureRecognizer:contentContainerTap];
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)];
    [self.avatar addGestureRecognizer:avatarTap];
}

- (void)contentContainerTapped:(UITapGestureRecognizer *)tap
{
    if (!self.delegate) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(bxQuickMessagesChatCellDidTappedBuble:)]) {
        [self.delegate bxQuickMessagesChatCellDidTappedBuble:self];
    }
    
    self.unreadBadge.hidden = YES;
}

- (void)avatarTapped:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessagesChatCellDidTappedAvatar:)]) {
        [self.delegate bxQuickMessagesChatCellDidTappedAvatar:self];
    }
}

#pragma mark - calculate position
- (BOOL)isLeft
{
    BOOL isLeft;
    switch (self.avatarPosition) {
            
        case BXQuickMessagesChatCellAvatarPostion_RightTop:
        case BXQuickMessagesChatCellAvatarPostion_RightBottom:
            isLeft = NO;
            break;
            
        case BXQuickMessagesChatCellAvatarPostion_LeftTop:
        case BXQuickMessagesChatCellAvatarPostion_LeftBottom:
        default:
            isLeft = YES;
            break;
    }
    
    return isLeft;
}

- (BOOL)isTop
{
    BOOL isTop;
    switch (self.avatarPosition) {
        case BXQuickMessagesChatCellAvatarPostion_LeftBottom:
        case BXQuickMessagesChatCellAvatarPostion_RightBottom:
            isTop = NO;
            break;
            
        case BXQuickMessagesChatCellAvatarPostion_LeftTop:
        case BXQuickMessagesChatCellAvatarPostion_RightTop:
        default:
            isTop = YES;
            break;
    }
    
    return isTop;
}

#pragma mark - send status
- (void)setSendStatus:(BXQuickMessageSendStatus)sendStatus
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(sendStatus))];
    _sendStatus = sendStatus;
    [self didChangeValueForKey:NSStringFromSelector(@selector(sendStatus))];
    
    if (sendStatus == BXQuickMessageSendStatus_Sended) {
        [self.sendingIndicator stopAnimating];
        self.actionButton.hidden = YES;
    }else if (sendStatus == BXQuickMessageSendStatus_Sending) {
        [self.sendingIndicator startAnimating];
        self.actionButton.hidden = YES;
    }else if (sendStatus == BXQuickMessageSendStatus_Failed) {
        [self.sendingIndicator stopAnimating];
        self.actionButton.hidden = NO;
    }
}

#pragma mark - setup cell
- (void)setupCellWithMessage:(BXQuickMessage *)message {}
@end
