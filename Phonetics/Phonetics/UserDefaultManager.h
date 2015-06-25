//
//  UserDefaultManager.h
//  Phonetics
//
//  Created by yc on 15-6-25.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMPARE_VALUES  @"compare_values"

@interface UserDefaultManager : NSObject


+ (NSString *)getUserSaveValues;
+ (void)saveValues:(NSString *)str;

@end
