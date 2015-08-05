//
//  BXMessagesInputMoreChoicesView.m
//  Baixing
//
//  Created by hyice on 15/3/19.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputMoreChoicesView.h"
#import "BXMessagesInputMoreChoiceCell.h"
#import "BXCollectionViewPageableFlowLayout.h"
#import "BXMessagesInputMoreChoiceItem.h"
#import "NSBundle+MessagesUIKit.h"

@interface BXMessagesInputMoreChoicesView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation BXMessagesInputMoreChoicesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.flexibleWidth = YES;
        self.flexibleHeight = NO;
        self.height = 215;
        
        [self initCollectionView];
        [self initPageControl];
    }
    
    return self;
}

#pragma mark - collection view
- (void)initCollectionView
{
    [self addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"collectionView":self.collectionView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"collectionView":self.collectionView}]];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        BXCollectionViewPageableFlowLayout *collectionLayout = [[BXCollectionViewPageableFlowLayout alloc] init];
        collectionLayout.itemSize = CGSizeMake(60, 80);
        collectionLayout.pageContentInsets = UIEdgeInsetsMake(15, 30, 30, 30);
        collectionLayout.itemMinimalHorizontalPadding = 25;
        collectionLayout.itemMinimalVerticalPadding = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf6/255.0 alpha:1.0];
    }
    
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInMoreChoicesView:)]) {
        return [self.delegate numberOfItemsInMoreChoicesView:self];
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreChoicesView:choiceItemForIndex:)]) {
        BXMessagesInputMoreChoiceItem *item = [self.delegate moreChoicesView:self choiceItemForIndex:indexPath.row];
        if (item.cellNibName && item.cellNibName.length != 0) {
            [collectionView registerNib:[UINib nibWithNibName:item.cellNibName bundle:[NSBundle buk_bundle]] forCellWithReuseIdentifier:item.cellNibName];
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.cellNibName forIndexPath:indexPath];
        }else if (item.cellClassName && item.cellClassName.length != 0) {
            [collectionView registerClass:NSClassFromString(item.cellClassName) forCellWithReuseIdentifier:item.cellClassName];
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.cellClassName forIndexPath:indexPath];
        }
        
        if (item.configureBlock) {
            item.configureBlock(cell);
        }
    }
    
    if (!cell) {
        [self.collectionView registerClass:[UICollectionViewCell class]
                forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreChoicesView:choiceItemForIndex:)]) {
        BXMessagesInputMoreChoiceItem *item = [self.delegate moreChoicesView:self choiceItemForIndex:indexPath.row];
        
        if (item && item.selectBlock) {
            item.selectBlock();
        }
    }
}

#pragma mark - init page control
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    }
    
    return _pageControl;
}

- (void)initPageControl
{
    [self addSubview:self.pageControl];
    
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_pageControl]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
    [self addPageControlKVOObservers];
}

- (void)addPageControlKVOObservers
{
    [self.collectionView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionNew context:nil];
    [self.collectionView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removePageControlKVOObservers
{
    @try {
        [self.collectionView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
        [self.collectionView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
    @catch (NSException *exception) {
        NSLog(@"BXMessagesKit: remove page control kvo error!");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        NSInteger numberOfPages = self.collectionView.contentSize.width / self.collectionView.bounds.size.width;
        self.pageControl.numberOfPages = numberOfPages;
        self.pageControl.currentPage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
        
        self.pageControl.hidden = numberOfPages<= 1;
    }else if([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        self.pageControl.currentPage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    }
}

#pragma mark -
- (void)dealloc
{
    [self removePageControlKVOObservers];
}

@end
