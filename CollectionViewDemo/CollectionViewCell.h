//
//  CollectionViewCell.h
//  CollectionViewDemo
//
//  Created by hky on 2023/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite, assign) NSInteger index;
@property (nonatomic, readwrite, copy) NSString *text;
@property (nonatomic, readwrite, copy, nullable) void (^onTapped)(NSInteger index);
@property (nonatomic, readwrite, copy, nullable) void (^onDoubleTapped)(void);

@end

NS_ASSUME_NONNULL_END
