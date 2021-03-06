//
//  ZHTabBar.m
//  Framework
//
//  Created by wzh on 16/5/6.
//  Copyright © 2016年 wzh. All rights reserved.
//

#import "ZHTabBar.h"
#import "ZHTabBarButton.h"
@interface ZHTabBar()
@property (nonatomic, weak) UIButton *plusButton;
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) ZHTabBarButton *selectedTabBarButton;
@end

@implementation ZHTabBar


/**
 *  数组的懒加载
 */
- (NSMutableArray *)tabBarButtons
{
    if (!_tabBarButtons) {
        self.tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

/**
 *  加号按钮的懒加载
 */
- (UIButton *)plusButton
{
    if (!_plusButton) {
        UIButton *plusButton = [[UIButton alloc] init];
        // 设置背景
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        // 设置图标
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        
        [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        // 添加
        [self addSubview:plusButton];
        self.plusButton = plusButton;
    }
    return _plusButton;
}

/**
 *  点击了加号按钮
 */
- (void)plusClick
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置背景
        [self setupBg];
    }
    return self;
}

/**
 *  添加一个选项卡按钮
 *
 *  @param item 选项卡按钮对应的模型数据(标题\图标\选中的图标)
 */
- (void)addTabBarButton:(UITabBarItem *)item
{
    // 创建按钮
    ZHTabBarButton *button = [[ZHTabBarButton alloc] init];
    button.item = item;
    [button addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchDown];
    button.tag = self.tabBarButtons.count;
    [self addSubview:button];
    
    // 加到数组中
    [self.tabBarButtons addObject:button];
    
    // 默认让最前面的按钮选中
    if (self.tabBarButtons.count == 1) {
        [self tabBarButtonClick:button];
    }
}

/**
 *  点击选项卡按钮
 */
- (void)tabBarButtonClick:(ZHTabBarButton *)button
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]) {
        NSInteger from = self.selectedTabBarButton.tag;
        NSInteger to = button.tag;
        [self.delegate tabBar:self didSelectButtonFrom:from to:to];
    }
    
    // 更改按钮状态
    self.selectedTabBarButton.selected = NO;
    button.selected = YES;
    self.selectedTabBarButton = button;
}

/**
 *  设置背景
 */
- (void)setupBg
{
    if (!iOS7) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]];
    }
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.计算加号按钮的位置和尺寸
    [self setupPlusButtonFrame];
    
    // 2.设置选项卡按钮的位置和尺寸
    [self setupTabBarButtonFrame];
}

/**
 *  设置选项卡按钮的位置和尺寸
 */
- (void)setupTabBarButtonFrame
{
    NSInteger count = self.tabBarButtons.count;
    
    CGFloat buttonW = self.width / (count + 1);
    CGFloat buttonH = self.height;
    for (int i = 0; i < count; i++) {
        ZHTabBarButton *button = self.tabBarButtons[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = buttonW * i;
        button.y = 0;
        
        if (i >= count / 2) {
            button.x += buttonW;
        }
    }
}

/**
 *  计算加号按钮的位置和尺寸
 */
- (void)setupPlusButtonFrame
{
    CGSize plusButtonSize = self.plusButton.currentBackgroundImage.size;
    // 设置尺寸
    self.plusButton.width = plusButtonSize.width;
    self.plusButton.height = plusButtonSize.height;
    // 设置中点
    self.plusButton.centerX = self.width * 0.5;
    self.plusButton.centerY = self.height * 0.5;
    //    self.plusButton.bounds = (CGRect){CGPointZero, plusButtonSize};
}
@end
