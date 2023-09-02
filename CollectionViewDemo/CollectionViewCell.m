//
//  CollectionViewCell.m
//  CollectionViewDemo
//
//  Created by hky on 2023/9/1.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (nonatomic, readwrite, strong) UILabel *label;

@end

@implementation CollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }
    return _label;
}

@end
