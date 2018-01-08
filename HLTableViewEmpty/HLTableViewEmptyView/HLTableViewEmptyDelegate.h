//
//  HLTableViewEmptyDelegate.h
//  XYTableViewNoDataViewDemo
//
//  Created by HomerLynn on 2018/1/8.
//  Copyright © 2018年 韩元旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HLTableViewEmptyDelegate <NSObject>

@optional;
- (UIView *)hl_customEmptyView;

@end
