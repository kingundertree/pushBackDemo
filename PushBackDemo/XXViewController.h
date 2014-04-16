//
//  XXViewController.h
//  PushBackDemo
//
//  Created by xiazer on 14-4-16.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XXBackTypePopBack = 0,
    XXBackTypeDismiss,
    XXBackTypePopToRoot
} XXBackType;

@interface XXViewController : UIViewController
@property (nonatomic, assign) XXBackType backType;
@end
