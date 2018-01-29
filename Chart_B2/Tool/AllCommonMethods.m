//
//  AllCommonMethods.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/6.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "AllCommonMethods.h"

@implementation AllCommonMethods

//获取当前的时间
+ (NSString *)getNowM_Date{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"aa HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
@end
