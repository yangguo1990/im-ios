#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NEGroupCallKit.h"
#import "NERtcCallKit.h"
#import "NERtcCallKitConsts.h"
#import "NERtcCallKitContext.h"
#import "NERtcCallKitJoinChannelEvent.h"
#import "NERtcCallKitPushConfig.h"
#import "NERtcCallOptions.h"
#import "GroupAttachment.h"
#import "GroupCallMember.h"
#import "GroupCallParam.h"
#import "GroupCallResult.h"
#import "GroupHeader.h"
#import "NEGroupCallInfo.h"
#import "NEGroupInfo.h"

FOUNDATION_EXPORT double NERtcCallKitVersionNumber;
FOUNDATION_EXPORT const unsigned char NERtcCallKitVersionString[];

