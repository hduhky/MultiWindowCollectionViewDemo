//
//  HKYWindowModel.h
//  CollectionViewDemo
//
//  Created by hky on 2023/9/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HKYWindowMode) {
    HKYWindowMode1,
    HKYWindowMode4,
    HKYWindowMode6,
    HKYWindowMode9,
    HKYWindowMode16,
};

@interface HKYWindowModel : NSObject

@property (nonatomic, readwrite, assign) HKYWindowMode windowMode;
@property (nonatomic, readonly, assign) NSInteger itemsPerPage;
@property (nonatomic, readonly, assign) NSInteger rowCount;
@property (nonatomic, readonly, assign) NSInteger colCount;

- (instancetype)initWithWindowMode:(HKYWindowMode)windowMode;

- (NSInteger)indexWithTransformedIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathWithTransformedIndex:(NSInteger)index;

- (CGSize)transformItemSizeWithCollectionViewSize:(CGSize)collectionViewSize;

- (NSInteger)calculateTotalItemCountWithOriginalItemCount:(NSInteger)originalItemCount;

@end

NS_ASSUME_NONNULL_END
