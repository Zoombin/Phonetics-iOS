//
//  VoiceDetailViewController.m
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "VoiceDetailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VoiceDetailViewController ()

@end

@implementation VoiceDetailViewController {
    AVAudioPlayer *audioPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [_voiceButton setBackgroundImage:[UIImage imageNamed:_item.imgName] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:223.0/255.0 blue:219.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)playVoice:(VoiceItem *)item {
    float stime = [item.startTime floatValue];
    //    float etime = [item.endTime floatValue];
    float vLong = [item.voiceLong floatValue];
    NSString *musicUrl = [[NSBundle mainBundle] pathForResource:@"bgmusic" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicUrl];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil
                   ];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1;
    audioPlayer.currentTime = stime;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    [self performSelector:@selector(playStop) withObject:nil afterDelay:vLong];
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)voiceButtonClick:(id)sender {
    [self playVoice:_item];
}

- (void)playStop {
    [audioPlayer stop];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
