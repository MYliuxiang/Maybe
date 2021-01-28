//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (text.length == 0) {
        return;
    }
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //    hud.labelText = text; //单行显示
    
//    hud.detailsLabelText = text;//实现多行显示
    hud.detailsLabel.text = text;
    // 设置图片
    if (![icon isEqualToString:@""]) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    }
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    //可以设置显示字体大小,一般用默认字体
    //     hud.labelFont = [UIFont systemFontOfSize:15]; //Johnkui - added
    hud.detailsLabel.font = [UIFont systemFontOfSize:14]; //Johnkui - added
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
}

#pragma mark 显示错误信息

+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@""/*@"error.png"*/ view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@""/*@"success.png"*/ view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    [hud hideAnimated:YES afterDelay:3];
    return hud;
}

+ (MBProgressHUD *)showBottomMessag:(NSString *)message
{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);

    [hud hideAnimated:YES afterDelay:3];
    return hud;
    
}

@end
