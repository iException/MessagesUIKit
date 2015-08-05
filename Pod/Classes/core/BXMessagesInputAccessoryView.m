//
//  BXMessagesInputAccessoryView.m
//  Baixing
//
//  Created by hyice on 15/3/18.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputAccessoryView.h"
#import "UIView+BXMessagesKit.h"

@interface BXMessagesInputAccessoryView()

@property (strong, nonatomic) NSMutableArray *displayingItems;

@property (strong, nonatomic) UIView<BXMessagesInputAccessoryItem> *maxHeightItem;

@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation BXMessagesInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.displayingItems = [[NSMutableArray alloc] init];
        [self updateSelfHeightConstraint];
    }
    
    return self;
}

- (void)displayAccessoryItem:(UIView<BXMessagesInputAccessoryItem> *)item
                    animated:(BOOL)animated
{
    if (!item) {
        return;
    }
    
    if ([self.displayingItems indexOfObject:item] != NSNotFound) {
        return;
    }
    
    [self.displayingItems addObject:item];
    [self addSubview:item];
    item.frame = self.frame;
    
    [self addConstraintForItem:item];
    
    if (animated) {
        __block NSLayoutConstraint *itemTopConstraint;
        CGRect frame = item.frame;
        frame.origin.y = frame.size.height;
        item.frame = frame;
        [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == item
                 && constraint.firstAttribute == NSLayoutAttributeTop
                 && constraint.secondItem == self
                 && constraint.secondAttribute == NSLayoutAttributeTop)
                ||
                (constraint.firstItem == self
                 && constraint.firstAttribute == NSLayoutAttributeTop
                 && constraint.secondItem == item
                 && constraint.secondAttribute == NSLayoutAttributeTop)) {
                    
                    itemTopConstraint = constraint;
                }
        }];
        
        if (itemTopConstraint) {
            itemTopConstraint.constant = self.frame.size.height;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25f animations:^{
                    itemTopConstraint.constant = 0;
                    [self.bxMessagesKit_superSuperView layoutIfNeeded];
                } completion:^(BOOL finished) {
                }];
            });
        }
    }
}

- (void)removeAccessoryItem:(UIView<BXMessagesInputAccessoryItem> *)item animated:(BOOL)animated
{
    if (!item) {
        return;
    }
    
    NSUInteger indexOfItem = [self.displayingItems indexOfObject:item];
    
    if (indexOfItem == NSNotFound) {
        return;
    }
    
    [self.displayingItems removeObject:item];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
                    if ((constraint.firstItem == item
                         && constraint.firstAttribute == NSLayoutAttributeTop
                         && constraint.secondItem == self
                         && constraint.secondAttribute == NSLayoutAttributeTop)
                        ||
                        (constraint.firstItem == self
                         && constraint.firstAttribute == NSLayoutAttributeTop
                         && constraint.secondItem == item
                         && constraint.secondAttribute == NSLayoutAttributeTop)) {
                            
                            constraint.constant = item.frame.size.height;
                        }
                }];
                [self.bxMessagesKit_superSuperView layoutIfNeeded];
            } completion:^(BOOL finished) {
                [item removeFromSuperview];
            }];
        }else {
            [item removeFromSuperview];
        }
    });

    [self updateSelfHeightConstraint];
}

- (void)addConstraintForItem:(UIView<BXMessagesInputAccessoryItem> *)item
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    if (item.flexibleWidth) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[item]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
    }else {
        [self bxMessagesKit_performOneItemConstraintAction:^(NSLayoutConstraint *constraint) {
            [item removeConstraint:constraint];
        } onItem:item forAttribute:NSLayoutAttributeWidth];
        
        [item addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:item.width]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    
    if (item.flexibleHeight) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[item]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
    }else {
        [self bxMessagesKit_performOneItemConstraintAction:^(NSLayoutConstraint *constraint) {
            [item removeConstraint:constraint];
        } onItem:item forAttribute:NSLayoutAttributeHeight];
        
        [item addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:item.height]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    }
    
    [self updateSelfHeightConstraint];
}

- (void)updateSelfHeightConstraint
{
    __block CGFloat maxHeight = 0;
    self.maxHeightItem = nil;
    
    [self.displayingItems enumerateObjectsUsingBlock:^(UIView<BXMessagesInputAccessoryItem> *item, NSUInteger idx, BOOL *stop) {
        if (!item.flexibleHeight && maxHeight < item.height) {
            maxHeight = item.height;
            self.maxHeightItem = item;
        }
    }];
    
    if (!self.heightConstraint) {
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        [self addConstraint:self.heightConstraint];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.heightConstraint.constant = self.maxHeightItem? self.maxHeightItem.height : 200;
            [self.bxMessagesKit_superSuperView layoutIfNeeded];
        }];

    });
}
@end
