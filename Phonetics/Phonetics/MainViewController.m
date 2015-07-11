//
//  ViewController.m
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "MainViewController.h"
#import "VoiceDetailViewController.h"
#import "CompareViewController.h"
#import "VoiceCell.h"
#import "VoiceInfo.h"
#import <ShareSDK/ShareSDK.h>


@interface MainViewController ()

@end

@implementation MainViewController {
    NSMutableArray *voiceArray;
    NSArray *basicsArr;
    NSArray *advancedArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    voiceArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:223.0/255.0 blue:219.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadVoiceInfo];
    [_bkgButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
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
    if (tableView == _menuTableView) {
        return 2;
    }
    return [voiceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _menuTableView) {
        return 44;
    }
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _menuTableView) {
        static NSString *cellIdentifier = @"UITableViewCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"音标对比";
        } else if (indexPath.row == 1) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"分享到朋友圈";
        }
        return cell;
    } else {
        static NSString *cellIdentifier = @"UITableViewCell";
        VoiceCell *cell = (VoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"VoiceCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor clearColor];
        }
        VoiceInfo *info = voiceArray[indexPath.row];
        cell.delegate = self;
        cell.titleLabel.text = info.title;
        cell.describeLabel.text = info.describeInfo;
        if (info.voices) {
            [cell showVoices:info.voices];
        }
        return cell;
    }
}

- (void)voiceButtonClicked:(VoiceItem *)item {
    VoiceDetailViewController *detailViewController = [VoiceDetailViewController new];
    if (_segmentedControl.selectedSegmentIndex == 0) {
        detailViewController.isBasic = YES;
        detailViewController.voiceArray = basicsArr;
    } else {
        detailViewController.isBasic = NO;
        detailViewController.voiceArray = advancedArr;
    }
    detailViewController.item = item;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _menuTableView) {
        if (indexPath.row == 0) {
            //音标对比
            NSLog(@"音标对比");
            CompareViewController *compareViewController = [CompareViewController new];
            compareViewController.basicArray = basicsArr;
            [self.navigationController pushViewController:compareViewController animated:YES];
        } else if (indexPath.row == 1) {
            NSLog(@"分享到朋友圈");
            //构造分享内容
//            金版发音图谱，每日点击广告1次（连击无效）、单月累计点击广告30次的用户朋友可以凭含“广告计数页面的截图”和“微信朋友圈分享此活动内容的截图”参与每月的“返20元大抽奖”，每人每月有一次机会。参与者可将上述截图和领奖微信号发至：hanakagumi@outlook.com
            id<ISSContent> publishContent = [ShareSDK content:@"推荐：花华组基于国外著名大学研究成果，结合世界级美工特效，打造出的全球最精细的音标学习软件。"
                                             "关注官方公众号：hanakagumi"
                                             "花华组主页：hanaka.5858.com"
                                             "金版音标图谱下载地址："
                                               defaultContent:@"微信"
                                                        image:nil
                                                        title:@"金版音标图谱"
                                                          url:@"http://hanaka.5858.com"
                                                  description:@"分享信息"
                                                    mediaType:SSPublishContentMediaTypeText];
            //创建弹出菜单容器
            id<ISSContainer> container = [ShareSDK container];
            [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
            
            //弹出分享菜单
            [ShareSDK showShareActionSheet:container
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions:nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        
                                        if (state == SSResponseStateSuccess)
                                        {
                                            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                            [self showAlert:@"分享成功"];
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                            [self showAlert:@"分享失败"];
                                        }
                                    }];
        }
    }
}

- (void)showAlert:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}

- (IBAction)menuButtonClicked:(id)sender {
    _menuView.hidden = !_menuView.hidden;
}

@end
