//
//  HKYWindowModel.m
//  CollectionViewDemo
//
//  Created by hky on 2023/9/4.
//

#import "HKYWindowModel.h"

@implementation HKYWindowModel

- (instancetype)initWithWindowMode:(HKYWindowMode)windowMode {
    self = [super init];
    if (self) {
        _windowMode = windowMode;
    }
    return self;
}

- (NSInteger)indexWithTransformedIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexPathRow = indexPath.item % self.itemsPerPage; // 每页各自的初始index
    NSInteger row = indexPathRow % self.rowCount; // 行数
    NSInteger col = indexPathRow / self.rowCount; // 列数
    NSInteger index = row * self.colCount + col; // 转换成从左往右、从上往下的index
    NSInteger currentPage = indexPath.item / self.itemsPerPage; // 页数
    index += currentPage * self.itemsPerPage; // 转换成实际的index
    return index;
}

- (NSIndexPath *)indexPathWithTransformedIndex:(NSInteger)index {
    NSInteger currentPage = index / self.itemsPerPage; // 计算所在页数
    NSInteger adjustedIndex = index % self.itemsPerPage; // 计算在当前页内的索引
    
    NSInteger col = adjustedIndex / self.rowCount; // 计算列数
    NSInteger row = adjustedIndex % self.rowCount; // 计算行数
    
    NSInteger indexPathRow = col * self.rowCount + row; // 还原为每页的初始index
    indexPathRow += currentPage * self.itemsPerPage; // 加上页数偏移量
    
    // 创建NSIndexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexPathRow inSection:0];
    
    return indexPath;
}

- (CGSize)transformItemSizeWithCollectionViewSize:(CGSize)collectionViewSize {
    return CGSizeMake(collectionViewSize.width / self.colCount, collectionViewSize.height / self.rowCount);
}

- (NSInteger)calculateTotalItemCountWithOriginalItemCount:(NSInteger)originalItemCount {
    NSInteger totalPageCount = ceil((double)originalItemCount / self.itemsPerPage);
    NSInteger extraItemCount = totalPageCount * self.itemsPerPage - originalItemCount;
    NSInteger totalItemCount = originalItemCount + extraItemCount;
    return totalItemCount;
}

- (NSInteger)rowCount {
    NSInteger rowCount;
    switch (self.windowMode) {
        case HKYWindowMode1:
            rowCount = 1;
            break;
        case HKYWindowMode4:
            rowCount = 2;
            break;
        case HKYWindowMode6:
            rowCount = 3;
            break;
        case HKYWindowMode9:
            rowCount = 3;
            break;
        case HKYWindowMode16:
            rowCount = 4;
            break;
    }
    return rowCount;
}

- (NSInteger)colCount {
    NSInteger colCount;
    switch (self.windowMode) {
        case HKYWindowMode1:
            colCount = 1;
            break;
        case HKYWindowMode4:
            colCount = 2;
            break;
        case HKYWindowMode6:
            colCount = 2;
            break;
        case HKYWindowMode9:
            colCount = 3;
            break;
        case HKYWindowMode16:
            colCount = 4;
            break;
    }
    return colCount;
}

- (NSInteger)itemsPerPage {
    return self.rowCount * self.colCount;
}

@end
