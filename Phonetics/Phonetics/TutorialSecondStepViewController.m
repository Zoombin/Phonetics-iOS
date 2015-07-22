//
//  TutorialSecondStepViewController.m
//  Phonetics
//
//  Created by yc on 15-7-22.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "TutorialSecondStepViewController.h"
#import "VoiceDetailViewController.h"
#import "StepCell.h"
#import "ExampleCell.h"
#import "VoiceInfo.h"
#import "VoiceButton.h"
#import <AVFoundation/AVFoundation.h>
#import "TimeUtil.h"
#import "UserDefaultManager.h"

@interface TutorialSecondStepViewController ()

@end

@implementation TutorialSecondStepViewController {
    AVAudioPlayer *audioPlayer;
    NSMutableArray *bottomButtons;
    NSInteger count;
    NSInteger exampleCount;
    NSInteger similarCount;
    NSInteger currentIndex;
    NSMutableArray *allItems;
    BOOL isExample;
    BOOL shouldDG;
    
    NSInteger currentStep;
}

- (void)allHidden {
    _stepView2.hidden = YES;
    _stepView3.hidden = YES;
    _stepView4.hidden = YES;
    _stepView5.hidden = YES;
    _stepView6.hidden = YES;
    _stepView7.hidden = YES;
    _stepView8.hidden = YES;
    _stepView9.hidden = YES;
    _stepView10.hidden = YES;
    _stepView11.hidden = YES;
    _clickButton4.hidden = YES;
    _clickButton5.hidden = YES;
    _clickButton6.hidden = YES;
    _clickButton7.hidden = YES;
    _clickButton8.hidden = YES;
    _clickButton9.hidden = YES;
    _segmentedControl6.hidden = YES;
}

- (IBAction)nextStepButtonClicked:(id)sender {
    [self nextStep];
}

- (IBAction)clickButtonClicked:(id)sender {
    if (currentStep == 3) {
        [self buttonClicked:bottomButtons[2]];
        [self nextStep];
    } else if (currentStep == 4) {
        [self voiceButtonClick:nil];
        [self nextStep];
    } else if (currentStep == 6) {
        [self showHeader];
        [self showYBView];
        [_exampleTableView reloadData];
        [self read:currentIndex isSlow:NO];
        [self nextStep];
    } else if (currentStep == 7) {
        NSArray *voices = [isExample ? _item.examplesYBName : _item.similarYBName componentsSeparatedByString:@"&&"];
        NSArray *ybs = [voices[currentIndex] componentsSeparatedByString:@","];
        VoiceItem *item = [self searchVoiceByName:ybs[0]];
        [self playVoice:item];
        [self nextStep];
    } else if (currentStep == 8) {
        [self showHeader];
        [self showYBView];
        [_exampleTableView reloadData];
        [self read:currentIndex isSlow:YES];
        [self nextStep];
    }
}

- (void)nextStep {
    [self allHidden];
    currentStep++;
    if (currentStep == 1) {
        _stepView2.hidden = NO;
    } else if (currentStep == 2) {
        _stepView3.hidden = NO;
    } else if (currentStep == 3) {
        _stepView4.hidden = NO;
        _clickButton4.hidden = NO;
        _clickButton4.center = CGPointMake((CGRectGetMaxX(_bottomView.frame) / 4) * 2.5, CGRectGetMinY(_bottomView.frame) + _bottomView.frame.size.height / 4);
    } else if (currentStep == 4) {
        _stepView5.hidden = NO;
        _clickButton5.hidden = NO;
    } else if (currentStep == 5) {
        _stepView6.hidden = NO;
        _clickButton6.hidden = NO;
        _segmentedControl6.hidden = NO;
    } else if (currentStep == 6) {
        _stepView7.hidden = NO;
        _clickButton7.hidden = NO;
    } else if (currentStep == 7) {
        _stepView8.hidden = NO;
        _clickButton8.hidden = NO;
    } else if (currentStep == 8) {
        _stepView9.hidden = NO;
        _clickButton9.hidden = NO;
    } else if (currentStep == 9) {
        _stepView10.hidden = NO;
    } else if (currentStep == 10) {
        _stepView11.hidden = NO;
    }
}

- (void)valueChanged6 {
    [self nextStep];
    _segmentedControl.selectedSegmentIndex = _segmentedControl6.selectedSegmentIndex;
    [self valueChanged];
}

- (IBAction)closeButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)initStepView {
    [_stepView2.layer setCornerRadius:6.0];
    [_stepView2.layer setMasksToBounds:YES];
    
    [_stepView3.layer setCornerRadius:6.0];
    [_stepView3.layer setMasksToBounds:YES];
    
    [_stepView4.layer setCornerRadius:6.0];
    [_stepView4.layer setMasksToBounds:YES];
    
    [_stepView5.layer setCornerRadius:6.0];
    [_stepView5.layer setMasksToBounds:YES];
    
    [_stepView6.layer setCornerRadius:6.0];
    [_stepView6.layer setMasksToBounds:YES];
    
    [_stepView7.layer setCornerRadius:6.0];
    [_stepView7.layer setMasksToBounds:YES];
    
    [_stepView8.layer setCornerRadius:6.0];
    [_stepView8.layer setMasksToBounds:YES];
    
    [_stepView9.layer setCornerRadius:6.0];
    [_stepView9.layer setMasksToBounds:YES];
    
    [_stepView10.layer setCornerRadius:6.0];
    [_stepView10.layer setMasksToBounds:YES];
    
    [_stepView11.layer setCornerRadius:6.0];
    [_stepView11.layer setMasksToBounds:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //#####新手教程相关代码#####
    [self initStepView];
    currentStep = 0;
    [self nextStep];
    //#####新手教程相关代码#####
    shouldDG = NO;
    allItems = [[NSMutableArray alloc] init];
    count = 0;
    exampleCount = 0;
    currentIndex = 0;
    isExample = YES;
    self.title = @"详情";
    bottomButtons = [[NSMutableArray alloc] init];
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    bannerView.delegate = self;
    [_bottomView addSubview:bannerView];
    
    [self initData];
    
    // Do any additional setup after loading the view from its nib.
    [_segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl6 addTarget:self action:@selector(valueChanged6) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllItems];
}

//初始化数据
- (void)initData {
    currentIndex = 0;
    
    _segmentedControl.selectedSegmentIndex = 1;
    [_voiceButton setBackgroundImage:[UIImage imageNamed:_item.imgName] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:223.0/255.0 blue:219.0/255.0 alpha:1.0];
    NSArray *imageName = [_item.picsFront componentsSeparatedByString:@","];
    if ([imageName count] > 0) {
        _gifImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@.jpg",imageName[0]]];
    }
    if (!_isBasic) {
        [self showLastImg];
    }
    _describeTextView.text = _item.describeText;
    [_exampleTableView setTableHeaderView:_headerView];
    [self initBottomButton];
    [self loadStepInfo];
    [self loadExampleInfo];
    [self loadSimilarInfo];
}

- (void)showLastImg {
    NSArray *imgNames = [_item.examplesPics componentsSeparatedByString:@"&&"];
    NSArray *wordsPics = [imgNames[currentIndex] componentsSeparatedByString:@","];
    
    BOOL isSide = _segmentedControl.selectedSegmentIndex == 1;
    
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [wordsPics count]; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", isSide ? @"c" : @"", wordsPics[i]]];
        [imgArray addObject:img];
    }
    _gifImageView.image = imgArray.lastObject;
}

- (void)valueChanged {
    if (!_isBasic) {
        [self showLastImg];
    } else {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            NSArray *imageName = [_item.picsFront componentsSeparatedByString:@","];
            if ([imageName count] > 0) {
                _gifImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName[0]]];
            }
        } else {
            NSArray *imageName = [_item.picsFront componentsSeparatedByString:@","];
            if ([imageName count] > 0) {
                _gifImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@.jpg", imageName[0]]];
            }
        }
    }
}

- (void)loadStepInfo {
    if (_item.stepCount) {
        count = [_item.stepCount integerValue];
        if (count > 0) {
            _voiceLabel.text = [_item.examples componentsSeparatedByString:@","][0];
        }
        [_stepTableView reloadData];
    }
}

- (void)loadExampleInfo {
    if (_item.examplesCount) {
        exampleCount =  [_item.examplesCount integerValue];
        if (_isBasic) {
            [self showYBView];
        } else {
            [_exampleTableView setTableHeaderView:nil];
        }
        [_exampleTableView reloadData];
    }
}

- (void)loadSimilarInfo {
    if (_item.similarCount) {
        similarCount =  [_item.similarCount integerValue];
        [self showYBView];
        [_exampleTableView reloadData];
    }
}

- (void)showYBView {
    NSArray *voices = [isExample ? _item.examplesYBName : _item.similarYBName componentsSeparatedByString:@"&&"];
    for (id view in _headerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    if ([voices count] > 0) {
        NSArray *ybs = [voices[currentIndex] componentsSeparatedByString:@","];
        CGFloat buttonWidth = 50;
        CGFloat buttonHeight = 50;
        CGFloat buttonOffSet = 5;
        CGFloat startX = ([UIScreen mainScreen].bounds.size.width - ([ybs count] * buttonWidth) - (([ybs count] - 1 ) * buttonOffSet)) / 2;
        CGFloat startY = CGRectGetMaxY(_voiceLabel.frame);
        for (int i = 0; i < [ybs count]; i++) {
            VoiceItem *item = [self searchVoiceByName:ybs[i]];
            VoiceButton *button = [VoiceButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor lightGrayColor]];
            [button.layer setBorderWidth:1.0];
            [button.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0 alpha:1.0].CGColor];
            [button setFrame:CGRectMake(startX + (buttonWidth * i) + i * buttonOffSet, startY + 5, buttonWidth, buttonHeight)];
            if (item != nil) {
                [button addTarget:self action:@selector(loadYB:) forControlEvents:UIControlEventTouchUpInside];
                [button setBackgroundImage:[UIImage imageNamed:item.imgName] forState:UIControlStateNormal];
                button.item = item;
            }
            [_headerView addSubview:button];
        }
    }
}

- (void)loadYB:(id)sender {
    VoiceButton *button = (VoiceButton *)sender;
    [self playVoice:button.item];
}

- (void)initBottomButton {
    [bottomButtons removeAllObjects];
    for (UIView *v in _bottomView.subviews) {
        if (![v isKindOfClass:[ADBannerView class]]) {
            [v removeFromSuperview];
        }
    }
    
    NSArray *names = @[@"基础", @"日式", @"举例", @"相似"];
    if ([_item.similar length] == 0) {
        names = @[@"基础", @"日式", @"举例"];
    }
    if (!_isBasic) {
        names = @[@"描述", @"举例"];
        //        _segmentedControl.hidden = YES;
    }
    
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / [names count];
    CGFloat buttonHeight = _bottomView.frame.size.height / 2;
    
    for (int i = 0; i < [names count]; i++) {
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
            if (_isBasic) {
                _stepView.hidden = NO;
            } else {
                _describeView.hidden = NO;
            }
            break;
        case 1:
            if (_isBasic) {
                _describeView.hidden = NO;
            } else {
                _liView.hidden = NO;
                currentIndex = 0;
                isExample = YES;
                [_exampleTableView reloadData];
            }
            break;
        case 2:
            _liView.hidden = NO;
            currentIndex = 0;
            isExample = YES;
            [self showHeader];
            [self showYBView];
            [_exampleTableView reloadData];
            break;
        case 3:
            _liView.hidden = NO;
            currentIndex = 0;
            isExample = NO;
            [self showHeader];
            [self showYBView];
            [_exampleTableView reloadData];
            break;
        default:
            break;
    }
}

- (void)showHeader {
    NSArray *example = [isExample ? _item.examples : _item.similar componentsSeparatedByString:@","];
    if ([example count] > 0) {
        _voiceLabel.text = example[currentIndex];
    }
}


- (void)allUnClicked {
    for (UIButton *btn in bottomButtons) {
        btn.selected = NO;
    }
    _describeView.hidden = YES;
    _stepView.hidden = YES;
    _liView.hidden = YES;
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
        stime = [TimeUtil getPlayTime:item.startFemaleTime];
        vLong = [TimeUtil getPlayTime:item.voiceFemaleLong];
    } else {
        stime = [TimeUtil getPlayTime:item.startMaleTime];
        vLong = [TimeUtil getPlayTime:item.voiceMaleLong];
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
    BOOL isSide = _segmentedControl.selectedSegmentIndex == 1;
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [imageName count]; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", isSide ? @"c" : @"", imageName[i]]];
        [imgArray addObject:img];
    }
    if ([imgArray count] == 0) {
        return;
    }
    if (shouldDG) {
        shouldDG = NO;
        _gifImageView.image = imgArray.lastObject;
    } else {
        [self valueChanged];
    }
    if (!_isBasic) {
        _gifImageView.image = imgArray.lastObject;
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
    if (_isBasic) {
        [self playVoice:_item];
    } else {
        [self showHeader];
        [self showYBView];
        [self read:currentIndex isSlow:NO];
    }
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
    [UserDefaultManager saveCheckInDate:[NSDate date]];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _stepTableView) {
        return count;
    }
    return isExample ? exampleCount : similarCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _stepTableView) {
        return 70;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _stepTableView) {
        static NSString *CellIdentifier = @"UITableViewCell";
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
    } else {
        static NSString *CellIdentifier = @"UITableViewCell";
        ExampleCell *cell = (ExampleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ExampleCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor clearColor];
        }
        [cell.slowButton setTag:indexPath.row];
        [cell.slowButton addTarget:self action:@selector(slowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (currentIndex != indexPath.row) {
            cell.slowButton.hidden = YES;
        } else {
            cell.slowButton.hidden = NO;
        }
        if (isExample) {
            NSArray *words = [_item.examples componentsSeparatedByString:@","];
            NSArray *ybs = [_item.examplesYB componentsSeparatedByString:@"&&"];
            NSString *ybStr = @"";
            for (int i = 0; i < [ybs count]; i++) {
                if (indexPath.row == i) {
                    NSString *str = ybs[i];
                    ybStr = [ybStr stringByAppendingString:str];
                }
            }
            ybStr = [ybStr stringByReplacingOccurrencesOfString:@"," withString:@" "];
            if ([words count] == exampleCount) {
                cell.voiceLabel.text = [NSString stringWithFormat:@"%@ /%@/", words[indexPath.row], ybStr];
            }
        } else {
            NSArray *words = [_item.similar componentsSeparatedByString:@","];
            NSArray *ybs = [_item.similarYB componentsSeparatedByString:@"&&"];
            NSString *ybStr = @"";
            for (int i = 0; i < [ybs count]; i++) {
                if (indexPath.row == i) {
                    NSString *str = ybs[i];
                    ybStr = [ybStr stringByAppendingString:str];
                }
            }
            ybStr = [ybStr stringByReplacingOccurrencesOfString:@"," withString:@" "];
            if ([words count] == similarCount) {
                cell.voiceLabel.text = [NSString stringWithFormat:@"%@ /%@/", words[indexPath.row], ybStr];
            }
        }
        
        return cell;
    }
}

- (void)voiceButtonClicked:(VoiceItem *)item {
    VoiceDetailViewController *detailViewController = [VoiceDetailViewController new];
    detailViewController.item = item;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)slowButtonClicked:(id)sender {
    NSInteger index = [sender tag];
    [self read:index isSlow:YES];
}

- (void)read:(NSInteger)index isSlow:(BOOL)isSlow {
    float startTime = 0.0f;
    float vLong = 0.0f;
    NSString *readStr = nil;
    NSString *ybStr = nil;
    if (isExample) {
        readStr = isSlow ? _item.examplesSlowRead : _item.examplesRead;
        ybStr = _item.examplesYBName;
    } else {
        readStr = isSlow ? _item.similarSlowRead : _item.similarRead;
        ybStr = _item.similarYBName;
    }
    NSArray *voices = [readStr componentsSeparatedByString:@"&&"];
    NSString *wordsStr = voices[index];
    NSArray *wordsReadArr = [wordsStr componentsSeparatedByString:@","];
    
    if (!_selectMaleOrFemaleBtn.selected) {
        if ([wordsReadArr count] == 4) {
            startTime = [TimeUtil getPlayTime:wordsReadArr[0]];
            vLong = [TimeUtil getPlayTime:wordsReadArr[1]];
            [self playVoice:startTime andLong:vLong isSlow:isSlow];
        }
    } else {
        if ([wordsReadArr count] == 4) {
            startTime = [TimeUtil getPlayTime:wordsReadArr[2]];
            vLong = [TimeUtil getPlayTime:wordsReadArr[3]];
            [self playVoice:startTime andLong:vLong isSlow:isSlow];
        }
    }
    if (!_isBasic) {
        VoiceItem *tmpItem = [[VoiceItem alloc] init];
        tmpItem.picsFront = _item.examplesPics;
        tmpItem.picsSides = _item.examplesPics;
        [self changeImageView:tmpItem andLong:vLong];
    } else {
        NSArray *ybsArray = [ybStr componentsSeparatedByString:@"&&"];
        NSArray *wordsYBS = [ybsArray[index] componentsSeparatedByString:@","];
        if ([ybStr length] != 0) {
            NSMutableString *pics = [@"" mutableCopy];
            for (int i = 0; i < [wordsYBS count]; i++) {
                NSString *yb = wordsYBS[i];
                VoiceItem *item = [self searchVoiceByName:yb];
                if (item) {
                    NSArray *ybs = [item.picsFront componentsSeparatedByString:@","];
                    for (int j = 0; j < [ybs count]; j++) {
                        if (j == 0 && i != 0) {
                            [pics appendString:@","];
                        }
                        if (i != [wordsYBS count] - 1) {
                            if (j == 3) {
                                [pics appendFormat:@"%@", ybs[j]];
                                break;
                            }
                            [pics appendFormat:@"%@,", ybs[j]];
                        } else {
                            [pics appendFormat:@"%@%@", ybs[j], j == [ybs count] - 1 ? @"" : @","];
                        }
                    }
                }
            }
            VoiceItem *tmpItem = [[VoiceItem alloc] init];
            tmpItem.picsFront = pics;
            tmpItem.picsSides = pics;
            [self changeImageView:tmpItem andLong:vLong];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _exampleTableView) {
        currentIndex = indexPath.row;
        [self showHeader];
        [self showYBView];
        [_exampleTableView reloadData];
        [self read:indexPath.row isSlow:NO];
    } else if (tableView == _stepTableView) {
        NSArray *stepPics = [_item.stepPics componentsSeparatedByString:@"&&"];
        NSString *currentPics = stepPics[indexPath.row];
        
        NSArray *voices = [_item.stepVoices componentsSeparatedByString:@"&&"];
        NSString *currentVoics = voices[indexPath.row];
        NSArray *wordsReadArr = [currentVoics componentsSeparatedByString:@","];
        
        VoiceItem *item = [[VoiceItem alloc] init];
        item.startFemaleTime = @"";
        item.voiceFemaleLong = @"";
        item.startMaleTime = @"";
        item.voiceMaleLong = @"";
        item.picsFront = currentPics;
        if ([wordsReadArr count] == 4) {
            item.startFemaleTime = wordsReadArr[0];
            item.voiceFemaleLong = wordsReadArr[1];
            item.startMaleTime = wordsReadArr[2];
            item.voiceMaleLong = wordsReadArr[3];
        }
        if (indexPath.row == 0) {
            shouldDG = YES;
        }
        [self playVoice:item];
    }
}

- (void)playVoice:(float)startTime andLong:(float)vLong isSlow:(BOOL)isSlow{
    NSString *slow = @"sy3.1";
    NSString *musicUrl = [[NSBundle mainBundle] pathForResource:isSlow ? slow : @"bgmusic" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicUrl];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil
                   ];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1;
    audioPlayer.currentTime = startTime;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    [self performSelector:@selector(playStop) withObject:nil afterDelay:vLong];
}

- (VoiceItem *)searchVoiceByName:(NSString *)voice {
    for (VoiceInfo *info in _voiceArray) {
        for (VoiceItem *item in info.voices) {
            if ([item.name isEqualToString:voice]) {
                return item;
            }
        }
    }
    return nil;
}

//前一个和后一个
- (void)getAllItems {
    for (VoiceInfo *info in _voiceArray) {
        for (VoiceItem *item in info.voices) {
            [allItems addObject:item];
        }
    }
    NSInteger index = [allItems indexOfObject:_item];
    if (index == 0) {
        _preButton.hidden = YES;
    }
    if (index == [allItems count] - 1) {
        _nextButton.hidden = YES;
    }
}

- (IBAction)nextBtnClicked:(id)sender {
    NSInteger index = [allItems indexOfObject:_item];
    index++;
    _preButton.hidden = NO;
    if (index == [allItems count] - 1) {
        _nextButton.hidden = YES;
    }
    _item = allItems[index];
    [self initData];
}

- (IBAction)preBtnClicked:(id)sender {
    NSInteger index = [allItems indexOfObject:_item];
    index--;
    _nextButton.hidden = NO;
    if (index == 0) {
        _preButton.hidden = YES;
    }
    _item = allItems[index];
    [self initData];
}


@end