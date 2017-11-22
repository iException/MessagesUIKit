//
//  BXMessagesInputToolbar.m
//  Baixing
//
//  Created by hyice on 15/3/17.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputToolbar.h"
#import "UIView+BXMessagesKit.h"
#import "NSMutableArray+SafeOperations.h"

@interface BXMessagesInputToolbar()

@property (strong, nonatomic) NSMutableArray *toolbarItems;

@property (weak, nonatomic) UIView *flexibleWidthItem;
@property (weak, nonatomic) UIView<BXMessagesInputToolbarItem> *maxHeightItem;

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation BXMessagesInputToolbar

@dynamic topBorderColor;
@dynamic bottomBorderColor;

- (UIColor *)topBorderColor
{
    return self.topLine.backgroundColor;
}

- (void)setTopBorderColor:(UIColor *)topBorderColor
{
    self.topLine.backgroundColor = topBorderColor;
}

- (UIColor *)bottomBorderColor
{
    return self.bottomLine.backgroundColor;
}

- (void)setBottomBorderColor:(UIColor *)bottomBorderColor
{
    self.bottomLine.backgroundColor = bottomBorderColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.toolbarItems = [[NSMutableArray alloc] init];
        
        [self updateSelfHeightConstraint];
        
        [self initBorderLines];
    }
    
    return self;
}

- (void)addToolbarItem:(UIView<BXMessagesInputToolbarItem> *)item
{
    [self insertToolbarItem:item index:self.toolbarItems.count];
}

- (void)replaceToolbarItem:(UIView<BXMessagesInputToolbarItem> *)oldItem
                  withItem:(UIView<BXMessagesInputToolbarItem> *)newItem
{
    if (oldItem == nil) {
        return;
    }
    
    if (newItem == nil) {
        return;
    }
    
    NSUInteger indexOfItem = [self.toolbarItems indexOfObject:oldItem];
    
    if (indexOfItem == NSNotFound) {
        return;
    }
    
    UIView *leftView = nil;
    UIView *rightView = nil;
    if (indexOfItem > 0) {
        leftView = [self.toolbarItems objectAtIndex:indexOfItem - 1];
    }
    
    if (indexOfItem + 1 < self.toolbarItems.count) {
        rightView = [self.toolbarItems objectAtIndex:indexOfItem + 1];
    }

    CGRect frame = oldItem.frame;
    if (!newItem.flexibleWidth) {
        frame.size.width = newItem.width;
    }
    
    if (!newItem.flexibleHeight) {
        frame.size.height = newItem.height;
    }
    
    newItem.frame = frame;
    [self.toolbarItems replaceObjectAtIndex:indexOfItem withObject:newItem];
    
    if (oldItem == self.flexibleWidthItem) {
        self.flexibleWidthItem = nil;
    }
    [self removeKVOObserverForItem:oldItem];
    [oldItem removeFromSuperview];
    
    [self addSubview:newItem];
    [self addConstraintForItem:newItem leftView:leftView rightView:rightView];
}

- (void)insertToolbarItem:(UIView<BXMessagesInputToolbarItem> *)item 
                    index:(NSInteger)index
{
    if (index < 0 || index > self.toolbarItems.count) {
        return;
    }
    
    if (!item) {
        return;
    }
    
    if ([self.toolbarItems indexOfObject:item] != NSNotFound) {
        return;
    }
    
    UIView<BXMessagesInputToolbarItem> *leftItem = [self.toolbarItems bx_safeObjectAtIndex:index - 1];
    UIView<BXMessagesInputToolbarItem> *rightItem = [self.toolbarItems bx_safeObjectAtIndex:index];
    [self.toolbarItems bx_addSafeObject:item atIndex:index];
    [self addSubview:item];
    
    if (leftItem && rightItem) {
        [self removeRightConstraintForItem:leftItem];
        [self removeLeftConstraintForItem:rightItem];
    } else if (leftItem && !rightItem) {
        [self removeRightConstraintForItem:leftItem];
    } else if (!leftItem && rightItem) {
        [self removeLeftConstraintForItem:rightItem];
    }
    
    [self addConstraintForItem:item leftView:leftItem rightView:rightItem];
}

- (void)removeToolbarItem:(UIView<BXMessagesInputToolbarItem> *)item
{
    if (!item) {
        return;
    }
    NSInteger index = [self.toolbarItems indexOfObject:item]; 
    [self removeToolbarItemAtIndex:index];
}

- (void)removeToolbarItemAtIndex:(NSInteger)index
{    
    if (index == NSNotFound || index < 0 || index >= self.toolbarItems.count) {
        return;
    }
    UIView<BXMessagesInputToolbarItem> *item = [self.toolbarItems bx_safeObjectAtIndex:index];
    if (!item) {
        return;
    }
    
    UIView<BXMessagesInputToolbarItem> *leftItem = [self.toolbarItems bx_safeObjectAtIndex:index - 1];
    UIView<BXMessagesInputToolbarItem> *rightItem = [self.toolbarItems bx_safeObjectAtIndex:index + 1];
    [self.toolbarItems removeObject:item];
    [item removeFromSuperview];
    if (leftItem && rightItem) {
        [self resetHorizontalConstraintsForItem:leftItem];
        [self resetHorizontalConstraintsForItem:rightItem];
    } else if (leftItem && !rightItem) {
        [self resetHorizontalConstraintsForItem:leftItem];
    } else if (!leftItem && rightItem) {
        [self resetHorizontalConstraintsForItem:rightItem];
    }
}

#pragma mark - kvo
- (void)addKVOObserverForItem:(UIView<BXMessagesInputToolbarItem> *)item
{
    @try {
        if (!item.flexibleHeight) {
            [item addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(height))
                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                      context:nil];
        }
        
        if (!item.flexibleWidth) {
            [item addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(width))
                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                      context:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"BXMessagesKit add KVO Observer Exception:%@", exception);
    }
}

- (void)removeKVOObserverForItem:(UIView<BXMessagesInputToolbarItem> *)item
{
    @try {
        if (!item.flexibleHeight) {
            [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(height))];
        }
        
        if (!item.flexibleWidth) {
            [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(width))];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"BXMessagesKit remove KVO Observer Exception:%@", exception);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(UIView<BXMessagesInputToolbarItem> *)item
                        change:(NSDictionary *)change
                       context:(void *)context
{
    CGFloat oldValue = [[change objectForKey:NSKeyValueChangeOldKey] floatValue];
    CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    if (oldValue == newValue) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(width))]) {
                [self bxMessagesKit_performOneItemConstraintAction:^(NSLayoutConstraint *constraint) {
                    constraint.constant = item.width;
                } onItem:item forAttribute:NSLayoutAttributeWidth];
            }else if([keyPath isEqualToString:NSStringFromSelector(@selector(height))]) {
                [self bxMessagesKit_performOneItemConstraintAction:^(NSLayoutConstraint *constraint) {
                    constraint.constant = item.height;
                } onItem:item forAttribute:NSLayoutAttributeHeight];
                [self updateSelfHeightConstraint];
            }
            [self.bxMessagesKit_superSuperView layoutIfNeeded];
        }];
    });
}

#pragma mark - constraints
- (void)removeRightConstraintForItem:(UIView *)item
{
    __block NSLayoutConstraint *rightConstraint = nil;
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == item && constraint.firstAttribute == NSLayoutAttributeRight)
            || (constraint.secondItem == item && constraint.secondAttribute == NSLayoutAttributeRight)) {
            rightConstraint = constraint;
            *stop = YES;
        }
    }];
    
    if (rightConstraint) {
        [self removeConstraint:rightConstraint];
    }
}

- (void)removeLeftConstraintForItem:(UIView *)item
{
    __block NSLayoutConstraint *leftConstraint = nil;
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == item && constraint.firstAttribute == NSLayoutAttributeLeft)
            || (constraint.secondItem == item && constraint.secondAttribute == NSLayoutAttributeLeft)) {
            leftConstraint = constraint;
            *stop = YES;
        }
    }];
    
    if (leftConstraint) {
        [self removeConstraint:leftConstraint];
    }
}

- (void)resetHorizontalConstraintsForItem:(UIView<BXMessagesInputToolbarItem> *)item
{
    NSInteger index = [self.toolbarItems indexOfObject:item]; 
    if (index == NSNotFound) {
        return;
    }
    if (item.flexibleWidth) {
        self.flexibleWidthItem = nil;
    }
    [self removeRightConstraintForItem:item];
    [self removeLeftConstraintForItem:item];
    UIView<BXMessagesInputToolbarItem> *leftItem = [self.toolbarItems bx_safeObjectAtIndex:index - 1];
    UIView<BXMessagesInputToolbarItem> *rightItem = [self.toolbarItems bx_safeObjectAtIndex:index + 1];
    [self removeRightConstraintForItem:leftItem];
    [self removeLeftConstraintForItem:rightItem];
    [self addConstraintForItem:item leftView:leftItem rightView:rightItem];
}

- (void)addConstraintForItem:(UIView<BXMessagesInputToolbarItem> *)item
                    leftView:(UIView *)leftView
                   rightView:(UIView *)rightView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftView?leftView:self attribute:leftView?NSLayoutAttributeRight:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    if (item.flexibleWidth) {
        NSAssert(self.flexibleWidthItem == nil, @"BXMessagesKit Alert: Can't have more than one flexible width items in toolbar!");
        
        self.flexibleWidthItem = item;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightView?rightView:self attribute:rightView?NSLayoutAttributeLeft:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    }else {
        [self bxMessagesKit_performOneItemConstraintAction:^(NSLayoutConstraint *constraint) {
            [item removeConstraint:constraint];
        } onItem:item forAttribute:NSLayoutAttributeWidth];
        
        [item addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:item.width]];
        if (rightView) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        }
    }
    
    if (item.flexibleHeight) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    }else {
        [self bxMessagesKit_performOneItemConstraintAction:^(NSLayoutConstraint *constraint) {
            [item removeConstraint:constraint];
        } onItem:item forAttribute:NSLayoutAttributeHeight];

        [item addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:item.height]];
    }
    
    if (self.flexibleWidthItem && [self.toolbarItems lastObject] == item) {
        [self removeRightConstraintForItem:self];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    }
    
    [self updateSelfHeightConstraint];
    
    [self addKVOObserverForItem:item];
}

- (void)updateSelfHeightConstraint
{
    __block CGFloat maxHeight = 0;
    self.maxHeightItem = nil;
    
    [self.toolbarItems enumerateObjectsUsingBlock:^(UIView<BXMessagesInputToolbarItem> *item, NSUInteger idx, BOOL *stop) {
        if (!item.flexibleHeight && maxHeight < item.height) {
            maxHeight = item.height;
            self.maxHeightItem = item;
        }
    }];
    
    if (!self.heightConstraint) {
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maxHeight];
        [self addConstraint:self.heightConstraint];
    }


    self.heightConstraint.constant = self.maxHeightItem? self.maxHeightItem.height : 44;
}

#pragma mark - border line
- (void)initBorderLines
{
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithRed:0xd0/255.0 green:0xd0/255.0 blue:0xd0/255.0 alpha:1.0];
    [self addSubview:topLine];
    
    topLine.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:topLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLine)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:topLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];

    self.topLine = topLine;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithRed:0xd0/255.0 green:0xd0/255.0 blue:0xd0/255.0 alpha:1.0];
    [self addSubview:bottomLine];
    
    bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bottomLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomLine)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bottomLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];

    self.bottomLine = bottomLine;
}

#pragma mark -
- (void)dealloc
{
    [self.toolbarItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeKVOObserverForItem:obj];
    }];
}
@end
