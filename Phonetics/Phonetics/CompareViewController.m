//
//  CompareViewController.m
//  Phonetics
//
//  Created by yc on 15-6-24.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "CompareViewController.h"
#import "VoiceSelectViewController.h"
#import "UserDefaultManager.h"
#import <AVFoundation/AVFoundation.h>
#import "TimeUtil.h"

@interface CompareViewController ()

@end


@implementation CompareViewController {
    AVAudioPlayer *audioPlayer;
    NSMutableArray *compares;
    int currentIndex;
    VoiceItem *item1;
    VoiceItem *item2;
    BOOL isEdit;
    BOOL isReading;
}

- (void)initAudio {
    NSString *musicUrl = [[NSBundle mainBundle] pathForResource:@"sy3.1" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicUrl];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil
                   ];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1;
}

- (void)addGod {
//    CGFloat width = _voiceView1.frame.size.width;
//    CGFloat height = _voiceView1.frame.size.height;
//    
//    CGFloat photoWidth = 960;
//    CGFloat photoHeight = 744;
//    
//    CGFloat newWidth = width;
//    CGFloat newHeight = (newWidth * photoHeight) / photoWidth;
//    if (newHeight > height) {
//        newWidth = (photoWidth * height) / photoHeight;
//        newHeight = height;
//    }
//    
//    CGFloat startX = newWidth < width ? (width - newWidth) : 0;
//    _gifImageView1.frame = CGRectMake(startX, 0, newWidth, newHeight);
    [_voiceView1.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0 alpha:1.0].CGColor];
    [_voiceView1.layer setBorderWidth:1.0];
    
    
//    _gifImageView2.frame = CGRectMake(startX, 0, newWidth, newHeight);
    [_voiceView2.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0 alpha:1.0].CGColor];
    [_voiceView2.layer setBorderWidth:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAudio];
    self.title = @"音标对比";
    [self loadJPVoices];
    isEdit = NO;
    compares = [[NSMutableArray alloc] init];
    currentIndex = 0;
    [_voiceButton1.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0 alpha:1.0].CGColor];
    [_voiceButton1.layer setBorderWidth:1.0];
    
    [_voiceButton2.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0 alpha:1.0].CGColor];
    [_voiceButton2.layer setBorderWidth:1.0];
    
     [_segmentedControl1 addTarget:self action:@selector(valueChanged1) forControlEvents:UIControlEventValueChanged];
     [_segmentedControl2 addTarget:self action:@selector(valueChanged2) forControlEvents:UIControlEventValueChanged];
    [self changeViewAndView2Size];
    [self initData];
}

- (void)valueChanged1 {
    if (_segmentedControl1.selectedSegmentIndex == 0) {
        NSArray *imageName = [item1.picsFront componentsSeparatedByString:@","];
        if ([imageName count] >= 4) {
            _gifImageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", imageName[3]]];
        }
    } else {
        NSArray *imageName = [item1.picsFront componentsSeparatedByString:@","];
        if ([imageName count] >= 4) {
            _gifImageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@.jpg", imageName[3]]];
        }
    }
}

- (void)valueChanged2 {
    if (_segmentedControl2.selectedSegmentIndex == 0) {
        NSArray *imageName = [item2.picsFront componentsSeparatedByString:@","];
        if ([imageName count] >= 4) {
            _gifImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", imageName[3]]];
        }
    } else {
        NSArray *imageName = [item2.picsFront componentsSeparatedByString:@","];
        if ([imageName count] >= 4) {
            _gifImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@.jpg", imageName[3]]];
        }
    }
}


- (void)initData {
    NSString *values = [UserDefaultManager getUserSaveValues];
    NSArray *compareArr = [values componentsSeparatedByString:@"&&"];
    if ([compareArr count] > 0 && [values length] > 0) {
        if ([compares count] == 0) {
            [compares addObjectsFromArray:compareArr];
        }
        NSArray *ybs = [compares[0] componentsSeparatedByString:@","];
        if ([ybs count] > 0) {
            item1 = [self searchVoiceByName:ybs[0]];
            item2 = [self searchVoiceByName:ybs[1]];
            [self loadUpData];
            [self loadDownData];
        }
    } else {
        isEdit = YES;
    }
}

- (void)loadLocalData {
    if ([compares count] == 0) {
        return;
    }
    NSArray *ybs = [compares[currentIndex] componentsSeparatedByString:@","];
    if ([ybs count] > 0) {
        item1 = [self searchVoiceByName:ybs[0]];
        item2 = [self searchVoiceByName:ybs[1]];
        [self loadUpData];
        [self loadDownData];
    }
}

- (void)changeViewAndView2Size {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewHeight = (screenHeight - 40) / 2;
    _voiceView1.frame = CGRectMake(0, 0, screenWidth, viewHeight);
    _voiceView2.frame = CGRectMake(0, CGRectGetMaxY(_voiceView1.frame), screenWidth, viewHeight);
    [self addGod];
}

- (IBAction)backBtnClicked:(id)sender {
    //编辑状态，并且上下都有值，就保存～
    if (isEdit && item1 && item2) {
        if (currentIndex <= [compares count] - 1) {
            NSString *value = [NSString stringWithFormat:@"%@,%@", item1.name, item2.name];
            if ([compares count] > 0) {
                [compares replaceObjectAtIndex:currentIndex withObject:value];
            } else {
                [compares addObject:value];
            }
        } else {
            NSString *value = [NSString stringWithFormat:@"%@,%@", item1.name, item2.name];
            [compares addObject:value];
        }
    }
    if ([compares count] > 0) {
        NSMutableString *str = [@"" mutableCopy];
        for (int i = 0; i < [compares count]; i++) {
            NSString *value = compares[i];
            [str appendFormat:@"%@%@", value, i + 1 == [compares count] ? @"" : @"&&"];
        }
        [UserDefaultManager saveValues:str];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)preBtnClicked:(id)sender {
    BOOL isFirst = NO;
    currentIndex--;
    if (currentIndex < 0) {
        isFirst = YES;
        currentIndex = 0;
    }
    _segmentedControl1.selectedSegmentIndex = 1;
    _segmentedControl2.selectedSegmentIndex = 1;
    if (isEdit) {
        if (item1 && item2) {
            if (isFirst) {
                [self saveCurrent:0];
            } else {
                if (currentIndex + 1 <= [compares count] - 1) {
                    [self saveCurrent:currentIndex + 1];
                } else {
                    NSString *value = [NSString stringWithFormat:@"%@,%@", item1.name, item2.name];
                    [compares addObject:value];
                }
            }
        }
        if ([compares count] != 0) {
            isEdit = NO;
        }
    }
    [self clearAll];
    [self loadLocalData];
}

- (IBAction)nextBtnClicked:(id)sender {
    if (item1 == nil && item2) {
        return;
    }
    if (item1 && item2 == nil) {
        return;
    }
    if (item1 == nil && item2 == nil) {
        return;
    }
    _segmentedControl1.selectedSegmentIndex = 1;
    _segmentedControl2.selectedSegmentIndex = 1;
    currentIndex++;
    [_voiceButton1 setTitle:@"点击此处" forState:UIControlStateNormal];
    [_voiceButton2 setTitle:@"点击此处" forState:UIControlStateNormal];
    if ([compares count] > currentIndex) {
        if (currentIndex - 1 <= [compares count] - 1 && isEdit) {
            [self saveCurrent:currentIndex - 1];
        }
        [self clearAll];
        [self loadLocalData];
    } else {
        if (isEdit) {
            if (currentIndex - 1 <= [compares count] - 1) {
                [self saveCurrent:currentIndex - 1];
            } else {
                NSString *value = [NSString stringWithFormat:@"%@,%@", item1.name, item2.name];
                [compares addObject:value];
            }
            [self clearAll];
            return;
        }
        [self clearAll];
        isEdit = YES;
    }
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

- (void)clearAll {
    item1 = nil;
    item2 = nil;
    _gifImageView1.image = nil;
    [_voiceButton1 setBackgroundImage:nil forState:UIControlStateNormal];
    
    _gifImageView2.image = nil;
    [_voiceButton2 setBackgroundImage:nil forState:UIControlStateNormal];
}

- (void)loadUpData {
    NSArray *imageNames = [item1.picsFront componentsSeparatedByString:@","];
    if ([imageNames count] >= 4) {
        [_voiceButton1 setTitle:@"" forState:UIControlStateNormal];
        _gifImageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@.jpg", imageNames[3]]];
    }
    if ([item1.imgName rangeOfString:@"JP"].location != NSNotFound) {
        [_voiceButton1 setBackgroundImage:nil forState:UIControlStateNormal];
        [_voiceButton1 setTitle:item1.name forState:UIControlStateNormal];
    } else {
       [_voiceButton1 setBackgroundImage:[UIImage imageNamed:item1.imgName] forState:UIControlStateNormal];
    }
}

- (void)loadDownData {
    NSArray *imageNames = [item2.picsFront componentsSeparatedByString:@","];
    if ([imageNames count] >= 4) {
        [_voiceButton2 setTitle:@"" forState:UIControlStateNormal];
        _gifImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@.jpg", imageNames[3]]];
    }
    if ([item2.imgName rangeOfString:@"JP"].location != NSNotFound) {
        [_voiceButton2 setBackgroundImage:nil forState:UIControlStateNormal];
        [_voiceButton2 setTitle:item2.name forState:UIControlStateNormal];
    } else {
        [_voiceButton2 setBackgroundImage:[UIImage imageNamed:item2.imgName] forState:UIControlStateNormal];
    }
}

- (void)voiceSelected:(VoiceItem *)item andIsUp:(BOOL)isUp {
    isEdit = YES;
    if (isUp) {
        [_voiceButton1 setTitle:@"" forState:UIControlStateNormal];
        item1 = item;
        [self loadUpData];
    } else {
        [_voiceButton2 setTitle:@"" forState:UIControlStateNormal];
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
    if (isReading) {
        return;
    }
    float stime = 0.0f;
    float vLong = 0.0f;
    UIButton *maleOrFemaleBtn = nil;
    if (isUp) {
        maleOrFemaleBtn = _selectMOrFBtn1;
    } else {
        maleOrFemaleBtn = _selectMOrFBtn2;
    }
    if (!maleOrFemaleBtn.selected) {
        stime = [TimeUtil getPlayTime:item.startFemaleTime];
        vLong = [TimeUtil getPlayTime:item.voiceFemaleLong];
    } else {
        stime = [TimeUtil getPlayTime:item.startMaleTime];
        vLong = [TimeUtil getPlayTime:item.voiceMaleLong];
    }
    if (![self checkIsJapan:item.name]) {
        audioPlayer.currentTime = stime;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }
    isReading = YES;
    [self changeImageView:item andLong:vLong isUp:isUp];
    [self performSelector:@selector(playStop) withObject:nil afterDelay:vLong];
}

- (void)playStop {
    [audioPlayer stop];
    isReading = NO;
}

- (void)changeImageView:(VoiceItem *)item andLong:(float)vLong isUp:(BOOL)isUp
{
    if (item.picsFront.length == 0) {
        return;
    }

    BOOL isSide = _segmentedControl2.selectedSegmentIndex == 1;
    if (isUp) {
        isSide = _segmentedControl1.selectedSegmentIndex == 1;
    }
    NSArray *imageName = [item.picsFront componentsSeparatedByString:@","];
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [imageName count]; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", isSide ? @"c" : @"", imageName[i]]];
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

- (VoiceItem *)searchVoiceByName:(NSString *)voice {
    for (VoiceInfo *info in _basicArray) {
        for (VoiceItem *item in info.voices) {
            if ([item.name isEqualToString:voice]) {
                return item;
            }
        }
    }
    return nil;
}

- (void)saveCurrent:(NSInteger)index {
     NSString *value = [NSString stringWithFormat:@"%@,%@", item1.name, item2.name];
    if ([compares count] == 0) {
        [compares addObject:value];
    } else {
        [compares replaceObjectAtIndex:index withObject:value];
    }
    isEdit = NO;
}

- (BOOL)checkIsJapan:(NSString *)ybName {
    NSArray *jpNames = @[@"ア", @"イ", @"ウ", @"エ", @"オ"];
    for (int i = 0; i < [jpNames count]; i++) {
        NSString *name = jpNames[i];
        if ([name isEqualToString:ybName]) {
            return YES;
        }
    }
    return NO;
}

- (void)loadJPVoices {
    VoiceInfo *info = [[VoiceInfo alloc] init];
    info.title = @"日语发音";
    NSMutableArray *voice = [[NSMutableArray alloc] init];
    NSArray *jpNames = @[@"ア", @"イ", @"ウ", @"エ", @"オ"];
    NSArray *ybNames = @[@"ɑ", @"j", @"ʊ", @"æ", @"ʊ"];
    for (int i = 0; i < [ybNames count]; i++) {
        NSString *yb = ybNames[i];
        VoiceItem *tmpItem = [self searchVoiceByName:yb];
        if (tmpItem) {
            VoiceItem *item = [[VoiceItem alloc] init];
            item.name = jpNames[i];
            item.startFemaleTime = tmpItem.startFemaleTime;
            item.startMaleTime = tmpItem.startMaleTime;
            item.endFemaleTime = tmpItem.endFemaleTime;
            item.endMaleTime = tmpItem.endMaleTime;
            item.voiceFemaleLong = tmpItem.voiceFemaleLong;
            item.voiceMaleLong = tmpItem.voiceMaleLong;
            item.imgName = [NSString stringWithFormat:@"JP%@", jpNames];
            item.picsFront = tmpItem.picsFront;
            item.picsSides = tmpItem.picsSides;
            [voice addObject:item];
        }
    }
    info.voices = voice;
    NSMutableArray *allArray = [[NSMutableArray alloc] initWithArray:_basicArray];
    [allArray addObject:info];
    _basicArray = allArray;
}
@end
