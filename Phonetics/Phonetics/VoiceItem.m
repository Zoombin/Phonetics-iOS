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
        self.voiceLong = dict[@"long"];
        self.startTime = dict[@"stime"];
        self.endTime = dict[@"etime"];
        self.imgName = dict[@"img"];
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
