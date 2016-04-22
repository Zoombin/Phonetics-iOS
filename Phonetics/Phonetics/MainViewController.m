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
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import "UserDefaultManager.h"
#import "PhoneticsUtils.h"
#import "UserDefaultManager.h"
#import "WebViewController.h"
#import "TutorialFirstStepViewController.h"
#import "PhoneticsUtils.h"
#import "WXApi.h"


@interface MainViewController ()

@end

#define SHARE_ALERT 1001
#define SCORE_ALERT 1002

@implementation MainViewController {
    NSMutableArray *voiceArray;
    NSArray *basicsArr;
    NSArray *advancedArr;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![UserDefaultManager isFirstLaunch]) {
        [UserDefaultManager saveFirstLaunch];
        TutorialFirstStepViewController *firstStepViewController = [TutorialFirstStepViewController new];
        [self.navigationController pushViewController:firstStepViewController animated:NO];
    }
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
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"分享", nil];
    alertView.tag = SHARE_ALERT;
    [alertView show];
    //TODO: 此处改为只弹出一次了
    [UserDefaultManager saveHasShare:YES];
}

- (void)showScoreAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"对比功能需要评分后才能使用哦"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"去评分", nil];
    alertView.tag = SCORE_ALERT;
    [alertView show];
    //TODO: 此处改为只弹出一次了
    [UserDefaultManager saveHasScore:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == SHARE_ALERT) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            [self performSelector:@selector(showShareActionSheet:) withObject:self.view afterDelay:1.0];
        }
    } else if (alertView.tag == SCORE_ALERT) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            [UserDefaultManager saveHasScore:YES];
            [self scoreApp];
        }
    }
}

- (void)contactUs {
    WebViewController *webViewController = [WebViewController new];
    webViewController.url = @"http://url.cn/e1QPcQ";
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)scoreApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1020531456"]];
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
        return 4;
    }
    return [voiceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _menuTableView) {
        return 35;
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
        } else if (indexPath.row == 3) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"在线交流";
        }
        return cell;
    } else {
        static NSString *cellIdentifier = @"UITableViewCell";
        VoiceCell *cell = (VoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"VoiceCell" owner:nil options:nil];
            cell = [nibs lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
            if ([UserDefaultManager hasScoreAlready]) {
                //音标对比
                CompareViewController *compareViewController = [CompareViewController new];
                compareViewController.basicArray = basicsArr;
                [self.navigationController pushViewController:compareViewController animated:YES];
            } else {
                [self showScoreAlert];
            }
        } else if (indexPath.row == 1) {
            [self showShareActionSheet:self.view];
        } else  if (indexPath.row == 2){
            [self menuButtonClicked:nil];
            TutorialFirstStepViewController *firstStepViewController = [TutorialFirstStepViewController new];
            [self.navigationController pushViewController:firstStepViewController animated:NO];
        } else {
            [self contactUs];
        }
    }
}




- (void)showShareActionSheet:(UIView *)view
{
    if (![WXApi isWXAppInstalled]) {
        [self showAlert:@"您尚未安装微信客户端!"];
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"我很喜欢这个软件：【花华组】基于国外著名大学研究成果，结合世界级美工特效，打造出的全球最精细的音标学习软件。下载地址：http://url.cn/cxFZ8s贴吧地址：http://url.cn/Scmk8i关注官方公众号：hanakagumi"
                                     images:nil
                                        url:[NSURL URLWithString:@"http://hanaka.5858.com"]
                                      title:@"金版音标图谱"
                                       type:SSDKContentTypeAuto];
    
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       //                       [theController showLoadingView:NO];
                       //                       [theController.tableView reloadData];
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
