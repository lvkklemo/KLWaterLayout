//
//  CYWaterFlowLayout.m
//  瀑布流
//
//  Created by 葛聪颖 on 15/11/15.
//  Copyright © 2015年 聪颖不聪颖. All rights reserved.
//

#import "CYWaterFlowLayout.h"

/** 默认的列数 */
static const NSInteger KZDefaultColumnCount = 2;
/** 每一列之间的间距 */
static const CGFloat KZDefaultColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat KZDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets KZDefaultEdgeInsets = {10, 10, 10, 10};

@interface CYWaterFlowLayout()
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;
@end

@implementation CYWaterFlowLayout

///初始化
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.contentHeight = 0;
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < [self kColumnCount]; i++) {
        [self.columnHeights addObject:@([self kEdgeInsets].top+[self kHeaderSize].height)];
    }
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    //头部视图 加入header布局属性
     UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:0]];
     layoutHeader.frame =CGRectMake(0,0, [self kHeaderSize].width, [self kHeaderSize].height);
     [self.attrsArray addObject:layoutHeader];
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self myLayoutAttributesForItemAtIndexPath:indexPath];
        if (attrs) {
            [self.attrsArray addObject:attrs];
        }
    }
}

///返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)myLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    // 设置布局属性的frame
    CGFloat colMargin = ([self kColumnCount] - 1) * [self kColumnMargin];
    CGFloat w = floorf((collectionViewW - [self kEdgeInsets].left - [self kEdgeInsets].right - colMargin) / [self kColumnCount]);
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < [self kColumnCount]; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = [self kEdgeInsets].left + destColumn * (w + [self kColumnMargin]);
    CGFloat y = minColumnHeight;
    if (y != [self kEdgeInsets].top) {
        y += [self kRowMargin];
    }
    attrs.frame = CGRectMake(x, y, w, h);
    // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

///决定cell的排布
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize{
    CGSize size = CGSizeMake(0, self.contentHeight + [self kEdgeInsets].bottom);
    return size;
}

#pragma mark - 常见数据
///每一行之间的间距
- (CGFloat)kRowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return KZDefaultRowMargin;
    }
}

///每一列之间的间距
- (CGFloat)kColumnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return KZDefaultColumnMargin;
    }
}

- (NSInteger)kColumnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return KZDefaultColumnCount;
    }
}

- (UIEdgeInsets)kEdgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return KZDefaultEdgeInsets;
    }
}

- (CGSize)kHeaderSize{
    if ([self.delegate respondsToSelector:@selector(headerSizeInWaterflowLayout:)]) {
        return [self.delegate headerSizeInWaterflowLayout:self];
    } else {
        return CGSizeZero;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
@end
