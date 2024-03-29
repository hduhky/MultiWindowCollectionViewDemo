//
//  HKYMultiWindowView.m
//  CollectionViewDemo
//
//  Created by hky on 2023/9/4.
//

#import "HKYMultiWindowView.h"

@interface HKYMultiWindowView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, readwrite, strong) HKYWindowModel *windowModel;
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, assign) NSInteger currentPageIndex;

@end

@implementation HKYMultiWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
    self.collectionView.frame = self.bounds;
}

#pragma mark - public
- (void)setWindowMode:(HKYWindowMode)windowMode {
    if (self.windowModel.windowMode != windowMode) {
        self.windowModel.windowMode = windowMode;
        self.currentPageIndex = self.currentFocusIndex / self.windowModel.itemsPerPage;
        [self.collectionView reloadData];
    }
}

- (HKYWindowMode)windowMode {
    return self.windowModel.windowMode;
}

- (void)setCurrentFocusIndex:(NSInteger)currentFocusIndex {
    if (_currentFocusIndex != currentFocusIndex) {
        _currentFocusIndex = currentFocusIndex;
        [self.collectionView reloadData];
        if ([self.delegate respondsToSelector:@selector(multiWindowView:onCurrentFocusIndexChanged:)]) {
            [self.delegate multiWindowView:self onCurrentFocusIndexChanged:currentFocusIndex];
        }
        // 更新焦点窗格时刷新窗格页数
        NSInteger currentPageIndex = currentFocusIndex / self.windowModel.itemsPerPage;
        self.currentPageIndex = currentPageIndex;
    }
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.windowModel indexPathWithTransformedIndex:index];
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(multiWindowViewNumberOfItems:)]) {
        NSInteger originalItemCount = [self.dataSource multiWindowViewNumberOfItems:self];
        NSInteger totalItemCount = [self.windowModel calculateTotalItemCountWithOriginalItemCount:originalItemCount];
        return totalItemCount;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(multiWindowView:cellForItemAtIndex:)]) {
        NSInteger index = [self.windowModel indexWithTransformedIndexPath:indexPath];
        UICollectionViewCell *cell = [self.dataSource multiWindowView:self cellForItemAtIndex:index];
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.windowModel transformItemSizeWithCollectionViewSize:collectionView.bounds.size];
}

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    return CGPointMake(self.currentPageIndex * CGRectGetWidth(self.collectionView.bounds), 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger oldPageIndex = self.currentPageIndex;
    NSInteger currentPageIndex = [self calculateCurrentPageIndex];
    if (oldPageIndex != currentPageIndex) {
        self.currentPageIndex = currentPageIndex;
        self.currentFocusIndex = currentPageIndex * self.windowModel.itemsPerPage;
    }
}

#pragma mark - calculate index
- (NSInteger)calculateCurrentPageIndex {
    CGFloat pageWidth = CGRectGetWidth(self.collectionView.bounds);
    NSInteger currentPage = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return currentPage;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    if (_currentPageIndex != currentPageIndex) {
        _currentPageIndex = currentPageIndex;
        [self.collectionView setContentOffset:CGPointMake(self.currentPageIndex * CGRectGetWidth(self.collectionView.bounds), 0) animated:NO];
        if ([self.delegate respondsToSelector:@selector(multiWindowView:onCurrentPageIndexChanged:)]) {
            [self.delegate multiWindowView:self onCurrentPageIndexChanged:currentPageIndex];
        }
    }
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

- (HKYWindowModel *)windowModel {
    if (!_windowModel) {
        _windowModel = [[HKYWindowModel alloc] initWithWindowMode:HKYWindowMode1];
    }
    return _windowModel;
}

@end
