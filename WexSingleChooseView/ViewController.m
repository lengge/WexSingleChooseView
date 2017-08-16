//
//  ViewController.m
//  WexSingleChooseView
//
//  Created by wex on 2017/8/15.
//  Copyright © 2017年 wex. All rights reserved.
//

#import "ViewController.h"
#import "WexSingleChooseView.h"

@interface ViewController ()<WexSingleChooseViewDelegate>

@property (nonatomic, strong) WexSingleChooseView *singleChooseView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"show" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    _dataArray = @[@[@"院士", @"博士", @"研究生", @"本科生", @"高中", @"中学", @"小学"],
                           @[@"父亲", @"母亲", @"配偶", @"子女", @"兄弟姐妹", @"其他亲属", @"朋友"],
                           @[@"一般职业", @"农牧业", @"渔业", @"木材、森林业", @"矿业、采石业", @"交通运输业", @"餐旅业", @"建筑工程业（土木工程）", @"制造业", @"新闻、出版、广告业", @"卫生", @"娱乐业", @"金融业", @"其他"]];
    _singleChooseView = [WexSingleChooseView singleChooseViewWithDataArray:[_dataArray firstObject] delegate:self];
}

- (void)singleChooseView:(WexSingleChooseView *)singleChooseView selectedStringValue:(NSString *)stringValue {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"选择了", @"") message:stringValue preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clickAction:(UIButton *)button {
    
    _singleChooseView.dataArray = [_dataArray objectAtIndex:arc4random()%_dataArray.count];
    [_singleChooseView show];
}


@end
