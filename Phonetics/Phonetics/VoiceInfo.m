//
//  VoiceInfo.m
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "VoiceInfo.h"
#import "VoiceItem.h"

@implementation VoiceInfo

- (id)initWithAttribte:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.describeInfo = dict[@"describe"];
        if ([dict[@"voices"] isKindOfClass:[NSArray class]]) {
            self.voices = [VoiceItem createWithArray:dict[@"voices"]];
        }
    }
    return self;
}

+ (NSArray *)createWithArray:(NSArray *)arr {
    NSMutableArray *voiceArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arr count]; i++) {
        VoiceInfo *info = [[VoiceInfo alloc] initWithAttribte:arr[i]];
        [voiceArray addObject:info];
    }
    return voiceArray;
}
@end
