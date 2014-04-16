//
//  pushBackLock.h
//  PushBackDemo
//
//  Created by xiazer on 14-4-16.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pushBackLock : NSObject
+ (void)setDisableGestureForBack:(UINavigationController *)nav disable:(BOOL)disable;
@end
