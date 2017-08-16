//
//  UIColor+Wex.h
//  WexSingleChooseView
//
//  Created by wex on 2017/8/16.
//  Copyright © 2017年 wex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Wex)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
