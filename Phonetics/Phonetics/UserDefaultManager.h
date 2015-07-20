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
#define CHECK_IN @"check_in"

@interface UserDefaultManager : NSObject

//获取用户保存的信息
+ (NSString *)getUserSaveValues;
+ (void)saveValues:(NSString *)str;

//是否已经分享了微信（不分享不能用哦）
+ (BOOL)hasShareWeChat;
+ (void)saveHasShare:(BOOL)hasShare;

+ (void)saveCheckInDate:(NSDate *)date;
+ (NSString *)checkInTimes;

@end
