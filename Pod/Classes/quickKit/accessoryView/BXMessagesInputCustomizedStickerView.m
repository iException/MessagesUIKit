//
//  BXMessagesInputCustomizedStickerView.m
//  Pods
//
//  Created by Xiang Li on 10/29/15.
//
//

#import "BXMessagesInputCustomizedStickerView.h"
#import "BXMessagesInputStickerCell.h"
#import "BXCollectionViewPageableFlowLayout.h"

@interface BXMessagesInputCustomizedStickerView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *stickerArray;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;

/**
 *  this is a helper property to get long press gesture on collection view done
 */
@property (strong, nonatomic) NSIndexPath *previousIndexPath;

@end

@implementation BXMessagesInputCustomizedStickerView

- (instancetype)initWithDelegate:(id)delegate index:(NSUInteger)indexValue
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.index = indexValue;
        [self initialize];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//
//    if (self) {
//        [self initialize];
//        //        self.flexibleWidth = YES;
//        //        self.flexibleHeight = NO;
//        //        self.height = 215;
//    }
//
//    return self;
//}

- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self initCollectionView];
    [self initPageControl];
}

#pragma mark - collection view
- (void)initCollectionView
{
    [self addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.collectionView registerClass:[BXMessagesInputStickerCell class]
            forCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputStickerCell class])];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        BXCollectionViewPageableFlowLayout *layout = [[BXCollectionViewPageableFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 65);
        layout.itemMinimalVerticalPadding = 0;
        layout.itemMinimalHorizontalPadding = 0;
        layout.pageContentInsets = UIEdgeInsetsMake(15, 20, 30, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        // attach long press gesture to collectionView
        UILongPressGestureRecognizer* lpgr =
        [[UILongPressGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;  // seconds
        //        lpgr.delegate = self;
        lpgr.delaysTouchesBegan = YES;
        [self.collectionView addGestureRecognizer:lpgr];
    }
    
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfStickersOfPackAtIndex:)]) {
        return [self.delegate numberOfStickersOfPackAtIndex:self.index];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXMessagesInputStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputStickerCell class])
                                                                                 forIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageOfStickersWithPackIndex:stickerIndex:)]) {
        cell.stickerImageView.image = [self.delegate imageOfStickersWithPackIndex:self.index stickerIndex:indexPath.row];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(nameOfStickersWithPackIndex:stickerIndex:)]) {
        cell.nameLabel.text = [self.delegate nameOfStickersWithPackIndex:self.index stickerIndex:indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputCustomizedStickerView:packIndex:stickerIndex:)]) {
        [self.delegate bxMessagesInputCustomizedStickerView:self packIndex:self.index stickerIndex:indexPath.row];
    }
}

#pragma mark - collection view gesture
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    UICollectionViewCell* cell;
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath == nil){
        // if moving out of collection view , unhighlight previous cell
        UICollectionViewCell *previousCell = [self.collectionView cellForItemAtIndexPath:self.previousIndexPath];
        [self unhighlightCell:previousCell];
        return;
    } else {
        cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self highlightCell:cell];
            self.previousIndexPath = indexPath;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (![indexPath isEqual:self.previousIndexPath]) {
                // unhighlight previous cell
                UICollectionViewCell *previousCell = [self.collectionView cellForItemAtIndexPath:self.previousIndexPath];
                if (previousCell) {
                    [self unhighlightCell:previousCell];
                }
                self.previousIndexPath = indexPath;
                
                // highlight this cell
                [self highlightCell:cell];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self unhighlightCell:cell];
            break;
        }
        default: {
            return;
        }
    }
}

- (void)highlightCell:(UICollectionViewCell *)cell
{
    if (!cell) {
        return;
    }
    
    if ([cell isKindOfClass:[BXMessagesInputStickerCell class]]) {
        BXMessagesInputStickerCell *stickerCell = (BXMessagesInputStickerCell *)cell;
        [stickerCell highlight];
    }
}

- (void)unhighlightCell:(UICollectionViewCell *)cell
{
    if (!cell) {
        return;
    }
    
    if ([cell isKindOfClass:[BXMessagesInputStickerCell class]]) {
        BXMessagesInputStickerCell *stickerCell = (BXMessagesInputStickerCell *)cell;
        [stickerCell unhighlight];
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
    
    // add tap gesture
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

- (void)changePage:(id)sender {
    UIPageControl *pager = sender;
    CGRect frame = self.collectionView.frame;
    frame.origin.x = frame.size.width * pager.currentPage;
    frame.origin.y = 0;
    [self.collectionView scrollRectToVisible:frame animated:YES];
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
        self.pageControl.numberOfPages = self.collectionView.contentSize.width / self.collectionView.bounds.size.width;
        self.pageControl.currentPage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
        
        self.pageControl.hidden = self.pageControl.numberOfPages<= 1;
        
    }else if([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        self.pageControl.currentPage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    }
}

#pragma mark - load stickers
- (void)loadStickers
{
}

#pragma mark -
- (void)dealloc
{
    [self removePageControlKVOObservers];
}

@end
