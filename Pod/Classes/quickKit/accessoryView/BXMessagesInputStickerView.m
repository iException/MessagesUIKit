//
//  BXMessagesInputStickerView.m
//  Pods
//
//  Created by Xiang Li on 10/27/15.
//
//

#import "BXMessagesInputStickerView.h"
//#import "BXCollectionViewPageableFlowLayout.h"
#import "BXMessagesInputStickersGalleryViewLayout.h"
#import "BXMessagesInputStickersGalleryViewCell.h"
#import "BXMessagesInputStickerDefaultEmojiView.h"

const NSInteger stickersCount = 1;
const CGFloat stickerViewHeight = 215;
const CGFloat toolBarHeight = 40;

@interface BXMessagesInputStickerView() <UICollectionViewDataSource,UICollectionViewDelegate,BXMessagesInputStickerDefaultEmojiViewDelegate>

// main view where emojis and other stickers are presented in order
@property (nonatomic, strong) UIView *stickerMainView;
// to improve performance,each time the user choose a different set of emoji or stickers pack,
// that view is cached in this array
@property (nonatomic, strong) NSMutableArray *cachedMainViewCandidates;

// tool bar where addStickerButton,stickersGallery and sendButton are placed
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *addStickersButton;
@property (nonatomic, strong) UICollectionView *stickersGalleryView;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation BXMessagesInputStickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.flexibleWidth = YES;
        self.flexibleHeight = NO;
        self.height = stickerViewHeight;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initStickerMainView];
        [self initToolBar];
    }
    return self;
}

- (void)initStickerMainView
{
    [self addSubview:self.stickerMainView];

    // arrange stickerMainView
    self.stickerMainView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_stickerMainView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickerMainView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_stickerMainView]-%f-|",toolBarHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickerMainView)]];
    
    // init cachedMainViewCandidates
    self.cachedMainViewCandidates = NSMutableArray.new;
    // add the default emoji view anyway
    BXMessagesInputStickerDefaultEmojiView *emojiView = [[BXMessagesInputStickerDefaultEmojiView alloc] init];
    emojiView.delegate = self;
    [self.cachedMainViewCandidates addObject:emojiView];
}

- (void)initToolBar
{
    [self.toolBar addSubview:self.addStickersButton];
    [self.toolBar addSubview:self.stickersGalleryView];
    [self.toolBar addSubview:self.sendButton];
    [self addSubview:self.toolBar];
    
    // arrange addStickersButton
    self.addStickersButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_addStickersButton]-0-[_stickersGalleryView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addStickersButton,_stickersGalleryView)]];
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_addStickersButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addStickersButton)]];
    
    // arrange stickersGalleryView
    self.stickersGalleryView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_stickersGalleryView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickersGalleryView)]];
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_stickersGalleryView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickersGalleryView)]];
    
    // arrange sendButton

    
    // arrange toolBar
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolBar)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_toolBar]-0-|",stickerViewHeight - toolBarHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolBar)]];
}

#pragma mark - UI Element Initializers
- (UIView *)stickerMainView
{
    if (!_stickerMainView) {
        _stickerMainView = [[UIView alloc] init];
        _stickerMainView.backgroundColor = [UIColor whiteColor];
    }
    return _stickerMainView;
}

- (UIView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
    }
    return _toolBar;
}

- (UIButton *)addStickersButton
{
    if (!_addStickersButton) {
        _addStickersButton = [[UIButton alloc] init];
        [_addStickersButton setTitle:@"+" forState:UIControlStateNormal];
        _addStickersButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _addStickersButton.backgroundColor = [UIColor grayColor];
    }
    return _addStickersButton;
}

- (UICollectionView *)stickersGalleryView
{
    if (!_stickersGalleryView) {
        BXMessagesInputStickersGalleryViewLayout *layout = [[BXMessagesInputStickersGalleryViewLayout alloc] init];
        layout.numberOfItems = stickersCount;
        layout.itemSize = CGSizeMake(45, toolBarHeight);
        
        _stickersGalleryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _stickersGalleryView.backgroundColor = [UIColor clearColor];
        _stickersGalleryView.scrollsToTop = NO;
        _stickersGalleryView.showsHorizontalScrollIndicator = YES;
        _stickersGalleryView.dataSource = self;
        _stickersGalleryView.delegate = self;
        [_stickersGalleryView registerClass:[BXMessagesInputStickersGalleryViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputStickersGalleryViewCell class])];
    }
    return _stickersGalleryView;
}

#pragma mark - UICollectionViewDelegate & DataSource (for stickerGalleryView)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return stickersCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXMessagesInputStickersGalleryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputStickersGalleryViewCell class]) forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[BXMessagesInputStickersGalleryViewCell alloc] init];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // clean up stickerMainView first
    for (UIView *subViews in self.stickerMainView.subviews) {
        [subViews removeFromSuperview];
    }
    
    // show the new pack view
    NSInteger row = indexPath.row;
    if (row >= self.cachedMainViewCandidates.count) {
        return;
    }
    UIView *packView = [self.cachedMainViewCandidates objectAtIndex:row];
    packView.frame = CGRectMake(0, 0, self.stickerMainView.frame.size.width, self.stickerMainView.frame.size.height);
    [self.stickerMainView addSubview:packView];
}

#pragma mark - BXMessagesInputStickerDefaultEmojiView delegate
- (void)bxMessagesInputStickerDefaultEmojiView:(BXMessagesInputStickerDefaultEmojiView *)emojiView selectedEmoji:(NSString *)emoji
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputStickerView:selectedEmoji:)]) {
        [self.delegate bxMessagesInputStickerView:self selectedEmoji:emoji];
    }
}

@end
