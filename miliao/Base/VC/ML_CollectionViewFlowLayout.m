//
//  WuC_CollectionViewFlowLayout.m
//  wuchuanlby
//
//  Created by 林必义 on 2022/8/16.
//

#import "ML_CollectionViewFlowLayout.h"

@implementation ML_CollectionViewFlowLayout


- (CGSize)fixedCollectionCellSize:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake(round(scale * size.width) / scale, round(scale * size.height) / scale);
}

@end
