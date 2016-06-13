//
//  UserDefaultManager.m
//  Phonetics
//
//  Created by yc on 15-6-25.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "UserDefaultManager.h"

//如果是debug点话，就改为YES,这样点话，就不需要分享或者评分，就能使用全部功能了～
//#define IS_DEBUG    YES
#define IS_DEBUG    NO

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
    return IS_DEBUG;
}

+ (void)saveHasShare:(BOOL)hasShare {
    if (hasShare) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:HAS_SHARE];
        [userDefaults synchronize];
    }
}

//是否已经评分过了
+ (BOOL)hasScoreAlready {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hasScore = [userDefaults objectForKey:HAS_SCORE];
    if (hasScore) {
        return [hasScore boolValue];
    }
    //TODO:这边改成YES的话，就不需要评价就能点对比了。
    return IS_DEBUG;
}

+ (void)saveHasScore:(BOOL)hasScore {
    if (hasScore) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:HAS_SCORE];
        [userDefaults synchronize];
    }
}

+ (BOOL)hasShowScoreTen {
    if ([self hasScoreAlready]) {
        return true;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hasScore = [userDefaults objectForKey:[NSString stringWithFormat:@"%@%@Ten", HAS_SCORE, ZM_VERSION]];
    if (hasScore) {
        return [hasScore boolValue];
    }
    //TODO:这边改成YES的话，就不需要评价就能点对比了。
    return IS_DEBUG;
}

+ (void)saveHasShowScoreTen:(BOOL)hasScore {
    if (hasScore) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:[NSString stringWithFormat:@"%@%@Ten", HAS_SCORE, ZM_VERSION]];
        [userDefaults synchronize];
    }
}

+ (BOOL)hasShowScoreAll {
    if ([self hasScoreAlready]) {
        return true;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hasScore = [userDefaults objectForKey:[NSString stringWithFormat:@"%@%@All", HAS_SCORE, ZM_VERSION]];
    if (hasScore) {
        return [hasScore boolValue];
    }
    //TODO:这边改成YES的话，就不需要评价就能点对比了。
    return IS_DEBUG;
}

+ (void)saveHasShowScoreAll:(BOOL)hasScore {
    if (hasScore) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:[NSString stringWithFormat:@"%@%@All", HAS_SCORE, ZM_VERSION]];
        [userDefaults synchronize];
    }
}

+ (void)saveCheckInDate:(NSDate *)date {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:CHECK_IN];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:dict];
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
                infoDict[@"times"] = [NSString stringWithFormat:@"%ld", times];
                infoDict[@"month"] = monthStr;
                infoDict[@"lastdate"] = currentdate;
                [userDefaults setObject:infoDict forKey:CHECK_IN];
                [userDefaults synchronize];
            }
        } else {
            //新的一个月开始啦
            infoDict[@"times"] = [NSString stringWithFormat:@"1"];
            infoDict[@"lastdate"] = currentdate;
            infoDict[@"month"] = month;
            [userDefaults setObject:infoDict forKey:CHECK_IN];
            [userDefaults synchronize];
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
