//
//  WexSingleChooseViewMacro.h
//  WexSingleChooseView
//
//  Created by wex on 2017/8/15.
//  Copyright © 2017年 wex. All rights reserved.
//

#ifndef WexSingleChooseViewMacro_h
#define WexSingleChooseViewMacro_h

#define KKChooseViewCellHeight      (44)

#define KChooseViewToolBarHeight    (40)

#define KChooseViewMaxContentHeight (SCREEN_HEIGHT / 2 - KChooseViewToolBarHeight)

#define BORDER_WIDTH_1PX ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

#define SCREEN_W      ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_H      ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_WIDTH  (SCREEN_W < SCREEN_H ? SCREEN_W : SCREEN_H)

#define SCREEN_HEIGHT (SCREEN_W < SCREEN_H ? SCREEN_H : SCREEN_W)

#define kKeyWindow    [UIApplication sharedApplication].keyWindow

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* WexSingleChooseViewMacro_h */
