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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGesture];
    }
    return self;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture {
    if (self.onTapped) {
        self.onTapped(self.index);
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    if (self.onDoubleTapped) {
        self.onDoubleTapped();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}

- (void)setIsFocused:(BOOL)isFocused {
    // 检查是否是焦点窗格
    if (isFocused) {
        // 设置焦点窗格的外观
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        self.layer.borderWidth = 0.0;
    }
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
