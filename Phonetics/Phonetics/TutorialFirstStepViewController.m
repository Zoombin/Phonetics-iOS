//
//  TutorialFirstStepViewController.m
//  Phonetics
//
//  Created by yc on 15-7-22.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "TutorialFirstStepViewController.h"
#import "TutorialSecondStepViewController.h"
#import "VoiceCell.h"
#import "VoiceInfo.h"

@interface TutorialFirstStepViewController ()

@end

@implementation TutorialFirstStepViewController {
    NSMutableArray *voiceArray;
    NSArray *basicsArr;
    NSArray *advancedArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_stepView.layer setCornerRadius:6.0];
    [_stepView.layer setMasksToBounds:YES];
    voiceArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadVoiceInfo];
    [_stepButton startAnimation];
    
    [self initLocalizedString];
}

- (void)initLocalizedString {
    [_segmentedControl setTitle:NSLocalizedString(@"基础技巧", nil) forSegmentAtIndex:0];
    [_segmentedControl setTitle:NSLocalizedString(@"高级技巧", nil) forSegmentAtIndex:1];
    
    [_titleLabel setText:NSLocalizedString(@"英语音标", nil)];
    [_step1Label setText:NSLocalizedString(@"首先烦请点按钮上的蓝色圆圈。", nil)];
    [_closeButton setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
}

- (void)dealloc {
    [_stepButton stop];
}

- (void)loadVoiceInfo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"voiceInfo" ofType:@"plist"];
    NSDictionary *info = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if (info) {
        basicsArr = [VoiceInfo createWithArray:info[@"basics"]];
        advancedArr = [VoiceInfo createWithArray:info[@"advanced"]];
    }
    [self valueChanged:nil];
}

- (IBAction)voiceButtonClicked:(id)sender {
    if ([basicsArr count] == 0) {
        return;
    }
    VoiceInfo *voiceInfo = basicsArr[0];
    VoiceItem *item = voiceInfo.voices[3];
    TutorialSecondStepViewController *secondStepViewController = [TutorialSecondStepViewController new];
    secondStepViewController.isBasic = YES;
    secondStepViewController.voiceArray = basicsArr;
    secondStepViewController.item = item;
    [self.navigationController pushViewController:secondStepViewController animated:YES];
}

- (IBAction)closeButtonClicked:(id)sende {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)valueChanged:(id)sender {
    [voiceArray removeAllObjects];
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [voiceArray addObjectsFromArray:basicsArr];
    }
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [voiceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellIdentifier = @"UITableViewCell";
        VoiceCell *cell = (VoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"VoiceCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor clearColor];
        }
        VoiceInfo *info = voiceArray[indexPath.row];
        cell.titleLabel.text = info.title;
        cell.describeLabel.text = info.describeInfo;
        if (info.voices) {
            [cell showVoices:info.voices];
        }
        return cell;
}

@end
