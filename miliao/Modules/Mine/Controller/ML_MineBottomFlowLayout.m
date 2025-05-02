//
//  ML_MineBottomFlowLayout.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/6.
//

#import "ML_MineBottomFlowLayout.h"
#import "ML_MineBottomLayoutAttributes.h"
#import "ML_MineBottomReusableView.h"
@implementation ML_MineBottomFlowLayout
+ (Class)layoutAttributesClass{
    return [ML_MineBottomLayoutAttributes class];
}

- (void)prepareLayout{
    [super prepareLayout];
    [self registerClass:[ML_MineBottomReusableView class] forDecorationViewOfKind:@"sectionBack"];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *Nattributes = [NSMutableArray arrayWithArray:attributes];

    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
   
    ML_MineBottomLayoutAttributes *decorationAttributes = [ML_MineBottomLayoutAttributes layoutAttributesForDecorationViewOfKind:@"sectionBack" withIndexPath:indexpath];
    decorationAttributes.frame = CGRectMake(0, 0, self.collectionViewContentSize.width, self.itemSize.height + 300);
    
    decorationAttributes.zIndex = -1;
    [Nattributes addObject:decorationAttributes];
    return Nattributes;
}

@end
