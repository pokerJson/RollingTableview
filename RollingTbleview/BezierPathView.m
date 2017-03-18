//
//  BezierPathView.m
//  RollingTbleview
//
//  Created by CYAX_BOY on 17/3/18.
//  Copyright © 2017年 CYAX_BOY. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark 画图
- (void)drawRect:(CGRect)rect {
    if (self.up) {
        // 创建一个贝塞尔曲线句柄
        NSLog(@"bezierheiiii2222==%f",self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPath];
        // 初始化该path到一个初始点
        [path moveToPoint:CGPointMake(0, 0)];
        //    // 添加一条直线，从初始点到该函数指定的坐标点
        [path addLineToPoint:CGPointMake(0, self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(200,  self.bounds.size.height)];
        [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(20,self.bounds.size.height)];
        
        // 关闭该path
        [path closePath];
        // 创建描边（Quartz）上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 将此path添加到Quartz上下文中
        CGContextAddPath(context, path.CGPath);
        // 设置本身颜色
        [[UIColor whiteColor] set];
        // 设置填充的路径
        CGContextFillPath(context);
        
    }else{
        // 创建一个贝塞尔曲线句柄
        NSLog(@"bezierheiiii==%f",self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPath];
        // 初始化该path到一个初始点
        [path moveToPoint:CGPointMake(0, 0)];
        //    // 添加一条直线，从初始点到该函数指定的坐标点
        [path addLineToPoint:CGPointMake(0, self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(200,  self.bounds.size.height)];
        [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(20,self.bounds.size.height)];
        
        // 关闭该path
        [path closePath];
        // 创建描边（Quartz）上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 将此path添加到Quartz上下文中
        CGContextAddPath(context, path.CGPath);
        // 设置本身颜色
        [[UIColor whiteColor] set];
        // 设置填充的路径
        CGContextFillPath(context);
        
    }
    
}
#pragma mark --因为我加了这一层view在tableview的上面，所以要把触摸事件给tableview
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    else {
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                return view;
            }
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
