//
//  VoiceDetailViewController.m
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "VoiceDetailViewController.h"
#import "StepCell.h"
#import <AVFoundation/AVFoundation.h>

@interface VoiceDetailViewController ()

@end

@implementation VoiceDetailViewController {
    AVAudioPlayer *audioPlayer;
    NSMutableArray *bottomButtons;
    NSInteger count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    self.title = @"详情";
    bottomButtons = [[NSMutableArray alloc] init];
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    bannerView.delegate = self;
    [_bottomView addSubview:bannerView];
    
    [_voiceButton setBackgroundImage:[UIImage imageNamed:_item.imgName] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:223.0/255.0 blue:219.0/255.0 alpha:1.0];
     NSArray *imageName = [_item.picsFront componentsSeparatedByString:@","];
    if ([imageName count] > 0) {
        _gifImageView.image = [UIImage imageNamed:imageName[0]];
    }
    _describeIcon.image = [UIImage imageNamed:_item.imgName];
    _describeTextView.text = _item.describeText;
    [self initBottomButton];
    [self loadStepInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadStepInfo {
    if (_item.stepCount) {
        count = [_item.stepCount integerValue];
        [_stepTableView reloadData];
    }
}

- (void)initBottomButton {
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / 4;
    CGFloat buttonHeight = _bottomView.frame.size.height / 2;
    NSArray *names = @[@"描述", @"基础", @"举列", @"相似"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight)];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        [_bottomView addSubview:btn];
        [bottomButtons addObject:btn];
    }
    [self buttonClicked:bottomButtons[0]];
}

- (void)buttonClicked:(id)sender {
    [self allUnClicked];
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    switch ([sender tag]) {
        case 0:
            _describeView.hidden = NO;
            break;
        case 1:
            _stepView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)allUnClicked {
    for (UIButton *btn in bottomButtons) {
        btn.selected = NO;
    }
    _describeView.hidden = YES;
    _stepView.hidden = YES;
}

- (IBAction)maleOrFemaleBtnClicked:(id)sender {
    _selectMaleOrFemaleBtn.selected = !_selectMaleOrFemaleBtn.selected;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)playVoice:(VoiceItem *)item {
    float stime = 0.0f;
    float vLong = 0.0f;
    if (!_selectMaleOrFemaleBtn.selected) {
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
    [self changeImageView:item andLong:vLong];
    [self performSelector:@selector(playStop) withObject:nil afterDelay:vLong];
}

- (void)changeImageView:(VoiceItem *)item andLong:(float)vLong
{
    NSArray *imageName = [item.picsFront componentsSeparatedByString:@","];
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [imageName count]; i++) {
        UIImage *img = [UIImage imageNamed:imageName[i]];
        [imgArray addObject:img];
    }
    if ([imgArray count] == 0) {
        return;
    }
    //imageView的动画图片是数组images
    _gifImageView.animationImages = imgArray;
    //按照原始比例缩放图片，保持纵横比
    _gifImageView.contentMode = UIViewContentModeScaleToFill;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    _gifImageView.animationDuration = vLong;
    //动画的重复次数，想让它无限循环就赋成0
    _gifImageView.animationRepeatCount = 1;
    //开始动画
    [_gifImageView startAnimating];
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

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Error loading");
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"Ad loaded");
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
    NSLog(@"Ad will load");
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    NSLog(@"Ad did finish");
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier =	 @"UITableViewCell";
    StepCell *cell = (StepCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"StepCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSArray *stepDescribe = [_item.stepDescribes componentsSeparatedByString:@"&&"];
    if ([stepDescribe count] == count) {
        cell.describeLabel.text = stepDescribe[indexPath.row];
    }
    NSArray *stepStep = [_item.stepTypes componentsSeparatedByString:@","];
    if ([stepStep count] == count) {
        cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"step_%@", stepStep[indexPath.row]]];
    }
    
    return cell;
}

- (void)voiceButtonClicked:(VoiceItem *)item {
    VoiceDetailViewController *detailViewController = [VoiceDetailViewController new];
    detailViewController.item = item;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
