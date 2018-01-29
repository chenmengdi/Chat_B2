//
//  ChatModel.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/4.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

+(instancetype)messageWithDict:(NSDictionary *)dict{
    
    
    ChatModel *model = [[ChatModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return  model;
    
}

@end
