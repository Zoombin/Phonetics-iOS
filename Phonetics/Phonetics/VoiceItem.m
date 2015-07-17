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
        self.name = dict[@"name"];  //名字
        self.voiceFemaleLong = dict[@"long_female"]; //音标读音长度(女)
        self.startFemaleTime = dict[@"stime_female"]; //音标开始时间(女)
        self.endFemaleTime = dict[@"etime_female"]; //音标结束时间(女)
        self.voiceMaleLong = dict[@"long_male"]; //音标读音长度(男)
        self.startMaleTime = dict[@"stime_male"]; //音标开始时间(男)
        self.endMaleTime = dict[@"etime_male"]; //音标结束时间(男)
        self.picsFront = dict[@"pics_front"]; //音标正面动画，用逗号隔开
        self.picsSides = dict[@"pics_side"]; //音标侧面动画,用逗号隔开，每张侧面图片加上前缀c
        self.imgName = dict[@"img"]; //音标的图片
        self.describeText = dict[@"describe"]; //音标的描述
        self.stepCount = dict[@"step_count"]; //分步的数量
        self.stepDescribes = dict[@"step_describes"]; //分步的描述,用&&隔开，如果有多个步骤的话
        self.stepTypes = dict[@"step_types"]; //分步类型，如果有3个，就1，2，3
        self.stepVoices = dict[@"step_voices"]; //分步的读音，不同步骤用&&隔开，每步是这样的，女开始时间,持续时间,男开始时间,持续时间
        self.stepPics = dict[@"step_pics"]; //分步播放的图片，不同步骤用&&隔开，同一步的图片用逗号隔开。
        self.similar = dict[@"similar"]; //相似单词，用逗号隔开
        self.similarCount = dict[@"similar_count"]; //相似单词的数量
        self.examples = dict[@"examples"]; //举列单词，用逗号隔开
        self.examplesCount = dict[@"examples_count"]; //举列单词的数量
        self.examplesYB = dict[@"examples_yb"]; //举列单词的音标,不同单词用&&隔开，同一个单词用逗号隔开
        self.similarYB = dict[@"similar_yb"];  //相似单词的音标,不同单词用&&隔开，同一个单词用逗号隔开
        self.examplesRead = dict[@"examples_read"]; //相似单词的正常速读音,不同单词用&&隔开，同一个单词，是这样的女开始时间,持续时间,男开始时间,持续时间
        self.examplesSlowRead = dict[@"examples_slow_read"]; //举列单词的慢速读音,不同单词用&&隔开，同一个单词，是这样的女开始时间,持续时间,男开始时间,持续时间
        self.examplesPics = dict[@"examples_pics"]; //举列单词的图片，不同单词用&&隔开，同一个单词用逗号隔开
        self.similarRead = dict[@"similar_read"]; //相似单词的正常速读音,不同单词用&&隔开，同一个单词，是这样的女开始时间,持续时间,男开始时间,持续时间
        self.similarSlowRead = dict[@"similar_slow_read"]; //相似单词的慢速读音,不同单词用&&隔开，同一个单词，是这样的女开始时间,持续时间,男开始时间,持续时间
        self.similarYBName = dict[@"similar_yb_name"]; //相似的音标名称，这个是在界面上显示的，不同单词用&&隔开
        self.examplesYBName = dict[@"examples_yb_name"]; //举列的音标名称，这个是在界面上显示的，不同单词用&&隔开
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
