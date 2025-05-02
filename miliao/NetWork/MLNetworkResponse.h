//
//  MLNetworkResponse.h
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import <Foundation/Foundation.h>

@interface MLNetworkResponse : NSObject

@property (nonatomic, copy) NSString *msg;
@property (nonatomic,copy)NSString *status;
@property (nonatomic, strong) id data;

@end
