//
//  BXMessagesInputStickerDefaultEmojiView.m
//  Pods
//
//  Created by Xiang Li on 10/28/15.
//
//

#import "BXMessagesInputStickerDefaultEmojiView.h"
#import "BXCollectionViewPageableFlowLayout.h"
#import "BXMessagesInputEmojiCell.h"
#import "NSBundle+MessagesUIKit.h"

@interface BXMessagesInputStickerDefaultEmojiView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *emojiArray;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation BXMessagesInputStickerDefaultEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1.000];
        [self loadEmojis];
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
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.collectionView registerClass:[BXMessagesInputEmojiCell class]
            forCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputEmojiCell class])];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        BXCollectionViewPageableFlowLayout *layout = [[BXCollectionViewPageableFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
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
    }
    
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.emojiArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXMessagesInputEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputEmojiCell class])
                                                                               forIndexPath:indexPath];
    
    cell.emojiLabel.text = [self.emojiArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputStickerDefaultEmojiView:selectedEmoji:)]) {
        [self.delegate bxMessagesInputStickerDefaultEmojiView:self selectedEmoji:[self.emojiArray objectAtIndex:indexPath.row]];
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

#pragma mark - load emojis
- (void)loadEmojis
{
    self.emojiArray = [NSArray arrayWithContentsOfFile:[[NSBundle buk_bundle] pathForResource:@"emoji" ofType:@"plist"]];
}

#pragma mark -
- (void)dealloc
{
    [self removePageControlKVOObservers];
}

@end
