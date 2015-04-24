//
//  PushBackNavigationController.h
//  PushBackDemo
//
//  Created by shan xu on 14-4-1.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import <UIKit/UIKit.h>

//使用方法：初始化使用：PushBackNavigationController *navH = [[PushBackNavigationController alloc] initWithRootViewController:self.xxxx];
//手势返回效果设置: 包括背景图缩放和背景图缓慢平滑。默认背景图缓慢平滑效果，可以navH.pushBackType = PushBackWithScale;来设置背景图缩放效果
//popToRoot设置：在当前ViewController页面继承RTViewController，并设置self.backType == XXBackTypePopToRoot
//禁止手势返回效果：引入pushBackLock，掉用[pushBackLock setDisableGestureForBack:self.navgationgationController disable:YES];
//UITableView didSelect 手势冲突，建议在didSelectRowAtIndexPath方法中添加：if (self.navigationController.view.frame.origin.x > 0) return;
//创建cell的时候，请一定要继承自RTListCell(通过longPress实现setHighlited效果)，否则无法顺利出现setHighlited效果

typedef enum {
    CaptureTypeWithView = 0,
    CaptureTypeWithWindow
}CaptureType; //截图区域选择

typedef enum {
    PushBackWithScale = 0,
    PushBackWithSlowMove
}PushBckType; //pushback效果

@interface PushBackNavigationController : UINavigationController <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL disableGestureForBack;
@property (nonatomic, assign) CaptureType captureType;
@property (nonatomic, assign) PushBckType pushBackType;


@end


