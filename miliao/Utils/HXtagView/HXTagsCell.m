//
//  HXTagsCell.m
//  HXTagsView https://github.com/huangxuan518/HXTagsView
//  博客地址 http://blog.libuqing.com/
//  Created by Love on 16/6/30.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "HXTagsCell.h"
#import "HXTagCollectionViewCell.h"
#import "HXTagAttribute.h"
#import <Masonry.h>
#import <Colours/Colours.h>

@interface HXTagsCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong)UIView *liveV2;
@end

@implementation HXTagsCell

static NSString * const reuseIdentifier = @"HXTagCollectionViewCellId";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, self.frame.size.width, 30)];
    //label.text = Localized(@"基本资料", nil);
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    label.textColor = [UIColor colorFromHexString:@"#333333"];
    [self addSubview:label];
    self.namelabel = label;
    
    
//    self.liveV2.frame = CGRectMake(16, self.cellHeight - 11, ML_ScreenWidth - 32, 1);
    //@property (nonatomic,strong)UIView *liveV2;
    UIView *liveV2 = [[UIView alloc] init];
    liveV2.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.contentView addSubview:liveV2];
    self.liveV2 = liveV2;
    //初始化样式
//    _tagAttribute = [HXTagAttribute new];
//    
//    _layout = [[HXTagCollectionViewFlowLayout alloc] init];
//    [self addSubview:self.collectionView];
}

- (void)setTags2:(NSArray *)tags2
{
    _tags2 = tags2;
    if (!tags2.count) return;
    
    for (UIView *sV in self.collectionView.subviews) {
        if (sV.tag > 99) {
            [sV removeFromSuperview];
        }
    }
    
    if (tags2.count) {
        
        CGFloat maxX = 16;
        int i = 0;
        int row = 0;
        int col = 0;

        
        for (NSDictionary *aDic in tags2) {
          
             NSString  * str = aDic[@"name"];
            
            UILabel *label = [[UILabel alloc] init];

            
            label.tag = 100 + i;
            if (aDic[@"num"]) {
                
                label.text = [NSString stringWithFormat:@"%@x%@", str, aDic[@"num"]];
            } else {
                
                label.text = str;
            }
            
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 30)];
            
            size.width += 30;
            label.frame = CGRectMake(maxX, 56 + row * (12 + 30), size.width, 30);
            if (CGRectGetMaxX(label.frame) >= (ML_ScreenWidth-16)) {
                maxX = 16;
                col = 0;
                row += 1;
            }
            label.frame = CGRectMake(maxX, 56 + row * (12 + 30), size.width, 30);
            
            if (CGRectGetMaxX(label.frame) < (ML_ScreenWidth-16)) {
                col += 1;
            }
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            label.layer.borderColor = [[UIColor colorWithHexString:aDic[@"color"]] CGColor]?:[UIColor colorWithHexString:@"#cccccc"].CGColor;
            label.layer.cornerRadius = 15;
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 0.5;
            label.textColor = [UIColor colorWithHexString:aDic[@"color"]]?:[UIColor colorWithHexString:@"#666666"];
            label.font = [UIFont systemFontOfSize:14];
            [self addSubview:label];
            maxX = CGRectGetMaxX(label.frame) + 12;
            
            
            
            if (i == (tags2.count-1)) {
                self.cellHeight = CGRectGetMaxY(label.frame);
            }
            
            i++;
            
        }
    } else {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 56 + 12, ML_ScreenWidth - 32, 46)];
        label.tag = 120;
        label.layer.cornerRadius = 23;
        label.layer.masksToBounds = YES;
        if ([self.namelabel.text isEqualToString:Localized(@"印象标签", nil)]) {
            label.text = @"您还没有设置您的个人标签呢~";
        } else {
            label.text = @"还没有用户对主播进行评价哦~";
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.cellHeight = CGRectGetMaxY(label.frame);
    }
    
    self.liveV2.frame = CGRectMake(16, self.cellHeight + 11, ML_ScreenWidth - 32, 1);

}

- (void)setTags:(NSArray *)tags
{
    _tags = tags;
    
    for (UIView *sV in self.collectionView.subviews) {
        if (sV.tag > 99) {
            [sV removeFromSuperview];
        }
    }
    
    CGFloat maxX = 16;
    int i = 0;
    int row = 0;
    int col = 0;
    for (NSString *tagStr in tags) {
        
        CGSize size = [tagStr sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 30)];
        size.width += 30;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(maxX, 56 + row * (12 + 30), size.width, 30)];

        if (CGRectGetMaxX(label.frame) >= (ML_ScreenWidth-16)) {
            maxX = 16;
            col = 0;
            row += 1;
        }
        label.frame = CGRectMake(maxX, 56 + row * (12 + 30), size.width, 30);
        
        if (CGRectGetMaxX(label.frame) < (ML_ScreenWidth-16)) {
            col += 1;
        }
        
        label.tag = 100 + i;
        label.text = tagStr;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
        label.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        label.layer.cornerRadius = 15;
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 0.5;
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        maxX = CGRectGetMaxX(label.frame) + 12;
        
        
        
        if (i == (tags.count-1)) {
            self.cellHeight = CGRectGetMaxY(label.frame);
            NSLog(@"adsf==adsf===%f",  CGRectGetMaxY(label.frame));
        }
        
        i++;
        
    }
    self.liveV2.frame = CGRectMake(16, self.cellHeight + 11, ML_ScreenWidth - 32, 1);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.namelabel.frame = CGRectMake(16, 16, self.frame.size.width, 30);
    
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return _tags.count;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    HXTagCollectionViewFlowLayout *layout = (HXTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
//    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
//
//    CGRect frame = [_tags[indexPath.row] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_tagAttribute.titleSize]} context:nil];
//
//    return CGSizeMake(frame.size.width + _tagAttribute.tagSpace, layout.itemSize.height);
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    HXTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = _tagAttribute.normalBackgroundColor;
//    cell.layer.borderColor = _tagAttribute.borderColor.CGColor;
//    //cell.layer.cornerRadius = _tagAttribute.cornerRadius;
//    cell.layer.cornerRadius = 15;
//    //cell.layer.borderWidth = _tagAttribute.borderWidth;
//    cell.layer.borderWidth = 0.5;
//    cell.titleLabel.textColor = _tagAttribute.textColor;
//    cell.titleLabel.font = [UIFont systemFontOfSize:_tagAttribute.titleSize];
//
//    NSString *title = self.tags[indexPath.row];
//    if (_key.length > 0) {
//        cell.titleLabel.attributedText = [self searchTitle:title key:_key keyColor:_tagAttribute.keyColor];
//    } else {
//        cell.titleLabel.text = title;
//    }
//
//    if ([self.selectedTags containsObject:self.tags[indexPath.row]]) {
//        cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
//    }
//
//    return cell;
//}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    HXTagCollectionViewCell *cell = (HXTagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//
//    if ([self.selectedTags containsObject:self.tags[indexPath.row]]) {
//        cell.backgroundColor = _tagAttribute.normalBackgroundColor;
//        [self.selectedTags removeObject:self.tags[indexPath.row]];
//    }
//    else {
//        if (_isMultiSelect) {
//            cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
//            [self.selectedTags addObject:self.tags[indexPath.row]];
//        } else {
//            [self.selectedTags removeAllObjects];
//            [self.selectedTags addObject:self.tags[indexPath.row]];
//
//            [self reloadData];
//        }
//    }
//
//    if (_completion) {
//        _completion(self.selectedTags,indexPath.row);
//    }
//}

//// 设置文字中关键字高亮
//- (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor {
//
//    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
//    NSString *copyStr = title;
//
//    NSMutableString *xxstr = [NSMutableString new];
//    for (int i = 0; i < key.length; i++) {
//        [xxstr appendString:@"*"];
//    }
//
//    while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
//
//        NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
//
//        [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
//        copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
//    }
//    return titleStr;
//}
//
//- (void)reloadData {
//    [self.collectionView reloadData];
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//   // _collectionView.frame = self.bounds;
//
//    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(self);
//        make.top.mas_equalTo(self.namelabel.mas_bottom);
//    }];
//
//}
//
//#pragma mark - 懒加载
//
//- (NSMutableArray *)selectedTags
//{
//    if (!_selectedTags) {
//        _selectedTags = [NSMutableArray array];
//    }
//    return _selectedTags;
//}

//- (UICollectionView *)collectionView {
//    if (!_collectionView) {
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 362) collectionViewLayout:_layout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = UIColor.whiteColor;
//        //_collectionView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
//        [_collectionView registerClass:[HXTagCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    }
//
//    _collectionView.collectionViewLayout = _layout;
//
//    if (_layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
//        //垂直
//        _collectionView.showsVerticalScrollIndicator = YES;
//        _collectionView.showsHorizontalScrollIndicator = NO;
//    } else {
//        _collectionView.showsHorizontalScrollIndicator = YES;
//        _collectionView.showsVerticalScrollIndicator = NO;
//    }
//
//    //_collectionView.frame = self.bounds;
//
//    return _collectionView;
//}
//
//+ (CGFloat)getCellHeightWithTags:(NSArray *)tags layout:(HXTagCollectionViewFlowLayout *)layout tagAttribute:(HXTagAttribute *)tagAttribute width:(CGFloat)width
//{
//    CGFloat contentHeight = 0;
//
//    if (!layout) {
//        layout = [[HXTagCollectionViewFlowLayout alloc] init];
//    }
//
//    if (tagAttribute.titleSize <= 0) {
//        tagAttribute = [[HXTagAttribute alloc] init];
//    }
//
//    //cell的高度 = 顶部 + 高度
//    contentHeight = layout.sectionInset.top + layout.itemSize.height;
//
//    CGFloat originX = layout.sectionInset.left;
//    CGFloat originY = layout.sectionInset.top;
//
//    NSInteger itemCount = tags.count;
//
//    for (NSInteger i = 0; i < itemCount; i++) {
//        CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
//
//        CGRect frame = [tags[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:tagAttribute.titleSize]} context:nil];
//
//        CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagSpace, layout.itemSize.height);
//
//        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
//            //垂直滚动
//            //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
//            if ((originX + itemSize.width + layout.sectionInset.right) > width) {
//                originX = layout.sectionInset.left;
//                originY += itemSize.height + layout.minimumLineSpacing;
//
//                contentHeight += itemSize.height + layout.minimumLineSpacing;
//            }
//        }
//
//        originX += itemSize.width + layout.minimumInteritemSpacing;
//    }
//
//    contentHeight += layout.sectionInset.bottom;
//    return contentHeight + 46;
//}

@end
