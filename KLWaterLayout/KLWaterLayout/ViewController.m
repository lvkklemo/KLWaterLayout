//
//  ViewController.m
//  KLWaterLayout
//
//  Created by admin on 2022/11/7.
//

#import "ViewController.h"
#import "CYWaterFlowLayout.h"
#import "CYShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CYShopCell.h"
#import "SSChoosePhotoHeaderView.h"
static NSString * const CYShopId = @"shop";

@interface ViewController () <UICollectionViewDataSource, CYWaterFlowLayoutDelegate,UICollectionViewDelegate>
/** 所有的商品数据 */
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGSize headerSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shops = [NSMutableArray array];
    self.headerSize = CGSizeMake( UIScreen.mainScreen.bounds.size.width ,100);
    [self setupLayout];
//    [self setupRefresh];
    [self loadMoreShops];
    self.view.backgroundColor = UIColor.orangeColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)setupRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.mj_footer.hidden = YES;
}

- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [CYShop mj_objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}

- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [CYShop mj_objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        [self.shops addObjectsFromArray:shops];
        [self.shops addObjectsFromArray:shops];
        // 刷新数据
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    });
}

- (void)setupLayout
{
    // 创建布局
//    UICollectionViewFlowLayout *f = [[UICollectionViewFlowLayout alloc] init];
//    f.itemSize = CGSizeMake(100, 100);
    
    CYWaterFlowLayout * f =[CYWaterFlowLayout new];
    f.delegate = self;
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:f];
    collectionView.backgroundColor = [UIColor orangeColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CYShopCell class]) bundle:nil] forCellWithReuseIdentifier:CYShopId];
    self.collectionView = collectionView;
    [collectionView registerClass:[SSChoosePhotoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SSChoosePhotoHeaderView"];
}

//组头高度
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//       return CGSizeMake(100, 100);
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//   if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//       UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
//       UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//       label.text = @"hello";label.textColor = UIColor.purpleColor;
//       for (UIView *view in header.subviews) {
//           [view removeFromSuperview];
//       }
//       [header addSubview:label];
//       return header;
//
//   } else {
//       return nil;
//   }
//
//}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SSChoosePhotoHeaderView* view = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([SSChoosePhotoHeaderView class]) forIndexPath:indexPath];
        if (view == nil) {
            view = [[SSChoosePhotoHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.headerSize.width, self.headerSize.height)];
            view.backgroundColor = UIColor.purpleColor;
        }
        view.testLabel.text = @"你好你好你好你好";
        return view;
    }
    return nil;

}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.mj_footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CYShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CYShopId forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    return cell;
}

#pragma mark - <CYWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(CYWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    CYShop *shop = self.shops[index];
    CGFloat hi = 0;
    if (shop.state == 1) {
        hi = 215;
    }else{
        hi = 122;
    }
    return hi;
//    return itemWidth * shop.h / shop.w;
}

///列数
- (CGFloat)columnCountInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout{
    return 2;
}

///每一行的距离
- (CGFloat)rowMarginInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout{
    return 20;
}

///collection边距top left bo right
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

///header的大小
- (CGSize)headerSizeInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout{
    return self.headerSize;
}

///每一列的距离
- (CGFloat)columnMarginInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout{
    return 10;
}

@end

