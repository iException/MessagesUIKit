//
//  BXMessagesMultiInputView.m
//  Baixing
//
//  Created by hyice on 15/3/16.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesMultiInputView.h"
#import "BXMessagesInputToolbar.h"
#import "BXMessagesInputAccessoryView.h"
#import "UIView+BXMessagesKit.h"

@interface BXMessagesMultiInputView()

@property (weak, nonatomic) NSLayoutConstraint *inputToolbarBottomConstraint;
@property (weak, nonatomic) NSLayoutConstraint *accessoryViewBottomConstraint;

@end

@implementation BXMessagesMultiInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initInputToolbar];
        [self initAccessoryView];
        [self addKeyboardNotificationCenterObservers];
        
        [self updateConstraintsToShowOrHideAccessoryView:NO];
        
        [self setupDefaultAccessoryItem];
    }
    
    return self;
}

#pragma mark - input toolbar
- (BXMessagesInputToolbar *)inputToolbar
{
    if (!_inputToolbar) {
        _inputToolbar = [[BXMessagesInputToolbar alloc] init];
        _inputToolbar.backgroundColor = [UIColor colorWithRed:0xf9/255.0 green:0xf9/255.0 blue:0xf9/255.0 alpha:1.0];
    }
    
    return _inputToolbar;
}

- (void)initInputToolbar
{
    [self addSubview:self.inputToolbar];
    
    self.inputToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.inputToolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.inputToolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.inputToolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self setupInputToolbarItems];
}

- (void)setupInputToolbarItems
{
}

#pragma mark - accessory view
- (BXMessagesInputAccessoryView *)accessoryView
{
    if (!_accessoryView) {
        _accessoryView = [[BXMessagesInputAccessoryView alloc] init];
        _accessoryView.backgroundColor = [UIColor whiteColor];
    }
    
    return _accessoryView;
}

- (void)initAccessoryView
{
    [self addSubview:self.accessoryView];
    
    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_accessoryView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_accessoryView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.accessoryView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.inputToolbar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)showAccessoryView:(BOOL)show animated:(BOOL)animated
{
    if (show == self.isShowingAccessoryView) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                [self updateConstraintsToShowOrHideAccessoryView:show];
                
                [self.bxMessagesKit_superSuperView layoutIfNeeded];
            }];
        }else {
            [self updateConstraintsToShowOrHideAccessoryView:show];
        }
    });
    
    self.isShowingAccessoryView = show;
}

- (void)setupDefaultAccessoryItem
{
}

#pragma mark - update constraints to show hide accessory view
- (void)updateConstraintsToShowOrHideAccessoryView:(BOOL)show
{
    if (self.inputToolbarBottomConstraint) {
        [self removeConstraint:self.inputToolbarBottomConstraint];
        self.inputToolbarBottomConstraint = nil;
    }
    
    if (self.accessoryViewBottomConstraint) {
        [self removeConstraint:self.accessoryViewBottomConstraint];
        self.accessoryViewBottomConstraint = nil;
    }
    
    if (show) {

        if (!self.accessoryViewBottomConstraint) {
            self.accessoryViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.accessoryView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            [self addConstraint:self.accessoryViewBottomConstraint];
        }
        
    }else {
        if (!self.inputToolbarBottomConstraint) {
            self.inputToolbarBottomConstraint = [NSLayoutConstraint constraintWithItem:self.inputToolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            [self addConstraint:self.inputToolbarBottomConstraint];
        }
    }
}

#pragma mark - handle keyboard
- (void)addKeyboardNotificationCenterObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotificationCenterObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            if (self.isShowingAccessoryView) {
                [self updateConstraintsToShowOrHideAccessoryView:NO];
            }
            [self setNeedsLayout];
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            if (self.isShowingAccessoryView) {
                [self updateConstraintsToShowOrHideAccessoryView:YES];
            }
            [self setNeedsLayout];
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)dealloc
{
    [self removeKeyboardNotificationCenterObservers];
}

@end
