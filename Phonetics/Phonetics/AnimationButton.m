//
//  AnimationButton.m
//  Phonetics
//
//  Created by 颜超 on 15/7/26.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "AnimationButton.h"

@implementation AnimationButton {
    NSTimer *timer;
    BOOL shouldAdd;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)stop {
    [timer invalidate];
    timer = nil;
}

- (void)startAnimation {
    shouldAdd = YES;
    [self changeAlpha];
}

- (void)changeAlpha {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(change) userInfo:nil repeats:YES];
}

- (void)change {
    CGFloat alpha = self.alpha;
    alpha = alpha * 100;
    if (shouldAdd) {
        alpha += 5;
    }
    if (!shouldAdd) {
        alpha -= 5;
    }
    
    if (alpha < 20) {
        shouldAdd = YES;
        alpha = 20;
    }
    if (alpha > 100) {
        shouldAdd = NO;
        alpha = 100;
    }
    
    self.alpha = alpha / 100;
}

@end
