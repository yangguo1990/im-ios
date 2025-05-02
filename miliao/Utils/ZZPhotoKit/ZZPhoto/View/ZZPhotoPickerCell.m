//
//  ZZPhotoPickerCell.m
//  ZZFramework
//
//  Created by Yuan on 15/7/7.
//  Copyright (c) 2015年 zzl. All rights reserved.
//

#import "ZZPhotoPickerCell.h"
#import "ZZAlumAnimation.h"
@implementation ZZPhotoPickerCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _photo = [[UIImageView alloc]initWithFrame:self.bounds];
        
        _photo.layer.masksToBounds = YES;
        
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_photo];
        
        
        CGFloat btnSize = self.frame.size.width / 4;
        
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - btnSize - 5, 5, btnSize, btnSize)];
        [_selectBtn addTarget:self action:@selector(selectPhotoButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
        
        _videoTimeLab = [[UILabel alloc]init];
        _videoTimeLab.text = @"1.0.3";
        _videoTimeLab.hidden = YES;
        _videoTimeLab.textAlignment = NSTextAlignmentLeft;
        _videoTimeLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _videoTimeLab.frame = CGRectMake(5, self.frame.size.height - _videoTimeLab.frame.size.height - 20, self.frame.size.width, 20);
        _videoTimeLab.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_videoTimeLab];
    }
    return self;
}

-(void) selectPhotoButtonMethod:(UIButton *)sender
{
    [[ZZAlumAnimation sharedAnimation] selectAnimation:sender];
    self.selectBlock();
    
}

-(void)setIsSelect:(BOOL)isSelect
{
    if (isSelect == YES) {
        [_selectBtn setImage:Pic_Btn_Selected forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
    }
}


-(void)loadPhotoData:(ZZPhoto *)photo
{
    if (photo.isSelect == YES) {
        [_selectBtn setImage:Pic_Btn_Selected forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
    }

    if (photo.asset.mediaType == PHAssetMediaTypeVideo) {
        _videoTimeLab.hidden = NO;
        _videoTimeLab.text = [self timeFormatted:photo.asset.duration];
    }else{
        _videoTimeLab.hidden = YES;
    }
    
    if ([photo isKindOfClass:[ZZPhoto class]]) {

        [[PHImageManager defaultManager] requestImageForAsset:photo.asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
            
            self.photo.image = result;
            
        }];
        
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;

    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


@end
