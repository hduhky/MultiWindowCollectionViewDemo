#import "ViewController.h"
#import "CollectionViewCell.h"

typedef NS_ENUM(NSUInteger, WindowMode) {
    WindowMode1,
    WindowMode4,
    WindowMode6,
    WindowMode9,
    WindowMode16,
};

@interface WindowModel : NSObject

@property (nonatomic, readwrite, assign) WindowMode windowMode;
@property (nonatomic, readonly, assign) NSInteger itemsPerPage;
@property (nonatomic, readonly, assign) NSInteger rowCount;
@property (nonatomic, readonly, assign) NSInteger colCount;

- (instancetype)initWithWindowMode:(WindowMode)windowMode;

- (NSInteger)transformIndexWithIndexPath:(NSIndexPath *)indexPath;

- (CGSize)transformItemSizeWithCollectionViewSize:(CGSize)collectionViewSize;

@end

@implementation WindowModel

- (instancetype)initWithWindowMode:(WindowMode)windowMode {
    self = [super init];
    if (self) {
        _windowMode = windowMode;
    }
    return self;
}

- (NSInteger)transformIndexWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexPathRow = indexPath.item % self.itemsPerPage; // 每页各自的初始index
    NSInteger row = indexPathRow % self.rowCount; // 行数
    NSInteger col = indexPathRow / self.rowCount; // 列数
    NSInteger index = row * self.colCount + col; // 转换成从左往右、从上往下的index
    NSInteger currentPage = indexPath.item / self.itemsPerPage; // 页数
    index += currentPage * self.itemsPerPage; // 转换成实际的index
    return index;
}

- (CGSize)transformItemSizeWithCollectionViewSize:(CGSize)collectionViewSize {
    return CGSizeMake(collectionViewSize.width / self.colCount, collectionViewSize.height / self.rowCount);
}

- (NSArray *)fillArray:(NSArray *)originalArray {
    NSInteger totalPageCount = ceil((double)originalArray.count / self.itemsPerPage);
    NSInteger extraModelCount = totalPageCount * self.itemsPerPage - originalArray.count;
    NSMutableArray *extraArray = [NSMutableArray array];
    for (int i = 0; i < extraModelCount; i++) {
        [extraArray addObject:[NSNull null]];
    }
    NSMutableArray *result = [NSMutableArray arrayWithArray:originalArray];
    [result addObjectsFromArray:extraArray];
    return [result copy];
}

- (NSInteger)rowCount {
    NSInteger rowCount;
    switch (self.windowMode) {
        case WindowMode1:
            rowCount = 1;
            break;
        case WindowMode4:
            rowCount = 2;
            break;
        case WindowMode6:
            rowCount = 3;
            break;
        case WindowMode9:
            rowCount = 3;
            break;
        case WindowMode16:
            rowCount = 4;
            break;
    }
    return rowCount;
}

- (NSInteger)colCount {
    NSInteger colCount;
    switch (self.windowMode) {
        case WindowMode1:
            colCount = 1;
            break;
        case WindowMode4:
            colCount = 2;
            break;
        case WindowMode6:
            colCount = 2;
            break;
        case WindowMode9:
            colCount = 3;
            break;
        case WindowMode16:
            colCount = 4;
            break;
    }
    return colCount;
}

- (NSInteger)itemsPerPage {
    NSInteger itemsPerPage;
    switch (self.windowMode) {
        case WindowMode1:
            itemsPerPage = 1;
            break;
        case WindowMode4:
            itemsPerPage = 4;
            break;
        case WindowMode6:
            itemsPerPage = 6;
            break;
        case WindowMode9:
            itemsPerPage = 9;
            break;
        case WindowMode16:
            itemsPerPage = 16;
            break;
    }
    return itemsPerPage;
}

@end

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, readwrite, strong) WindowModel *windowModel;
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, copy) NSArray<UIColor *> *randomColors;
@property (nonatomic, readwrite, copy) NSArray *cellModels;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupWindowModeButtons];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) / 16 * 9) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];

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
    
    [self updateWindowMode:WindowMode1];
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
    [self updateWindowMode:button.tag];
    [self.collectionView reloadData];
}

- (void)updateWindowMode:(WindowMode)windowMode {
    self.windowModel = [[WindowModel alloc] initWithWindowMode:windowMode];
    self.cellModels = [self.windowModel fillArray:self.randomColors];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    NSInteger index = [self.windowModel transformIndexWithIndexPath:indexPath];
    if ([self.cellModels[index] isKindOfClass:[UIColor class]]) {
        cell.text = [NSString stringWithFormat:@"%ld", index];
        cell.backgroundColor = self.cellModels[index];
    } else {
        cell.text = @"";
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.windowModel transformItemSizeWithCollectionViewSize:collectionView.bounds.size];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", [self.windowModel transformIndexWithIndexPath:indexPath]);
}

@end
