//
//  BXQuickMessagesTextChatCell.m
//  Baixing
//
//  Created by hyice on 15/3/26.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesTextChatCell.h"

@interface BXQuickMessagesChatCellTextView : UITextView

@end

@implementation BXQuickMessagesChatCellTextView

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:) ||
        action == @selector(selectAll:)
       ) {
        return YES;
    }

    return NO;
}

@end

@interface BXQuickMessagesTextChatCell()

@property (strong, nonatomic) BXQuickMessagesChatCellTextView *textView;
@property (weak, nonatomic) NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation BXQuickMessagesTextChatCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initTextView];
    }
    
    return self;
}

- (void)setupCellWithMessage:(BXQuickMessage *)message
{
    self.textView.textColor = self.buble.defaultTextColor;
    
    self.textView.text = message.text;
    CGSize sizeThatFitsTextView = [self.textView sizeThatFits:CGSizeMake(self.maxContentWidth, MAXFLOAT)];
    self.heightConstraint.constant = sizeThatFitsTextView.height;
    self.widthConstraint.constant = sizeThatFitsTextView.width;
    [self layoutIfNeeded];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // fix the bug that dataDectorTypes'state will be remainded when reusing
    self.textView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.textView.text = nil;
    self.textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
}

- (void)setBuble:(BXQuickMessagesBubleModel *)buble
{
    [super setBuble:buble];
    
    self.textView.textColor = buble.defaultTextColor;
}

#pragma mark - text view
- (void)initTextView
{
    [self addViewToContentContainer:self.textView bubleType:BXQuickMessagesChatCellContentInsideBuble borderColor:nil];
    
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    self.heightConstraint.priority = 999;
    [self.textView addConstraint:self.widthConstraint];
    [self.textView addConstraint:self.heightConstraint];
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[BXQuickMessagesChatCellTextView alloc] init];
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
        _textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
    }
    
    return _textView;
}
@end
