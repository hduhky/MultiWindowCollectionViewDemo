//
//  HKYMultiWindowView.h
//  CollectionViewDemo
//
//  Created by hky on 2023/9/4.
//

#import <UIKit/UIKit.h>
#import "HKYWindowModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HKYMultiWindowView;

@protocol HKYMultiWindowViewDataSource <NSObject>

- (NSInteger)mulitWindowViewNumberOfItems:(HKYMultiWindowView *)mulitWindowView;

- (UICollectionViewCell *)mulitWindowView:(HKYMultiWindowView *)mulitWindowView cellForItemAtIndex:(NSInteger)index;

@end

@protocol HKYMultiWindowViewDelegate <NSObject>

- (void)mulitWindowView:(HKYMultiWindowView *)mulitWindowView didSelectItemAtIndex:(NSInteger)index;

@end

@interface HKYMultiWindowView : UIView

@property (nonatomic, readwrite, assign) HKYWindowMode windowMode;
@property (nonatomic, weak, nullable) id<HKYMultiWindowViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<HKYMultiWindowViewDelegate> delegate;
@property (nonatomic, readwrite, assign) NSInteger currentFocusIndex;
@property (nonatomic, readonly, assign) NSInteger currentPageIndex;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
