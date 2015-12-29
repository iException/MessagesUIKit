//
//  BXQuickMessagesStatusCell.m
//  Baixing
//
//  Created by hyice on 15/3/31.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesStatusCell.h"
#import "BXQuickMessagesTimeLabel.h"
#import "BXQuickMessagesStatusLabel.h"
#import "BXQuickMessage.h"

@interface BXQuickMessagesStatusCell()

@property (strong, nonatomic) BXQuickMessagesTimeLabel *timeLabel;
@property (weak, nonatomic) NSLayoutConstraint *timeLabelHeightConstraint;

@property (strong, nonatomic) BXQuickMessagesStatusLabel *statusLabel;

@end

@implementation BXQuickMessagesStatusCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initViews];
    }
    
    return self;
}

- (void)initViews
{
    [self initTimeLabel];
    [self initStatusLabel];
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

#pragma mark - status label
- (void)initStatusLabel
{
    [self addSubview:self.statusLabel];
    
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.timeLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
}

- (BXQuickMessagesStatusLabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[BXQuickMessagesStatusLabel alloc] initWithInsets:UIEdgeInsetsMake(4, 6, 4, 6)];
        _statusLabel.numberOfLines = 0;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.preferredMaxLayoutWidth = self.bounds.size.width - 20;
    }
    
    return _statusLabel;
}

- (void)updateStatusText:(NSString *)statusText
{
    self.statusLabel.text = statusText;
}

- (void)setupCellWithMessage:(BXQuickMessage *)message
{
    if (message.attributedText && [message respondsToSelector:@selector(setAttributedText:)]) {
        self.statusLabel.attributedText = message.attributedText;
    } else {
        self.statusLabel.text = message.text;
    }
}

@end
