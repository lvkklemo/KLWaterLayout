//
//  SSChoosePhotoHeaderView.m
//  瀑布流
//
//  Created by admin on 2022/10/20.
//  Copyright © 2022 聪颖不聪颖. All rights reserved.
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
