//
//  VoiceDetailViewController.m
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "VoiceDetailViewController.h"
#import "StepCell.h"
#import "ExampleCell.h"
#import "VoiceInfo.h"
#import "VoiceButton.h"
#import <AVFoundation/AVFoundation.h>
#import "TimeUtil.h"
#import "UserDefaultManager.h"
#import "Constant.h"
#import "PhoneticsUtils.h"

@interface VoiceDetailViewController ()

@end

@implementation VoiceDetailViewController {
    AVAudioPlayer *audioPlayer;
    NSMutableArray *bottomButtons;
    NSInteger count;
    NSInteger exampleCount;
    NSInteger similarCount;
    NSInteger currentIndex;
    NSMutableArray *allItems;
    BOOL isExample;
    BOOL shouldDG;
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

- (void)initCheckLabel {
//    checkInLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bannerView.frame) - 30, 0, 30, 21)];
//    checkInLabel.textColor = [UIColor colorWithRed:233/255.0 green:79/255.0 blue:46/255.0 alpha:1.0];
//    checkInLabel.textAlignment = NSTextAlignmentCenter;
//    [bannerView addSubview:checkInLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAudio];
    shouldDG = NO;
    isReading = NO;
    allItems = [[NSMutableArray alloc] init];
    count = 0;
    exampleCount = 0;
    currentIndex = 0;
    isExample = YES;
    self.title = @"详情";
    bottomButtons = [[NSMutableArray alloc] init];
    
    [self initCheckLabel];
    [_voiceButton.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0 alpha:1.0].CGColor];
    [_voiceButton.layer setBorderWidth:1.0];
    
    [self getAllItems];
    [self initData];
    
    // Do any additional setup after loading the view from its nib.
    [_segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self initLocalizedString];
}

- (void)initLocalizedString {
    [_segmentedControl setTitle:NSLocalizedString(@"正面", nil) forSegmentAtIndex:0];
    [_segmentedControl setTitle:NSLocalizedString(@"侧面", nil) forSegmentAtIndex:1];
}

- (void)initIpadUI {
    _describeTextView.font = [UIFont systemFontOfSize:22];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    checkInLabel.text = [UserDefaultManager checkInTimes];
}

//初始化数据
- (void)initData {
    currentIndex = 0;
    
    [self getTmpItem];
    _segmentedControl.selectedSegmentIndex = 1;
    [_voiceButton setBackgroundImage:[UIImage imageNamed:_item.imgName] forState:UIControlStateNormal];
    //    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:223.0/255.0 blue:219.0/255.0 alpha:1.0];
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
    
    
    if (_isBasic) {
        NSInteger index = [allItems indexOfObject:_item];
        if (index == 9) {
            if (![UserDefaultManager hasShowScoreTen]) {
                [UserDefaultManager saveHasShowScoreTen:YES];
                [self showScoreAlert];
            }
        } else if (index == allItems.count - 1) {
            if (![UserDefaultManager hasShowScoreAll]) {
                [UserDefaultManager saveHasShowScoreAll:YES];
                [self showScoreAlert];
            }
        }
    }
}

- (void)changeImageUI {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.gifImageView.frame.size.height;
    
    CGFloat photoWidth = 480;
    CGFloat photoHeight = 372;
    
    CGFloat newWidth = width;
    CGFloat newHeight = (newWidth * photoHeight) / photoWidth;
    if (newHeight > height) {
        newWidth = (photoWidth * height) / photoHeight;
        newHeight = height;
    }
    CGFloat startX = newWidth < width ? (width - newWidth) : 0;
    _gifImageView.frame = CGRectMake(startX, 0, newWidth, newHeight);
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
        [v removeFromSuperview];
    }
    
    NSArray *names = @[NSLocalizedString(@"基础", nil), NSLocalizedString(@"日式", nil), NSLocalizedString(@"举例", nil), NSLocalizedString(@"相似", nil)];
    if ([_item.similar length] == 0) {
        names = @[NSLocalizedString(@"基础", nil), NSLocalizedString(@"日式", nil), NSLocalizedString(@"举例", nil)];
    }
    if (!_isBasic) {
        names = @[NSLocalizedString(@"描述", nil), NSLocalizedString(@"举例", nil)];
        //        _segmentedControl.hidden = YES;
    }
    
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / [names count];
    CGFloat buttonHeight = _bottomView.frame.size.height;
    
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
    if (isReading) {
        return;
    }
    float stime = 0.0f;
    float vLong = 0.0f;
    if (!_selectMaleOrFemaleBtn.selected) {
        stime = [TimeUtil getPlayTime:item.startFemaleTime];
        vLong = [TimeUtil getPlayTime:item.voiceFemaleLong];
    } else {
        stime = [TimeUtil getPlayTime:item.startMaleTime];
        vLong = [TimeUtil getPlayTime:item.voiceMaleLong];
    }
    audioPlayer.currentTime = stime;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    isReading = YES;
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
    isReading = NO;
}

- (void)bannerViewClicked {
    [UserDefaultManager saveCheckInDate:[NSDate date]];
    checkInLabel.text = [UserDefaultManager checkInTimes];
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
    if (isReading) {
        return;
    }
    NSInteger index = [sender tag];
    [self read:index isSlow:YES];
}

- (void)read:(NSInteger)index isSlow:(BOOL)isSlow {
    if (isReading) {
        return;
    }
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
    if (isExample) {
        NSArray *examplesPics = [_item.examplesPics componentsSeparatedByString:@"&&"];
        if (index < [examplesPics count]) {
            VoiceItem *tmpItem = [[VoiceItem alloc] init];
            tmpItem.picsFront = examplesPics[index];
            tmpItem.picsSides = examplesPics[index];
            [self changeImageView:tmpItem andLong:vLong];
        }
    } else {
        NSArray *similarPics = [_item.similarPics componentsSeparatedByString:@"&&"];
        if (index < [similarPics count]) {
            VoiceItem *tmpItem = [[VoiceItem alloc] init];
            tmpItem.picsFront = similarPics[index];
            tmpItem.picsSides = similarPics[index];
            [self changeImageView:tmpItem andLong:vLong];
        }
    }
}

- (void)getTmpItem {
    if (!_isBasic) {
        return;
    }
    [self initPics:YES];
    [self initPics:NO];
}

- (void)initPics:(BOOL)isExp {
    NSString *ybStr = nil;
    if (isExp) {
        ybStr = _item.examplesYBName;
    } else {
        ybStr = _item.similarYBName;
    }
    NSArray *ybsArray = [ybStr componentsSeparatedByString:@"&&"];
    NSMutableArray *yinbiao = [[NSMutableArray alloc] init];
    for (int i = 0; i < [ybsArray count]; i++) {
        NSArray *wordsYBS = [ybsArray[i] componentsSeparatedByString:@","];
        NSMutableString *pics = [@"" mutableCopy];
        for (int j = 0; j < [wordsYBS count]; j++) {
            NSString *yb = wordsYBS[j];
            VoiceItem *item = [self searchVoiceByName:yb];
            if (item) {
                NSArray *ybs = [item.picsFront componentsSeparatedByString:@","];
                for (int k = 0; k < [ybs count]; k++) {
                    if (j != 0) {
                        if (k >3 && j != [wordsYBS count] - 1) {
                            break;
                        }
                        [pics appendFormat:@",%@", ybs[k]];
                    } else {
                        if (k >3 && j != [wordsYBS count] - 1) {
                            break;
                        }
                        [pics appendFormat:@"%@%@", k == 0 ? @"" : @",", ybs[k]];
                    }
                }
            }
        }
        [yinbiao addObject:pics];
    }
    
    NSMutableString *ybString = [@"" mutableCopy];
    int i = 0;
    for (NSString *name in yinbiao) {
        [ybString appendFormat:@"%@%@", i == 0 ? @"" : @"&&", name];
        i++;
    }
    if (isExp) {
        _item.examplesPics = ybString;
    } else {
        _item.similarPics = ybString;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _exampleTableView) {
        if (isReading) {
            return;
        }
        currentIndex = indexPath.row;
        [self showHeader];
        [self showYBView];
        [_exampleTableView reloadData];
        [self read:indexPath.row isSlow:NO];
    } else if (tableView == _stepTableView) {
        if (isReading) {
            return;
        }
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
    audioPlayer.currentTime = startTime;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    isReading = YES;
    [self performSelector:@selector(playStop) withObject:nil afterDelay:vLong];
}

- (VoiceItem *)searchVoiceByName:(NSString *)voice {
    for (VoiceItem *item in allItems) {
        if ([item.name isEqualToString:voice]) {
            return item;
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
    if (isReading) {
        return;
    }
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
    if (isReading) {
        return;
    }
    NSInteger index = [allItems indexOfObject:_item];
    index--;
    _nextButton.hidden = NO;
    if (index == 0) {
        _preButton.hidden = YES;
    }
    _item = allItems[index];
    [self initData];
}

- (void)showScoreAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"对比功能需要评分后才能使用哦"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"去评分", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        [UserDefaultManager saveHasScore:YES];
        [self scoreApp];
    }
}

- (void)scoreApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1020531456"]];
}

@end
