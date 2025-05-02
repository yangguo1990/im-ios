//
//  LVPictureTextMsgView.h
//  LiveVideo
//
//  Created by 史贵岭 on 2017/11/11.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "YBIBToolViewHandler.h"
#import "YBImageBrowser.h"
#import "ML_CommunityModel.h"

@interface ML_ToolViewHandler : NSObject <YBIBToolViewHandler>
@property (strong, nonatomic) UIButton *ML_GuanzhuBtn;
@property (nonatomic, strong) YBImageBrowser *Browser;
@property (nonatomic, strong) ML_CommunityModel *model;
@property (nonatomic ,copy) void (^ML_ToolViewHandlerBtnBlock)(NSInteger tag);
@end
