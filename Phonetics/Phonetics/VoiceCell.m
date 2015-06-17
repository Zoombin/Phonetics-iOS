//
//  VoiceCell.m
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "VoiceCell.h"

@implementation VoiceCell {
    NSArray *voices;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showVoices:(NSArray *)arr {
    voices = arr;
    CGFloat offSet = 0;
    for (int i = 0; i < [arr count]; i ++) {
        VoiceItem *item = arr[i];
        UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [voiceBtn setFrame:CGRectMake(5 * (i + 1) + (50 * i), 5, 50, 50)];
        [voiceBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        voiceBtn.tag = i;
        [voiceBtn setBackgroundColor:[UIColor lightGrayColor]];
        [voiceBtn setBackgroundImage:[UIImage imageNamed:item.imgName] forState:UIControlStateNormal];
        [_voicesScrollView addSubview:voiceBtn];
        offSet = CGRectGetMaxX(voiceBtn.frame);
    }
    [_voicesScrollView setContentSize:CGSizeMake(offSet, 0)];
}

- (void)buttonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceButtonClicked:)]) {
        [self.delegate voiceButtonClicked:voices[[sender tag]]];
    }
}


@end
