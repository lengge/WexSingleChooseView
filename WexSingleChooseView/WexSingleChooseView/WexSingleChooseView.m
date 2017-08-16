//
//  WexSingleChooseView.m
//  WexSingleChooseView
//
//  Created by wex on 2017/8/15.
//  Copyright © 2017年 wex. All rights reserved.
//

#import "WexSingleChooseView.h"
#import "WexSingleChooseViewMacro.h"
#import "UIView+Wex.h"
#import "UIColor+Wex.h"

/********************
 工具条
 ********************/
@interface WexSingleChooseViewToolBar ()

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation WexSingleChooseViewToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self wex_setupSubviews];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, BORDER_WIDTH_1PX);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#E4E4E4"].CGColor);
    CGContextMoveToPoint(context, 0, self.height - BORDER_WIDTH_1PX / 2);
    CGContextAddLineToPoint(context, self.width, self.height - BORDER_WIDTH_1PX / 2);
    CGContextStrokePath(context);
}

- (void)wex_setupSubviews {
    [self.cancelButton sizeToFit];
    self.cancelButton.left = 15.f;
    self.cancelButton.centerY = self.centerY;
    [self addSubview:self.cancelButton];
}

- (void)buttonClicked:(UIButton *)button {
    if (self.cancelButtonClickedBlock) {
        self.cancelButtonClickedBlock(button);
    }
}

#pragma mark - getter
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end

/********************
 选择框cell
 ********************/
@interface WexSingleChooseCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *icon;

@end

@implementation WexSingleChooseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"WexSingleChooseCell";
    WexSingleChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WexSingleChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self wex_setupSubviews];
    }
    return self;
}

- (void)wex_setupSubviews {
    self.titleLabel.left = 15.f;
    self.titleLabel.centerY = self.contentView.centerY;
    [self.contentView addSubview:self.titleLabel];
    
    self.icon.right = SCREEN_WIDTH - 15.f;
    self.icon.centerY = self.contentView.centerY;
    [self.contentView addSubview:self.icon];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [self.icon setImage:[UIImage imageNamed:@"cell-state-selected"]];
    } else {
        [self.icon setImage:[UIImage imageNamed:@"cell-state-normal"]];
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 17.f)];
        [_titleLabel setFont:[UIFont systemFontOfSize:17.f]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
    }
    return _titleLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        [_icon setImage:[UIImage imageNamed:@"cell-state-normal"]];
        [_icon sizeToFit];
    }
    return _icon;
}

@end

/********************
 选择框
 ********************/
@interface WexSingleChooseView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *boxView;

@property (nonatomic, strong) WexSingleChooseViewToolBar *toolBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@end

@implementation WexSingleChooseView

+ (instancetype)singleChooseViewWithDataArray:(NSArray *)dataArray delegate:(id<WexSingleChooseViewDelegate>)delegate {
    
    WexSingleChooseView *singleChooseView = [[WexSingleChooseView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    singleChooseView.dataArray = dataArray;
    singleChooseView.delegate = delegate;
    
    return singleChooseView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.0];
        [self wex_setupSubviews];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    if (dataArray.count * KKChooseViewCellHeight < KChooseViewMaxContentHeight) {
        self.tableView.height = dataArray.count * KKChooseViewCellHeight;
        self.boxView.height = KChooseViewToolBarHeight + self.tableView.height;
    }
    
    [self.tableView reloadData];
}

- (void)wex_setupSubviews {
    
    @weakify(self);
    self.toolBar.cancelButtonClickedBlock = ^(UIButton *button) {
        [weak_self dismiss];
    };
    
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.toolBar];
    [self.boxView addSubview:self.tableView];
}

- (void)show {
    [kKeyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5];
        self.boxView.top = SCREEN_HEIGHT - self.boxView.height;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.0];
        self.boxView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WexSingleChooseCell *cell = [WexSingleChooseCell cellWithTableView:tableView];

    [cell setTitle:[self.dataArray objectAtIndex:indexPath.row]];
    
    if (self.lastSelectedIndexPath == indexPath) {
        [cell setSelected:YES];
    } else {
        [cell setSelected:NO];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KKChooseViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WexSingleChooseCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.lastSelectedIndexPath == nil) {
        [newCell setSelected:YES];
        self.lastSelectedIndexPath = indexPath;
    } else if (self.lastSelectedIndexPath != indexPath) {
        [newCell setSelected:YES];
        
        WexSingleChooseCell *oldCell = [tableView cellForRowAtIndexPath:self.lastSelectedIndexPath];
        [oldCell setSelected:NO];
        self.lastSelectedIndexPath = indexPath;
    }
    
    [self dismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleChooseView:selectedStringValue:)]) {
        [self.delegate singleChooseView:self selectedStringValue:[self.dataArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark - getter
- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KChooseViewToolBarHeight + KChooseViewMaxContentHeight)];
    }
    return _boxView;
}

- (WexSingleChooseViewToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[WexSingleChooseViewToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KChooseViewToolBarHeight)];
    }
    return _toolBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KChooseViewToolBarHeight, SCREEN_WIDTH, KChooseViewMaxContentHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

@end
