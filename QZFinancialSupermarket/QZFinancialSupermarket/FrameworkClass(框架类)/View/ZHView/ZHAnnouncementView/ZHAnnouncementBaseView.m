//
//  ZHAnnouncementCell.m
//  QIZiDaiDemo
//
//  Created by wzh on 17/3/27.
//  Copyright © 2017年 xue. All rights reserved.
//

#import "ZHAnnouncementBaseView.h"

@implementation ZHAnnouncementBaseView

@synthesize itemView = _itemView;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.itemView.frame = self.bounds;
}

- (UIView *)itemView
{
    if (!_itemView) {
        _itemView = [[UIView alloc] init];
    }
    return _itemView;
}

- (void)setItemView:(UIView *)itemView
{
    if (_itemView) {
        [_itemView removeFromSuperview];
    }
    
    _itemView = itemView;
    
    [self addSubview:_itemView];
}


@end
