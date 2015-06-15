//
//  VoiceItem.m
//  Phonetics
//
//  Created by 颜超 on 15/6/7.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "VoiceItem.h"

@implementation VoiceItem

- (id)initWithAttribte:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.voiceFemaleLong = dict[@"long_female"];
        self.startFemaleTime = dict[@"stime_female"];
        self.endFemaleTime = dict[@"etime_female"];
        self.voiceMaleLong = dict[@"long_male"];
        self.startMaleTime = dict[@"stime_male"];
        self.endMaleTime = dict[@"etime_male"];
        self.picsFront = dict[@"pics_front"];
        self.picsSides = dict[@"pics_side"];
        self.imgName = dict[@"img"];
        self.describeText = dict[@"describe"];
        self.stepCount = dict[@"step_count"];
        self.stepDescribes = dict[@"step_describes"];
        self.stepTypes = dict[@"step_types"];
        self.similar = dict[@"similar"];
        self.similarCount = dict[@"similar_count"];
        self.examples = dict[@"examples"];
        self.examplesCount = dict[@"examples_count"];
        self.examplesYB = dict[@"examples_yb"];
        self.similarYB = dict[@"similar_yb"];
        self.examplesRead = dict[@"examples_read"];
        self.examplesSlowRead = dict[@"examples_slow_read"];
        self.similarRead = dict[@"similar_read"];
        self.similarSlowRead = dict[@"similar_slow_read"];
    }
    return self;
}

+ (NSArray *)createWithArray:(NSArray *)arr {
    NSMutableArray *voiceArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arr count]; i++) {
        VoiceItem *info = [[VoiceItem alloc] initWithAttribte:arr[i]];
        [voiceArray addObject:info];
    }
    return voiceArray;
}
@end
