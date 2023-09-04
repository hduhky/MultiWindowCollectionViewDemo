//
//  CollectionViewCell.h
//  CollectionViewDemo
//
//  Created by hky on 2023/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite, copy) NSString *text;
@property (nonatomic, readwrite, copy, nullable) void (^block)(void);

@end

NS_ASSUME_NONNULL_END
