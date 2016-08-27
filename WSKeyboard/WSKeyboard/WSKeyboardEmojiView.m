//
//  WSKeyboardEmojiView.m
//  WSKeyboard
//
//  Created by Attu on 16/8/26.
//  Copyright © 2016年 Attu. All rights reserved.
//

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#import "WSKeyboardEmojiView.h"
#import "WSKeyboardEmojiCell.h"

@interface WSKeyboardEmojiView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *emojiNameList;

@end

@implementation WSKeyboardEmojiView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)];
        NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]-0-[_pageControl(==37.0)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView, _pageControl)];
        NSArray *constraint_H_pageControl = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pageControl]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)];
        [self addConstraints:constraint_H];
        [self addConstraints:constraint_V];
        [self addConstraints:constraint_H_pageControl];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (NSInteger)ceil([self.emojiNameList count]/8.0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSKeyboardEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojiCell" forIndexPath:indexPath];
    NSInteger emojiIndex = indexPath.section*8 + indexPath.row;
    if (emojiIndex < [self.emojiNameList count]) {
        [cell loadImageWithEmojiName:[self.emojiNameList objectAtIndex:emojiIndex]];
    } else {
        [cell loadImageWithEmojiName:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger emojiIndex = indexPath.section*8 + indexPath.row;
    if (emojiIndex < [self.emojiNameList count]) {
        [self.delegate submitKeyboardEmojiName:[self.emojiNameList objectAtIndex:emojiIndex]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = screenW;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(screenW/4.0f, (screenW/4.0)*19/26.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 0, 4, 0);
}

#pragma mark - InitViews

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView registerClass:[WSKeyboardEmojiCell class] forCellWithReuseIdentifier:@"emojiCell"];
        [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7f];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7f];
        _pageControl.currentPageIndicatorTintColor =[UIColor colorWithRed:234/255.0f green:55.0/255.0f blue:140/255.0f alpha:1.0f];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPage = 1;
        _pageControl.numberOfPages = (NSInteger)ceil([self.emojiNameList count]/8.0);
        [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _pageControl;
}

- (NSMutableArray *)emojiNameList{
    if (!_emojiNameList) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojiNameList" ofType:@"plist"];
        _emojiNameList = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }return _emojiNameList;
}

@end
