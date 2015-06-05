//
//  ViewController.m
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "MainViewController.h"
#import "VoiceDetailViewController.h"
#import "VoiceCell.h"
#import "VoiceInfo.h"
#import <AVFoundation/AVFoundation.h>

@interface MainViewController ()

@end

@implementation MainViewController {
    NSMutableArray *voiceArray;
    NSArray *basicsArr;
    NSArray *advancedArr;
    AVAudioPlayer *audioPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    voiceArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:223.0/255.0 blue:219.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadVoiceInfo];
    [_segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)playVoice {
    NSString *musicUrl = [[NSBundle mainBundle] pathForResource:@"bgmusic" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicUrl];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil
                                  ];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    audioPlayer.currentTime = 30;
    [self performSelector:@selector(playStop) withObject:nil afterDelay:5.0];
    
}

- (void)playStop {
    [audioPlayer stop];
}

- (void)valueChanged:(id)sender {
    [voiceArray removeAllObjects];
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [voiceArray addObjectsFromArray:basicsArr];
    } else {
        [voiceArray addObjectsFromArray:advancedArr];
    }
    [_tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [voiceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier =	 @"UITableViewCell";
    VoiceCell *cell = (VoiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"VoiceCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    VoiceInfo *info = voiceArray[indexPath.row];
    cell.titleLabel.text = info.title;
    cell.describeLabel.text = info.describeInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VoiceDetailViewController *detailViewController = [VoiceDetailViewController new];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)menuButtonClicked:(id)sender {
//    _menuView.hidden = !_menuView.hidden;
    [self playVoice];
}

@end
