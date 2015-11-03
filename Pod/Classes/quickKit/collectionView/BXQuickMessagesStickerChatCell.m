//
//  BXQuickMessagesStickerChatCell.m
//  Pods
//
//  Created by Xiang Li on 10/28/15.
//
//

#import "BXQuickMessagesStickerChatCell.h"

@interface BXQuickMessagesStickerChatCell()

@property (weak, nonatomic) NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation BXQuickMessagesStickerChatCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        [self initStickerImageView];
    }
    
    return self;
}

//- (void)setupCellWithMessage:(BXQuickMessage *)message
//{
//    if (message.messageType != BXQuickMessageType_Sticker) {
//        return;
//    }
//    
////    self.textView.textColor = self.buble.defaultTextColor;
////    
////    self.textView.text = message.text;
////    CGSize sizeThatFitsTextView = [self.textView sizeThatFits:CGSizeMake(self.maxContentWidth, MAXFLOAT)];
////    self.heightConstraint.constant = sizeThatFitsTextView.height;
////    self.widthConstraint.constant = sizeThatFitsTextView.width;
////    [self layoutIfNeeded];
//}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
//    // fix the bug that dataDectorTypes'state will be remainded when reusing
//    self.textView.dataDetectorTypes = UIDataDetectorTypeNone;
//    self.textView.text = nil;
//    self.textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
}

//- (void)setBuble:(BXQuickMessagesBubleModel *)buble
//{
//    [super setBuble:buble];
//    
//    self.textView.textColor = buble.defaultTextColor;
//}

//- (void)setTintColor:(UIColor *)tintColor
//{
//    [super setTintColor:tintColor];
//    
//    _textView.linkTextAttributes = @{NSForegroundColorAttributeName: tintColor, NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
//}

//#pragma mark - text view
//- (void)initStickerImageView
//{
//    [self addViewToContentContainer:self.stickerImageView bubleType:BXQuickMessagesChatCellContentInsideBuble borderColor:nil];
//    
//    self.stickerImageView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.stickerImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
//    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.stickerImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
//    self.heightConstraint.priority = 999;
//    [self.stickerImageView addConstraint:self.widthConstraint];
//    [self.stickerImageView addConstraint:self.heightConstraint];
//}
//
//- (UIImageView *)stickerImageView
//{
//    if (!_stickerImageView) {
//        _stickerImageView = [[UIImageView alloc] init];
//    }
//    return _stickerImageView;
//}

#pragma mark - static image view
- (UIImageView *)staticImageView
{
    if (!_staticImageView) {
        _staticImageView = [[UIImageView alloc] init];
        _staticImageView.contentMode = UIViewContentModeScaleAspectFit;
        _staticImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.staticImageWidthConstraint = [NSLayoutConstraint constraintWithItem:_staticImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
        self.staticImageHeightConstraint = [NSLayoutConstraint constraintWithItem:_staticImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
        self.staticImageHeightConstraint.priority = 999;
        [_staticImageView addConstraint:self.staticImageWidthConstraint];
        [_staticImageView addConstraint:self.staticImageHeightConstraint];
    }
    return _staticImageView;
}

#pragma mark - dynamic image view
- (FLAnimatedImageView *)dynamicImageView
{
    if (!_dynamicImageView) {
        _dynamicImageView = [[FLAnimatedImageView alloc] init];
        _dynamicImageView.contentMode = UIViewContentModeScaleAspectFit;
        _dynamicImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.dynamicImageWidthConstraint = [NSLayoutConstraint constraintWithItem:_dynamicImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
        self.dynamicImageHeightConstraint = [NSLayoutConstraint constraintWithItem:_dynamicImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
        self.dynamicImageHeightConstraint.priority = 999;
        [_dynamicImageView addConstraint:self.dynamicImageWidthConstraint];
        [_dynamicImageView addConstraint:self.dynamicImageHeightConstraint];
    }
    return _dynamicImageView;
}

@end
