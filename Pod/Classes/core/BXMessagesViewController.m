//
//  BXMessagesViewController.m
//  Baixing
//
//  Created by hyice on 15/3/16.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesViewController.h"
#import "BXMessagesMultiInputView.h"
#import "UIView+BXMessagesKit.h"
#import "BXMessagesCollectionView.h"
#import "BXMessagesInputAccessoryView.h"

@interface BXMessagesViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate>

@property (strong, nonatomic) BXMessagesCollectionView *collectionView;
@property (strong, nonatomic) BXMessagesMultiInputView *multiInputView;

@property (strong, nonatomic) NSLayoutConstraint *multiInputViewBottomConstraint;
@property (strong, nonatomic) NSLayoutConstraint *multiInputViewTopConstraint;

@end

@implementation BXMessagesViewController

@synthesize multiInputBackgroundView = _multiInputBackgroundView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0xf2/255.0 green:0xf3/255.0 blue:0xee/255.0 alpha:1.0];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardNotificationCenterObservers];
    [self bxAddMultiInputViewKVOObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotificationCenterObservers];
    [self bxRemoveMultiInputViewKVOObserver];
}

- (void)initViews
{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.multiInputBackgroundView];
    [self.view addSubview:self.multiInputView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.multiInputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.multiInputView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    self.multiInputViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.multiInputView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    self.multiInputViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.multiInputView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:self.multiInputViewBottomConstraint];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[multiInputView]-0-|" options:0 metrics:nil views:@{@"multiInputView":self.multiInputView}]];

    [self.view addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.multiInputBackgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.multiInputBackgroundView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.multiInputBackgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.multiInputView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.multiInputBackgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
    ]];
}

#pragma mark - public methods
- (NSInteger)bx_numberOfRowsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (UICollectionViewCell *)bx_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)bx_collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)bx_registerCellsForCollectionView:(UICollectionView *)collectionView {}

- (void)bx_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {};

#pragma mark - collection view
- (BXMessagesCollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[BXMessagesCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = YES;
        
        [self bx_registerCellsForCollectionView:_collectionView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTapped:)];
        tap.delegate = self;
        [_collectionView addGestureRecognizer:tap];
    }
    
    return _collectionView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.multiInputView showAccessoryView:NO animated:YES];
    [self.view endEditing:YES];
}

- (void)collectionViewTapped:(UITapGestureRecognizer *)tap
{
    [self.multiInputView showAccessoryView:NO animated:YES];
}

#pragma mark - collection view dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self bx_numberOfRowsInCollectionView:collectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self bx_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self bx_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - collection view layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.bounds.size.width, [self bx_collectionView:collectionView heightForItemAtIndexPath:indexPath]);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.multiInputView.isShowingAccessoryView;
}

#pragma mark - multi input view
- (BXMessagesMultiInputView *)multiInputView
{
    if (!_multiInputView) {
        _multiInputView = [[BXMessagesMultiInputView alloc] init];
    }
    
    return _multiInputView;
}

- (UIView *)multiInputBackgroundView
{
    if (!_multiInputBackgroundView) {
        _multiInputBackgroundView = [[UIView alloc] init];
        _multiInputBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _multiInputBackgroundView.backgroundColor = [UIColor colorWithRed:0xf9/255.0 green:0xf9/255.0 blue:0xf9/255.0 alpha:1.0];
    }
    return _multiInputBackgroundView;
}

- (void)hideInputView:(BOOL)hide
{
    if (hide) {
        [self.view removeConstraint:self.multiInputViewBottomConstraint];
        [self.view addConstraint:self.multiInputViewTopConstraint];
    } else {
        [self.view removeConstraint:self.multiInputViewTopConstraint];
        [self.view addConstraint:self.multiInputViewBottomConstraint];
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
    
    CGRect keyboardEndRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = curve << 16;
    if (self.multiInputView.isShowingAccessoryView) {
        options = 0;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.multiInputViewBottomConstraint.constant = -keyboardEndRect.size.height + [self iPhoneXBottomInset];
            [self.view.bxMessagesKit_superSuperView layoutIfNeeded];
            if (self.collectionView.contentSize.height>self.collectionView.bounds.size.height) {
                [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height
                                                                  - self.collectionView.bounds.size.height) animated:NO];
            }
        } completion:^(BOOL finished) {
        }];
    });
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = curve << 16;
    if (self.multiInputView.isShowingAccessoryView) {
        options = 0;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.multiInputViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (CGFloat)iPhoneXBottomInset
{
    if (@available(iOS 11.0, *)) {
        if ([UIScreen mainScreen].nativeBounds.size.height == 2436) {
            return self.view.safeAreaInsets.bottom;
        }
    }
    return 0;
}

#pragma mark - kvo
- (void)bxAddMultiInputViewKVOObserver
{
    [self.multiInputView addObserver:self forKeyPath:NSStringFromSelector(@selector(isShowingAccessoryView)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)bxRemoveMultiInputViewKVOObserver
{
    @try {
        [self.multiInputView removeObserver:self forKeyPath:NSStringFromSelector(@selector(isShowingAccessoryView))];
    }
    @catch (NSException *exception) {
        NSLog(@"BXMessagesKit: Quick Controller remove 'isShowingAccessoryView' KVO error!");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isShowingAccessoryView))]
        && object == self.multiInputView) {
        if (!self.multiInputView.isShowingAccessoryView) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25f animations:^{
                if (self.collectionView.contentSize.height > self.collectionView.bounds.size.height) {
                    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height
                                                                      - self.collectionView.bounds.size.height) animated:NO];
                }
            }];
        });
    }
}

@end
