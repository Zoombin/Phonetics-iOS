//
//  VoiceSelectViewController.m
//  Phonetics
//
//  Created by yc on 15-6-24.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "VoiceSelectViewController.h"

@interface VoiceSelectViewController ()

@end

@implementation VoiceSelectViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"选择音标", nil);
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    VoiceInfo *info = _basicArray[section];
    return [info.voices count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    VoiceInfo *info = _basicArray[section];
    return info.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_basicArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    VoiceInfo *info = _basicArray[indexPath.section];
    VoiceItem *item = info.voices[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VoiceInfo *info = _basicArray[indexPath.section];
    VoiceItem *item = info.voices[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(voiceSelected:andIsUp:)]) {
        [self.delegate voiceSelected:item andIsUp:_isUp];
        [self.navigationController popViewControllerAnimated:NO];
    }
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


@end
