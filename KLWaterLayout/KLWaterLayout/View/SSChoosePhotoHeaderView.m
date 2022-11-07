//
//  AppDelegate.h
//  KLWaterLayout
//
//  Created by admin on 2022/11/7.
//

#import "SSChoosePhotoHeaderView.h"

@implementation SSChoosePhotoHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 300, 44)];
        _testLabel = label;
        [self addSubview:label];
        self.backgroundColor = UIColor.purpleColor;
    }
    return self;
}
@end
