# MultiWindowCollectionViewDemo

self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
    if (size.width > size.height) {
        self.collectionView.frame = CGRectMake(0, 0, size.width, size.height);
    } else {
        self.collectionView.frame = CGRectMake(0, 100, size.width, size.width / 16 * 9);
    }
}

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    return CGPointZero;
}
