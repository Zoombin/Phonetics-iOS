//
//  UserDefaultManager.h
//  Phonetics
//
//  Created by yc on 15-6-25.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMPARE_VALUES  @"compare_values"
#define HAS_SHARE @"has_share"

@interface UserDefaultManager : NSObject


+ (NSString *)getUserSaveValues;
+ (void)saveValues:(NSString *)str;
+ (BOOL)hasShareWeChat;
+ (void)saveHasShare:(BOOL)hasShare;

@end
