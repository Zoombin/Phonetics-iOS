//
//  UserDefaultManager.m
//  Phonetics
//
//  Created by yc on 15-6-25.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

+ (NSString *)getUserSaveValues {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *values = [userDefaults objectForKey:COMPARE_VALUES];
    if (values) {
        return values;
    }
    return @"";
}

+ (void)saveValues:(NSString *)str {
    if ([str length] > 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:str forKey:COMPARE_VALUES];
        [userDefaults synchronize];
    }
}

+ (BOOL)hasShareWeChat {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hasShare = [userDefaults objectForKey:HAS_SHARE];
    if (hasShare) {
        return [hasShare boolValue];
    }
    //TODO:这边改成YES的话，就不需要分享就能点进阶了。
    return YES;
}

+ (void)saveHasShare:(BOOL)hasShare {
    if (hasShare) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:HAS_SHARE];
        [userDefaults synchronize];
    }
}

+ (void)saveCheckInDate:(NSDate *)date {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [userDefaults objectForKey:CHECK_IN];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM"];
    NSString *month = [formatter1 stringFromDate:date];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *currentdate = [formatter2 stringFromDate:date];
    if (dict) {
        NSString *timesStr = dict[@"times"];
        NSString *monthStr = dict[@"month"];
        NSString *lastdateStr = dict[@"lastdate"];
        if ([monthStr isEqualToString:month]) {
            if ([lastdateStr isEqualToString:currentdate]) {
                //今天已经签到过了
                return;
            } else {
                //今天还没签到
                NSInteger times = [timesStr integerValue] + 1;
                dict[@"times"] = [NSString stringWithFormat:@"%ld", times];
                dict[@"lastdate"] = currentdate;
            }
        } else {
            //新的一个月开始啦
            dict[@"times"] = @"1";
            dict[@"lastdate"] = currentdate;
            dict[@"month"] = month;
        }
    } else {
        //还没签到过
        NSMutableDictionary *checkInDict = [[NSMutableDictionary alloc] init];
        checkInDict[@"times"] = @"1";
        checkInDict[@"month"] = month;
        checkInDict[@"lastdate"] = currentdate;
        [userDefaults setObject:checkInDict forKey:CHECK_IN];
        [userDefaults synchronize];
    }
}

+ (NSString *)checkInTimes {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [userDefaults objectForKey:CHECK_IN];
    if (dict) {
        return dict[@"times"];
    }
    return @"";
}

+ (BOOL)isFirstLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *firstLaunch = [userDefaults objectForKey:FIRST_LAUNCH];
    if (firstLaunch) {
        return [firstLaunch boolValue];
    }
    return NO;
}

+ (void)saveFirstLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"1" forKey:FIRST_LAUNCH];
    [userDefaults synchronize];
}

@end
