//
//  CYWaterFlowLayout.h
//  瀑布流
//
//  Created by 葛聪颖 on 15/11/15.
//  Copyright © 2015年 聪颖不聪颖. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYWaterFlowLayout;

@protocol CYWaterFlowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(CYWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout;
///每一列的距离
- (CGFloat)columnMarginInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout;
///边距
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout;
- (CGSize)headerSizeInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout;
@end

@interface CYWaterFlowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<CYWaterFlowLayoutDelegate> delegate;
@end
