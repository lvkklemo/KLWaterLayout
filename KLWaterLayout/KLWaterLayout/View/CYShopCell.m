//
//  AppDelegate.h
//  KLWaterLayout
//
//  Created by admin on 2022/11/7.
//

#import "CYShopCell.h"
#import "CYShop.h"
#import "UIImageView+WebCache.h"

@interface CYShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation CYShopCell

- (void)setShop:(CYShop *)shop{
    _shop = shop;
    // 1.图片
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img]];
    self.imageView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    // 2.价格
    self.priceLabel.text = shop.price;
}
@end
