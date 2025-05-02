
#import "ML_PictureCell.h"

@interface ML_PictureCell()
@property (strong, nonatomic) UIImageView *ML_ImgV;
@end

@implementation ML_PictureCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        self.ML_ImgV = [[UIImageView alloc] init];
        self.ML_ImgV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.ML_ImgV];
        
        
        self.ML_PlayImgV = [[UIImageView alloc] init];
        self.ML_PlayImgV.image = kGetImage(@"icon_shiping_25_nor");
        [self.ML_ImgV addSubview:self.ML_PlayImgV];
        
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

}

- (void)setML_Picture:(NSString *)ML_Picture
{
    _ML_Picture = ML_Picture;
    
    [self.ML_ImgV sd_setImageWithURL:kGetUrlPath(ML_Picture) placeholderImage:kPlaceImage];
    
    self.ML_ImgV.frame = CGRectMake(0, 0, self.width, self.height);
    self.ML_PlayImgV.frame = CGRectMake(self.width / 2 - 15, self.height / 2 - 15, 30, 30);
}

@end
