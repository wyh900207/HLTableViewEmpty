//
//  UITableView+HLEmptyView.m
//
//  Created by HomerLynn on 2018/1/8.
//  Copyright © 2018年 HomerLynn. All rights reserved.
//

#import "UITableView+HLEmptyView.h"
#import <objc/runtime.h>

static NSString * const kHLTableViewIsFinished = @"kHLTableViewIsFinished";

@implementation UITableView (HLEmptyView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method reloadData = class_getInstanceMethod(self, @selector(reloadData));
        Method hl_reloadData = class_getInstanceMethod(self, @selector(hl_reloadData));
        method_exchangeImplementations(reloadData, hl_reloadData);
    });
}

/// Custom reloadData method
/// echange it with system's reloadData method to set the backgroundView
- (void)hl_reloadData {
    [self hl_reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger numberOfSections = [self numberOfSections];
        BOOL havingData = NO;
        for (NSInteger i = 0; i < numberOfSections; i++) {
            if ([self numberOfRowsInSection:i] > 0) {
                havingData = !havingData;
                break;
            }
        }
        [self hl_havingData:havingData];
    });
}

/// Set empty view when data source is nil
/// and reset empty nil when data source is not nil
/// you can custom empty view if you needed
- (void)hl_havingData:(BOOL)havingData {
    if (havingData) {
        self.backgroundView = nil;
        return;
    }
    if (self.backgroundView) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(hl_customEmptyView)]) {
        self.backgroundView = [self.delegate performSelector:@selector(hl_customEmptyView)];
        return;
    }
    self.backgroundView = [self defaultBackgroundView];
}

/// It will set default view as empty view if you didn't custom empty view yourself
- (UIView *)defaultBackgroundView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

- (BOOL)isFinished {
    id isFinished = objc_getAssociatedObject(self, &kHLTableViewIsFinished);
    return [isFinished boolValue];
}

- (void)setIsFinished:(BOOL)finished {
    objc_setAssociatedObject(self, &kHLTableViewIsFinished, @(finished), OBJC_ASSOCIATION_ASSIGN);
}

@end
