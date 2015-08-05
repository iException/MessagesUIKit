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

@end

@implementation BXMessagesCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0xeb/255.0 green:0xeb/255.0 blue:0xeb/255.0 alpha:1.0];
        [self initLoadingIndicator];
    }
    
    return self;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfItems = [self numberOfItemsInSection:0];
    if (numberOfItems < 1) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfItems-1 inSection:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToItemAtIndexPath:indexPath
                     atScrollPosition:UICollectionViewScrollPositionBottom
                             animated:animated];
    });
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
