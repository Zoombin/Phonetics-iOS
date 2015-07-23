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
#import "UserDefaultManager.h"
#import "PhoneticsUtils.h"
#import "UserDefaultManager.h"
#import "TutorialFirstStepViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController {
    NSMutableArray *voiceArray;
    NSArray *basicsArr;
    NSArray *advancedArr;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _checkInLabel.text = [UserDefaultManager checkInTimes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    voiceArray = [[NSMutableArray alloc] init];;
    // Do any additional setup after loading the view, typically from a nib.
    [self loadVoiceInfo];
    [_bkgButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _checkInLabel.center = CGPointMake(CGRectGetMaxX(_iconImageView.frame), CGRectGetMinY(_iconImageView.frame));
    [_bkgView bringSubviewToFront:_checkInLabel];
    _versionsLabel.text = [PhoneticsUtils getVersion];
}

- (void)valueChanged:(id)sender {
    [voiceArray removeAllObjects];
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [voiceArray addObjectsFromArray:basicsArr];
    } else {
        if ([UserDefaultManager hasShareWeChat]) {
            [voiceArray addObjectsFromArray:advancedArr];
        } else {
            _segmentedControl.selectedSegmentIndex = 0;
            [voiceArray addObjectsFromArray:basicsArr];
            [self showShareWarnning];
        }
    }
    [_tableView reloadData];
}

- (void)showShareWarnning {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"微信朋友圈分享成功后、才能查阅此页面。"
                                                       delegate:self
                                              cancelButtonTitle:@"分享"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex == buttonIndex) {
        [self performSelector:@selector(showShareActionSheet) withObject:nil afterDelay:0.5];
    }
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
        return 3;
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
        } else if (indexPath.row == 2) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"新手说明";
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
            CompareViewController *compareViewController = [CompareViewController new];
            compareViewController.basicArray = basicsArr;
            [self.navigationController pushViewController:compareViewController animated:YES];
        } else if (indexPath.row == 1) {
            [self showShareActionSheet];
        } else {
            NSLog(@"新手说明");
            [self menuButtonClicked:nil];
            TutorialFirstStepViewController *firstStepViewController = [TutorialFirstStepViewController new];
            [self.navigationController pushViewController:firstStepViewController animated:NO];
        }
    }
}

- (void)showShareActionSheet {
    id<ISSContent> publishContent = [ShareSDK content:@"推荐：花华组基于国外著名大学研究成果，结合世界级美工特效，打造出的全球最精细的音标学习软件。"
                                     "关注官方公众号：hanakagumi"
                                     "花华组主页：http://hanaka.5858.com"
                                     "官方贴吧地址：http://url.cn/e1QPcQ"
                                     "金版音标图谱下载地址：http://t.cn/RLirgVF"
                                       defaultContent:@"微信"
                                                image:nil
                                                title:@"金版音标图谱"
                                                  url:@"http://hanaka.5858.com"
                                          description:@"分享信息"
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSShareActionSheetItem> weChatTimeLineItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiTimeline]
                                                                                icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline]
                                                                        clickHandler:^{
                                                                            [ShareSDK shareContent:publishContent
                                                                                              type:ShareTypeWeixiTimeline
                                                                                       authOptions:nil
                                                                                     statusBarTips:NO
                                                                                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                if (state == SSResponseStateSuccess)
                                                                                {
                                                                                    [self showAlert:@"分享成功"];
                                                                                    [UserDefaultManager saveHasShare:YES];
                                                                                }
                                                                                else if (state == SSResponseStateFail)
                                                                                {
                                                                                    [self showAlert:@"分享失败"];
                                                                                }

                                                                            }];
                                                                        }];
    
    id<ISSShareActionSheetItem> weChatSessionItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiSession]
                                                                                        icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession]
                                                                               clickHandler:^{
                                                                                   [ShareSDK shareContent:publishContent
                                                                                                     type:ShareTypeWeixiSession
                                                                                              authOptions:nil
                                                                                            statusBarTips:NO
                                                                                                   result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                       if (state == SSResponseStateSuccess)
                                                                                       {
                                                                                           [self showAlert:@"分享成功"];
                                                                                           [UserDefaultManager saveHasShare:YES];
                                                                                       }
                                                                                       else if (state == SSResponseStateFail)
                                                                                       {
                                                                                           [self showAlert:@"分享失败"];
                                                                                       }
                                                                                       
                                                                                   }];
                                                                               }];
    
    NSArray *shareList = [ShareSDK customShareListWithType:weChatTimeLineItem, weChatSessionItem, nil];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess) {
                                    [self showAlert:@"分享成功"];
                                    [UserDefaultManager saveHasShare:YES];
                                }
                                else if (state == SSResponseStateFail){
                                    [self showAlert:@"分享失败"];
                                }
                            }];
}

- (void)showAlert:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}

- (IBAction)menuButtonClicked:(id)sender {
    _menuView.hidden = !_menuView.hidden;
}

@end
