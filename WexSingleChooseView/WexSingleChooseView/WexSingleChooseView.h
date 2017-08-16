//
//  WexSingleChooseView.h
//  WexSingleChooseView
//
//  Created by wex on 2017/8/15.
//  Copyright © 2017年 wex. All rights reserved.
//

#import <UIKit/UIKit.h>

/********************
 工具条
 ********************/
@interface WexSingleChooseViewToolBar : UIView

@property (nonatomic, copy) void(^cancelButtonClickedBlock)(UIButton *);

@end

/********************
 选择框cell
 ********************/
@interface WexSingleChooseCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setTitle:(NSString *)title;

@end

/********************
 选择框
 ********************/
@class WexSingleChooseView;
@protocol WexSingleChooseViewDelegate <NSObject>

@optional
- (void)singleChooseView:(WexSingleChooseView *)singleChooseView selectedStringValue:(NSString *)stringValue;

@end

@interface WexSingleChooseView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<WexSingleChooseViewDelegate> delegate;

+ (instancetype)singleChooseViewWithDataArray:(NSArray *)dataArray delegate:(id<WexSingleChooseViewDelegate>)delegate;

- (void)show;

- (void)dismiss;

@end
