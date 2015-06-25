//
//  CompareViewController.m
//  Phonetics
//
//  Created by yc on 15-6-24.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "CompareViewController.h"
#import "VoiceSelectViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CompareViewController ()

@end

@implementation CompareViewController {
    AVAudioPlayer *audioPlayer;
    VoiceItem *item1;
    VoiceItem *item2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音标对比";
    [self changeViewAndView2Size];
    // Do any additional setup after loading the view from its nib.
}

- (void)changeViewAndView2Size {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewHeight = (screenHeight - 40) / 2;
    _voiceView1.frame = CGRectMake(0, 0, screenWidth, viewHeight);
    _voiceView2.frame = CGRectMake(0, CGRectGetMaxY(_voiceView1.frame), screenWidth, viewHeight);
    
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)preBtnClicked:(id)sender {
    
}

- (IBAction)nextBtnClicked:(id)sender {
    
}

- (IBAction)playVoiceButton1:(id)sender {
    if (item1) {
        [self playVoice:item1 isUp:YES];
    }
}

- (IBAction)playVoiceButton2:(id)sender {
    if (item2) {
        [self playVoice:item2 isUp:NO];
    }
}

- (void)loadUpData {
    NSArray *imageNames = [item1.picsFront componentsSeparatedByString:@","];
    if ([imageNames count] > 0) {
        _gifImageView1.image = [UIImage imageNamed:imageNames[0]];
    }
    [_voiceButton1 setBackgroundImage:[UIImage imageNamed:item1.imgName] forState:UIControlStateNormal];
}

- (void)loadDownData {
    NSArray *imageNames = [item2.picsFront componentsSeparatedByString:@","];
    if ([imageNames count] > 0) {
        _gifImageView2.image = [UIImage imageNamed:imageNames[0]];
    }
    [_voiceButton2 setBackgroundImage:[UIImage imageNamed:item2.imgName] forState:UIControlStateNormal];
}

- (void)voiceSelected:(VoiceItem *)item andIsUp:(BOOL)isUp {
    NSLog(@"%@", item.name);
    if (isUp) {
        item1 = item;
        [self loadUpData];
    } else {
        item2 = item;
        [self loadDownData];
    }
}

- (IBAction)selectVoiceUpBtnClicked:(id)sender {
    VoiceSelectViewController *selectViewController = [VoiceSelectViewController new];
    selectViewController.delegate = self;
    selectViewController.isUp = YES;
    selectViewController.basicArray = _basicArray;
    [self.navigationController pushViewController:selectViewController animated:YES];
}

- (IBAction)selectVoiceDownBtnClicked:(id)sender {
    VoiceSelectViewController *selectViewController = [VoiceSelectViewController new];
    selectViewController.delegate = self;
    selectViewController.isUp = NO;
    selectViewController.basicArray = _basicArray;
    [self.navigationController pushViewController:selectViewController animated:YES];
}

- (IBAction)maleOrFemaleBtn1Clicked:(id)sender {
    _selectMOrFBtn1.selected = !_selectMOrFBtn1.selected;
}

- (IBAction)maleOrFemaleBtn2Clicked:(id)sender {
    _selectMOrFBtn2.selected = !_selectMOrFBtn2.selected;
}

- (void)playVoice:(VoiceItem *)item isUp:(BOOL)isUp{
    float stime = 0.0f;
    float vLong = 0.0f;
    UIButton *maleOrFemaleBtn = nil;
    if (isUp) {
        maleOrFemaleBtn = _selectMOrFBtn1;
    } else {
        maleOrFemaleBtn = _selectMOrFBtn2;
    }
    if (!maleOrFemaleBtn.selected) {
        stime = [item.startFemaleTime floatValue];
        vLong = [item.voiceFemaleLong floatValue];
    } else {
        stime = [item.startMaleTime floatValue];
        vLong = [item.voiceMaleLong floatValue];
    }
    NSString *musicUrl = [[NSBundle mainBundle] pathForResource:@"bgmusic" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicUrl];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil
                   ];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1;
    audioPlayer.currentTime = stime;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    [self changeImageView:item andLong:vLong isUp:isUp];
    [self performSelector:@selector(playStop) withObject:nil afterDelay:vLong];
}

- (void)playStop {
    [audioPlayer stop];
}

- (void)changeImageView:(VoiceItem *)item andLong:(float)vLong isUp:(BOOL)isUp
{
    if (item.picsFront.length == 0) {
        return;
    }
    NSArray *imageName = [item.picsFront componentsSeparatedByString:@","];
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [imageName count]; i++) {
        UIImage *img = [UIImage imageNamed:imageName[i]];
        [imgArray addObject:img];
    }
    if ([imgArray count] == 0) {
        return;
    }
    UIImageView *imgView = nil;
    if (isUp) {
        imgView = _gifImageView1;
    } else {
        imgView = _gifImageView2;
    }
    //imageView的动画图片是数组images
    imgView.animationImages = imgArray;
    //按照原始比例缩放图片，保持纵横比
    imgView.contentMode = UIViewContentModeScaleToFill;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    imgView.animationDuration = vLong;
    //动画的重复次数，想让它无限循环就赋成0
    imgView.animationRepeatCount = 1;
    //开始动画
    [imgView startAnimating];
}

@end
