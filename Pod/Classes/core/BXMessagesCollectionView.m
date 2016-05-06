//
//  BXMessagesCollectionView.m
//  Baixing
//
//  Created by hyice on 15/3/24.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesCollectionView.h"

@interface BXMessagesCollectionView()

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

@property (assign, nonatomic) BOOL isObserving;

@end

@implementation BXMessagesCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initLoadingIndicator];
    }
    
    return self;
}

- (void)dealloc
{
    if (self.isObserving) {
        [self removeObserver:self forKeyPath:@"contentSize"];
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfItems = [self numberOfItemsInSection:0];
    if (numberOfItems < 1) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:numberOfItems-1 inSection:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToItemAtIndexPath:indexPath
                     atScrollPosition:UICollectionViewScrollPositionBottom
                             animated:animated];
    });
}

- (void)setShowIndicatorAtBottom:(BOOL)showIndicatorAtBottom
{
    _showIndicatorAtBottom = showIndicatorAtBottom;
    if (!showIndicatorAtBottom) {
        self.loadingIndicator.frame = CGRectMake(0, -20, CGRectGetWidth(self.bounds), 20);
        if (self.isObserving) {
            [self removeObserver:self forKeyPath:@"contentSize"];
            self.isObserving = NO;
        }
    } else {
        if (!self.isObserving) {
            [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            self.isObserving = YES;
        }
        self.loadingIndicator.frame = CGRectMake(0, self.contentSize.height, self.bounds.size.width, 20);
    }
}

#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.loadingIndicator.frame = CGRectMake(0, self.contentSize.height, CGRectGetWidth(self.bounds), 20);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - loading indicator
- (void)initLoadingIndicator
{
    [self addSubview:self.loadingIndicator];
    
    // Can't use auto layout here! If system version is below 8.0,
    // will have 'Auto Layout still required after executing -layoutSubviews' error.
    self.loadingIndicator.frame = CGRectMake(0, -20, CGRectGetWidth(self.bounds), 20);
    self.loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (UIActivityIndicatorView *)loadingIndicator
{
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingIndicator.hidesWhenStopped = YES;
    }
    
    return _loadingIndicator;
}

@end
