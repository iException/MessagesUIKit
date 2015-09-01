//
//  BXMessagesInputToolbarAudioButton.m
//  Baixing
//
//  Created by hyice on 15/3/19.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputToolbarAudioButton.h"
#import "UIView+BXMessagesKit.h"
#import "BXMessagesInputRecordView.h"
#import "NSBundle+MessagesUIKit.h"
#import "UIImage+MessagesUIKit.h"

typedef NS_ENUM(NSInteger, BXMessagesInputToolbarAudioButtonState) {
    BXMessagesInputToolbarAudioButtonUnknownState = 0,
    BXMessagesInputToolbarAudioButtonWaitForRecordState,
    BXMessagesInputToolbarAudioButtonRecordingState,
    BXMessagesInputToolbarAudioButtonWillCancelState
};

@interface BXMessagesInputToolbarAudioButton()

@property (assign, nonatomic) BXMessagesInputToolbarAudioButtonState recordState;
@property (strong, nonatomic) BXMessagesInputRecordView *recordView;
@property (strong, nonatomic) UIImageView *backgroundView;

@end

@implementation BXMessagesInputToolbarAudioButton

@synthesize recordView = _recordView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addBackgroundView];
        
        [self setupButtonCofiguration];
        
        self.recordState = BXMessagesInputToolbarAudioButtonWaitForRecordState;
    }
    
    return self;
}

- (void)setupButtonCofiguration
{
    self.flexibleWidth = YES;
    self.flexibleHeight = NO;
    self.height = 44;
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self setTitleColor:[UIColor colorWithRed:0x67/255.0 green:0x67/255.0 blue:0x67/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    self.recordState = BXMessagesInputToolbarAudioButtonWaitForRecordState;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesAudioButtonStartRecord:)]) {
        [self.delegate bxMessagesAudioButtonStartRecord:self];
    }
    
    self.recordState = BXMessagesInputToolbarAudioButtonRecordingState;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if (location.x < 0 || location.y < 0 || location.x > self.bounds.size.width || location.y > self.bounds.size.height) {
        self.recordState = BXMessagesInputToolbarAudioButtonWillCancelState;
    }else {
        self.recordState = BXMessagesInputToolbarAudioButtonRecordingState;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self audioRecordEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self audioRecordEnded];
}

- (void)audioRecordEnded
{
    if (self.recordState == BXMessagesInputToolbarAudioButtonWillCancelState) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesAudioButtonCancelRecord:)]) {
            [self.delegate bxMessagesAudioButtonCancelRecord:self];
        }
    }else if (self.recordState == BXMessagesInputToolbarAudioButtonRecordingState)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesAudioButtonFinishRecord:)]) {
            [self.delegate bxMessagesAudioButtonFinishRecord:self];
        }
    }
    
    self.recordState = BXMessagesInputToolbarAudioButtonWaitForRecordState;
}

#pragma mark - update volumn rate
- (void)updateVolumnRate:(CGFloat)rate
{
    self.recordView.volumnRate = rate;
}

#pragma mark - change record state
- (void)setRecordState:(BXMessagesInputToolbarAudioButtonState)recordState
{
    if (_recordState == recordState) {
        return;
    }
    
    NSString *title;
    UIColor *color;
    UIImage *image;
    switch (recordState) {
        case BXMessagesInputToolbarAudioButtonRecordingState:
            title = @"松开 结束";
            color = [UIColor colorWithRed:0x6f/255.0 green:0x73/255.0 blue:0x78/255.0 alpha:1.0];
            image = [UIImage buk_imageNamed:@"buk-toolbar-graybg"];
            if (self.superview) {
                self.recordView.type = BXMessagesInputRecordViewRecordType;
            }
            break;
            
        case BXMessagesInputToolbarAudioButtonWillCancelState:
            title = @"松开 结束";
            color = [UIColor colorWithRed:0x6f/255.0 green:0x73/255.0 blue:0x78/255.0 alpha:1.0];
            image = [UIImage buk_imageNamed:@"buk-toolbar-graybg"];
            if (self.superview) {
                self.recordView.type = BXMessagesInputRecordViewCacelType;
            }
            break;
            
        case BXMessagesInputToolbarAudioButtonWaitForRecordState:
            // fall through
        default:
            title = @"按住 说话";
            color = [UIColor colorWithRed:0x6f/255.0 green:0x73/255.0 blue:0x78/255.0 alpha:1.0];
            image = [UIImage buk_imageNamed:@"buk-toolbar-whitebg"];
            break;
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    self.backgroundView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2.0 topCapHeight:image.size.height/2.0];
    
    if (self.superview) {
        self.recordView.hidden = (recordState == BXMessagesInputToolbarAudioButtonWaitForRecordState);
    }
    
    _recordState = recordState;
}

#pragma mark - record view
- (void)setRecordView:(BXMessagesInputRecordView *)recordView
{
    if (_recordView == recordView) {
        return;
    }
    
    if (recordView == nil) {
        [_recordView removeFromSuperview];
    }
    
    _recordView = recordView;
}

- (BXMessagesInputRecordView *)recordView
{
    if (!_recordView) {
        _recordView = [[BXMessagesInputRecordView alloc] init];
        _recordView.type = BXMessagesInputRecordViewRecordType;
        _recordView.hidden = YES;
        
        UIView *superSuperView = self.bxMessagesKit_superSuperView;
        [superSuperView addSubview:_recordView];
        
        _recordView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [superSuperView addConstraint:[NSLayoutConstraint constraintWithItem:_recordView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superSuperView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [superSuperView addConstraint:[NSLayoutConstraint constraintWithItem:_recordView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superSuperView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [superSuperView addConstraint:[NSLayoutConstraint constraintWithItem:_recordView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150]];
        [superSuperView addConstraint:[NSLayoutConstraint constraintWithItem:_recordView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150]];
        
    }
    
    return _recordView;
}

#pragma mark - background view
- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.clipsToBounds = YES;
    }
    
    return _backgroundView;
}

- (void)addBackgroundView
{
    [self addSubview:self.backgroundView];

    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_backgroundView]-6-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
}

#pragma mark -

- (void)dealloc
{
    [self.recordView removeFromSuperview];
}
@end
