//
//  ML_SearchBar.m
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "ML_SearchBar.h"
#import <Masonry/Masonry.h>

@interface ML_SearchBar()

@property (nonatomic,strong)UIImageView *ML_leftVIew;

@end


@implementation ML_SearchBar

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
          self.font = [UIFont systemFontOfSize:12];
          self.placeholder = Localized(@"搜索昵称/ID，寻找另一半的Ta", nil);
          self.backgroundColor = [UIColor whiteColor];
          self.layer.cornerRadius = 16*mHeightScale;
          //创建搜索框内的左侧搜索标志

          UIImageView *searchImage=[[UIImageView alloc]init];
          searchImage.image=[UIImage imageNamed:@"icon_search_nor"];
          searchImage.contentMode = UIViewContentModeCenter;  //居中
          //把标志放到搜索框内
          self.ML_leftVIew = searchImage;
          self.leftViewMode = UITextFieldViewModeAlways;
          [self addSubview:searchImage];
          [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.mas_equalTo(self.mas_left).mas_offset(18);
              make.centerY.mas_equalTo(self.mas_centerY);
              make.width.height.mas_equalTo(16);
          }];
          
          
    }
    return self;
}


+(instancetype)SearchBar{
    return [[self alloc]init];
}

//未编辑状态下的起始位置
 - (CGRect)textRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 42, 0);
 }
 // 编辑状态下的起始位置
 - (CGRect)editingRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 42, 0);
 }
 //placeholder起始位置
 - (CGRect)placeholderRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 42, 0);
 }



@end
