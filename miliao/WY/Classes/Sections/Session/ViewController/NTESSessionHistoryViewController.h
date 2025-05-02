//
//  NTESSessionHistoryViewController.h
//  NIM
//
//  Created by emily on 30/01/2018.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "NIMSessionViewController.h"
#import "NTESSessionConfig.h"
#import "ML_SessionViewController.h"

@interface NTESSessionHistoryConfig : NTESSessionConfig

- (instancetype)initWithSession:(NIMSession *)session firstMsg:(NIMMessage *)msg;

@end

@interface NTESSessionHistoryMessageDataProvider : NSObject<NIMKitMessageProvider>

@property(nonatomic, strong) NIMSession *session;

- (instancetype)initWithSession:(NIMSession *)session firstMsg:(NIMMessage *)msg;

@end


@interface NTESSessionHistoryViewController : ML_SessionViewController

- (instancetype)initWithSession:(NIMSession *)session andSearchMsg:(NIMMessage *)msg;

@end
