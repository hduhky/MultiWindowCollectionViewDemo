#import "ViewController.h"
#import "CollectionViewCell.h"
#import "HKYMultiWindowView.h"

@interface ViewController () <HKYMultiWindowViewDataSource, HKYMultiWindowViewDelegate>

@property (nonatomic, readwrite, strong) HKYMultiWindowView *multiWindowView;
@property (nonatomic, readwrite, copy) NSArray<UIColor *> *randomColors;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupWindowModeButtons];
}

- (void)setupCollectionView {
    self.multiWindowView = [[HKYMultiWindowView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) / 16 * 9)];
    self.multiWindowView.backgroundColor = [UIColor grayColor];
    self.multiWindowView.dataSource = self;
    self.multiWindowView.delegate = self;
    [self.view addSubview:self.multiWindowView];

    [self.multiWindowView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];

    // 生成随机颜色数组
    NSMutableArray *colors = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        UIColor *randomColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0
                                                green:arc4random_uniform(256) / 255.0
                                                 blue:arc4random_uniform(256) / 255.0
                                                alpha:1.0];
        [colors addObject:randomColor];
    }
    self.randomColors = [colors copy];
}

- (void)setupWindowModeButtons {
    NSArray *titles = @[
        @"WindowMode1",
        @"WindowMode4",
        @"WindowMode6",
        @"WindowMode9",
        @"WindowMode16",
    ];
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 400 + 60 * i, CGRectGetWidth(self.view.bounds), 60);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)onButtonClicked:(UIButton *)button {
    self.multiWindowView.windowMode = button.tag;
}

#pragma mark - HKYMultiWindowViewDataSource
- (NSInteger)mulitWindowViewNumberOfItems:(HKYMultiWindowView *)mulitWindowView {
    return self.randomColors.count;
}

- (UICollectionViewCell *)mulitWindowView:(HKYMultiWindowView *)mulitWindowView cellForItemAtIndex:(NSInteger)index {
    CollectionViewCell *cell = [mulitWindowView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndex:index];
    if (index < self.randomColors.count) {
        cell.text = [NSString stringWithFormat:@"%ld", index];
        cell.backgroundColor = self.randomColors[index];
        // 检查是否是焦点窗格
        if (index == self.multiWindowView.currentFocusIndex) {
            // 设置焦点窗格的外观
            cell.layer.borderWidth = 2.0;
            cell.layer.borderColor = [UIColor redColor].CGColor;
        } else {
            cell.layer.borderWidth = 0.0;
        }
    } else {
        cell.text = @"";
        cell.backgroundColor = [UIColor clearColor];
        cell.layer.borderWidth = 0.0;
    }
    return cell;
}

#pragma mark - HKYMultiWindowViewDelegate
- (void)mulitWindowView:(HKYMultiWindowView *)mulitWindowView didSelectItemAtIndex:(NSInteger)index {
    if (index < self.randomColors.count) {
        self.multiWindowView.currentFocusIndex = index;
    }
}

#pragma mark - rotation
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (size.width > size.height) {
        self.multiWindowView.frame = CGRectMake(0, 0, size.width, size.height);
    } else {
        self.multiWindowView.frame = CGRectMake(0, 100, size.width, size.width / 16 * 9);
    }
}

@end
