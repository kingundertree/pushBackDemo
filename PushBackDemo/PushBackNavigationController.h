//
//  PushBackNavigationController.h
//  PushBackDemo
//
//  Created by shan xu on 14-4-1.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CaptureTypeWithView = 0,
    CaptureTypeWithWindow
}CaptureType; //截图区域选择

@interface PushBackNavigationController : UINavigationController<UIGestureRecognizerDelegate>

//是否支持pushBack动画
@property (nonatomic, assign) CaptureType captureType;
@end
