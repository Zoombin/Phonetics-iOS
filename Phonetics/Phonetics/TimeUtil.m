//
//  TimeUtil.m
//  Phonetics
//
//  Created by yc on 15-6-26.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil

+ (float)getPlayTime:(NSString *)playTime {
    NSMutableString *minStr = [@"" mutableCopy];
    if ([playTime rangeOfString:@":"].location != NSNotFound) {
        for (int i = 0; playTime.length; i++) {
            NSString *c = [NSString stringWithFormat:@"%c", [playTime characterAtIndex:i]];
             [minStr appendString:c];
            if ([c isEqualToString:@":"]) {
                playTime = [playTime stringByReplacingOccurrencesOfString:minStr withString:@""];
                break;
            }
           
        }
    }
    float min = [[minStr stringByReplacingOccurrencesOfString:@":" withString:@""] floatValue];
    float minSecond = min * 60.0f;
    float second = [playTime floatValue];
    float time = minSecond + second;
    return time;
}
@end
