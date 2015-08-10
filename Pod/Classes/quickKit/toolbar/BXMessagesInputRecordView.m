//
//  BXMessagesInputRecordView.m
//  Baixing
//
//  Created by hyice on 15/3/23.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputRecordView.h"
#import "NSBundle+MessagesUIKit.h"
#import "UIImage+MessagesUIKit.h"

@interface BXMessagesInputRecordView()

@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UILabel *textLabel;

@property (strong, nonatomic) UIImageView *recordIcon;
@property (strong, nonatomic) UIImageView *voiceIcon;
@property (strong, nonatomic) UIImageView *cancelIcon;

@end

@implementation BXMessagesInputRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;

        [self initViews];
        
        self.type = BXMessagesInputRecordViewRecordType;
    }
    
    return self;
}

- (void)initViews
{
    [self initBackgroundView];
    [self initTextLabel];
    [self initCancelIcon];
    [self initRecordIcon];
    [self initVoiceIcon];
}

- (void)setType:(BXMessagesInputRecordViewType)type
{
    if (_type == type) {
        return;
    }
    
    switch (type) {
        case BXMessagesInputRecordViewRecordType:
            self.textLabel.text = @"手指上滑，取消发送";
            self.textLabel.backgroundColor = [UIColor clearColor];
            self.cancelIcon.hidden = YES;
            self.voiceIcon.hidden = NO;
            self.recordIcon.hidden = NO;
            break;
            
        case BXMessagesInputRecordViewCacelType:
            self.textLabel.text = @"手指松开，取消发送";
            self.textLabel.backgroundColor = [UIColor redColor];
            self.cancelIcon.hidden = NO;
            self.voiceIcon.hidden = YES;
            self.recordIcon.hidden = YES;
            break;
            
        default:
            break;
    }
    
    _type = type;
}

#pragma mark - background viwe
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.5;
    }
    
    return _backgroundView;
}

- (void)initBackgroundView
{
    [self addSubview:self.backgroundView];
    
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backgroundView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
}


#pragma mark - text label
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        _textLabel.layer.cornerRadius = 3;
        _textLabel.clipsToBounds = YES;
    }
    
    return _textLabel;
}

- (void)initTextLabel
{
    [self addSubview:self.textLabel];
    
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_textLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
}

#pragma mark - cancel icon
- (UIImageView *)cancelIcon
{
    if (!_cancelIcon) {
        _cancelIcon = [[UIImageView alloc] init];
        _cancelIcon.contentMode = UIViewContentModeCenter;
        _cancelIcon.hidden = YES;
        [_cancelIcon setImage:[UIImage buk_imageNamed:@"RecordCancel"]];
    }
    
    return _cancelIcon;
}

- (void)initCancelIcon
{
    [self addSubview:self.cancelIcon];
    
    self.cancelIcon.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cancelIcon]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelIcon)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_cancelIcon]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelIcon)]];
}

#pragma mark - record icon
- (UIImageView *)recordIcon
{
    if (!_recordIcon) {
        _recordIcon = [[UIImageView alloc] init];
        _recordIcon.contentMode = UIViewContentModeRight;
        [_recordIcon setImage:[UIImage buk_imageNamed:@"RecordingBkg"]];
    }
    
    return _recordIcon;
}

- (void)initRecordIcon
{
    [self addSubview:self.recordIcon];
    
    self.recordIcon.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_recordIcon]-25-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_recordIcon)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.recordIcon attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.recordIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0]];
}

#pragma mark - voice icon
- (UIImageView *)voiceIcon
{
    if (!_voiceIcon) {
        _voiceIcon = [[UIImageView alloc] init];
        _voiceIcon.contentMode = UIViewContentModeLeft;
    }
    
    return _voiceIcon;
}

- (void)initVoiceIcon
{
    [self addSubview:self.voiceIcon];
    
    [self setVolumnRate:0];
    
    self.voiceIcon.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_voiceIcon]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_voiceIcon)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceIcon attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.35 constant:0]];
}

- (void)setVolumnRate:(CGFloat)volumnRate
{
    if (volumnRate < 0) {
        volumnRate = 0;
    }
    
    if (volumnRate> 1.0) {
        volumnRate = 1.0;
    }
    NSInteger volumnLevel = round(7*volumnRate) + 1;
    
    [self.voiceIcon setImage:[UIImage buk_imageNamed:[NSString stringWithFormat:@"RecordingSignal00%1ld", (long)volumnLevel]]];
    
}

@end
