//
//  MLFabuDynamicViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLFabuDynamicViewController.h"
#import "MLFabudynamicTableViewCell.h"
#import "MLFabudynamicTextTableViewCell.h"
#import "MLFabuAddrListViewController.h"
#import "MLFabuSelectCollectionViewCell.h"
#import "ZZPhotoKit.h"
#import "MLFapublishDynamicApi.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import "ML_getUploadSignApi.h"
#import "ML_getUploadToken.h"
#import "TZLocationManager.h"
#import <Masonry/Masonry.h>
#import "UIViewController+MLHud.h"
#import "MLMineDynameicViewController.h"


@interface MLFabuDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,ZZBrowserPickerDelegate, CLLocationManagerDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) UITableView *tab;
@property (nonatomic,strong)UICollectionView *daywbtopitemview;

@property(strong  ,nonatomic) NSMutableArray *picArray;
@property (nonatomic,strong)ZZPhoto *photo;
@property (nonatomic,strong)NSMutableArray *nmarray;
@property (nonatomic,strong)NSMutableArray *imgnmarray;
@property (nonatomic,strong)UILabel *titlenumber;

@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *textViewStr;
@property (nonatomic,strong)OSSClient *client;
@property (nonatomic,strong)NSDictionary *userDict;

@property (nonatomic,strong)NSDictionary *dataDict;

@property (nonatomic,strong)NSString *toalpath;
@property (nonatomic,strong)NSMutableArray *imgdata;
@property (nonatomic,strong)NSMutableArray *titledata;
@property (nonatomic,strong)NSMutableArray *imageyuantu;
@property (nonatomic,strong)NSURL *htmlurl;
@property (nonatomic,copy)NSString *videopathhtml;

@property (nonatomic,assign)BOOL isVideo;
@property (nonatomic,assign)BOOL isDing;
@property (nonatomic,assign)BOOL isDing2;
@property (nonatomic,copy)NSString *videtype;
@property (nonatomic,strong)NSData *videodata;
@property (nonatomic,assign)BOOL isClick;

@end

@implementation MLFabuDynamicViewController


-(NSMutableArray *)imageyuantu{
    if (_imageyuantu == nil) {
        _imageyuantu = [NSMutableArray array];
    }
    return _imageyuantu;
}

-(NSMutableArray *)titledata{
    if (_titledata == nil) {
        _titledata = [NSMutableArray array];
    }
    return _titledata;
}

-(NSMutableArray *)imgdata{
    if (_imgdata == nil) {
        _imgdata = [NSMutableArray array];
    }
    return _imgdata;
}

//获取上传凭证----暂时不调用---
-(void)getUploadToken{
    ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc]initWithfileName:@"" dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        self.dataDict = response.data[@"sts"];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

//获取上传签名 ---暂时不调----
-(void)getUploadSignApi{
    ML_getUploadSignApi *SignApi = [[ML_getUploadSignApi alloc]initWithdev:@"" token:@"18392399714" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [SignApi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        self.userDict = response.data[@"sign"];
        //[self commitPictureToAliyunOSS:response.data[@"sign"]];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

-(NSMutableArray *)picArray{
    if (_picArray == nil) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

-(NSMutableArray *)nmarray{
    if (_nmarray == nil) {
        _nmarray = [NSMutableArray array];
    }
    return _nmarray;
}

-(NSMutableArray *)imgnmarray{
    if (_imgnmarray == nil) {
        _imgnmarray = [NSMutableArray array];
    }
    return _imgnmarray;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isDing = YES;
    self.isDing2 = NO;
    [self getUploadToken];
    [self getUploadSignApi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *topBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 88*mHeightScale)];
    topBG.image = kGetImage(@"bg_top");
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gaiTongwei) name:@"gaiTongwei" object:nil];
    
    self.isEnablePanGesture = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    self.ML_titleLabel.text = Localized(@"发布动态", nil);

    self.address = Localized(@"请选择定位", nil);
    self.textViewStr = @"";
    [self setupUI];
    self.isClick = YES;
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tanBack) name:@"tanBack" object:nil];
}

-(void)backAction{
    MLMineDynameicViewController *vc = [[MLMineDynameicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupUI{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.layer.backgroundColor = kZhuColor.CGColor;
//    btn.layer.cornerRadius = 25;
    [btn setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
    [btn setTitle:Localized(@"发布", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];

    UICollectionViewFlowLayout *daylayout = [UICollectionViewFlowLayout new];
    //1-1、设置Cell大小
    daylayout.itemSize= CGSizeMake((self.view.frame.size.width-40)/3, 90);
    //1-2、设置四周边距
    daylayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    daylayout.minimumInteritemSpacing = 10;
    UICollectionView *daywbtopitemview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:daylayout];
    daywbtopitemview.backgroundColor = [UIColor whiteColor];
    [daywbtopitemview registerClass:[MLFabuSelectCollectionViewCell class] forCellWithReuseIdentifier:@"daywbFlow"];
    daywbtopitemview.delegate = self;
    daywbtopitemview.dataSource = self;
    daylayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    daywbtopitemview.showsVerticalScrollIndicator = NO;
    daywbtopitemview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:daywbtopitemview];
    self.daywbtopitemview = daywbtopitemview;
    [daywbtopitemview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight);
        make.height.mas_equalTo(152);
    }];

    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.backgroundColor = [UIColor whiteColor];
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    tab.scrollEnabled = NO;
    tab.tableFooterView = [UIView new];
    [self.view addSubview:tab];
    self.tab = tab;
    [tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(daywbtopitemview.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-20);
    }];
}

#pragma mark --- fabudongtai-----------

-(void)btnClick{
    NSLog(@"fabu....");
    if (self.picArray.count == 0) {
        [self showMessage:@"请至少上传一张照片或者一个视频"];
        return;
    }
    if (![self.textViewStr length]) {
        [self showMessage:Localized(@"请输入内容", nil)];
        return;
    }
    if ([self.address isEqualToString:Localized(@"请选择定位", nil)]) {
        self.address = @"";
    }

    if (self.isClick == NO) {
        return;
    }
    
    [self.picArray enumerateObjectsUsingBlock:^(ZZPhoto *photo, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"newimage-----%@",photo.originImage);
        if (self.isVideo == YES) {
            self.videodata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.videopathhtml]];
        }else{
            self.videodata = UIImageJPEGRepresentation(photo.originImage, 0.5f);
        }
        [self.imageyuantu addObject:self.videodata];
    }];
    [self ImageAyyay:self.imageyuantu success:^(NSArray *resarray) {
        [resarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.imgdata addObject:obj];
        }];
    }];
    if (self.isVideo == YES) {
        self.videtype = @"1";
    }else{
        self.videtype = @"0";
    }
    self.isClick = NO;
    self.daywbtopitemview.userInteractionEnabled = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ssssss = [self gs_jsonStringCompactFormatForNSArray:self.imgdata.copy];
    MLFapublishDynamicApi *api = [[MLFapublishDynamicApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] type:self.videtype dynamic:ssssss chargeId:@"" title:self.textViewStr location:self.address latitudeAndLongitude:[NSString stringWithFormat:@"%@,%@",[defaults objectForKey:@"longstr"],[defaults objectForKey:@"latstr"]]]; //self.address
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"发布动态-----%@",response.data);
        self.isClick = YES;
        self.daywbtopitemview.userInteractionEnabled = YES;
        if ([response.status integerValue] == 0) {
            [self showMessage:@"发布动态成功,等待审核中"];
        }else{
            [self showMessage:@"发布动态失败,请重新发布"];
        }
        [self.navigationController popViewControllerAnimated:YES];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

//将数组转换成json格式字符串,不含 这些符号
-(NSString *)gs_jsonStringCompactFormatForNSArray:(NSArray *)arrJson {
    if (![arrJson isKindOfClass:[NSArray class]] || ![NSJSONSerialization isValidJSONObject:arrJson]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}


#pragma mark --- 图片上传------------
-(void)commitPictureToAliyunOSSimg:(UIImage *)img toalpath:(NSString *)toalpath{
    NSString *accessKey = self.dataDict[@"accessKeyId"];
    NSString *secretKey = self.dataDict[@"accessKeySecret"];
    NSString *endpoint = self.dataDict[@"endpoint"];
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accessKey secretKeyId:secretKey securityToken:self.dataDict[@"securityToken"]];
    self.client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];

    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = self.dataDict[@"bucketName"];;
    //self.toalpath = toalpath;
    put.objectKey = toalpath;
    // 直接上传NSData。
        put.uploadingData = UIImageJPEGRepresentation(img, 0.5);
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
            NSLog(@"%lld, %lld, %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
        };
    dispatch_queue_t subQueue = dispatch_queue_create("uploadvoice", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(subQueue, ^{
            OSSTask * putTask = [self.client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
            [putTask waitUntilFinished];
            [put cancel];
        });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        MLFabudynamicTextTableViewCell *cell = [[MLFabudynamicTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textcell"];
        if (cell == nil) {
            cell = [[MLFabudynamicTextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"textcell"];

        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if ([self.textViewStr isEqualToString:@""]) {
//            cell.textView.text = Localized(@"给大家介绍一下吧~", nil);
//        }else{
            cell.textView.text = self.textViewStr;
//        }
       
        [cell setTextviewStrBlock:^(NSString * _Nonnull textViewStr) {
            NSLog(@"textViewStr----%@",textViewStr);
            self.textViewStr = textViewStr;
        }];
        return cell;
    }else{
        MLFabudynamicTableViewCell *cell = [[MLFabudynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[MLFabudynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.indextitlelabel.text = self.address;
        if (![self.address isEqualToString:Localized(@"请选择定位", nil)]) {
            cell.titlelabel.text = self.address;
            cell.indextitlelabel.hidden = YES;
        }else{
            cell.titlelabel.text = Localized(@"我的位置", nil);
            cell.indextitlelabel.hidden = NO;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 173;
    }else{
        return 60;
    }
}



- (void)gaiTongwei
{
    
    self.isDing = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {

        
        if (!self.isDing) {

            [self opentNotificationAlertWithTitle:@"定位"];
        }
        
        [TZLocationManager.manager startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
            CLLocation *CurrentLocation = [locations lastObject];
   
            self.isDing = YES;
                NSLog(@"9999");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%f", CurrentLocation.coordinate.longitude] forKey:@"longstr"];
            [defaults setObject:[NSString stringWithFormat:@"%f", CurrentLocation.coordinate.latitude] forKey:@"latstr"];
        //    NSString *lo = [defaults objectForKey:@"longstr"]?:@"";
        //    NSString *la = [defaults objectForKey:@"latstr"]?:@"";
            [defaults synchronize];
            
            if (!self.isDing2) {
//                self.isDing = YES;
                self.isDing2 = YES;
                MLFabuAddrListViewController *vc = [[MLFabuAddrListViewController alloc]init];
                [vc setReturntextBlock:^(NSString * _Nonnull showText) {
                    self.address = showText;
                    [self.tab reloadData];
                }];
               
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        } failureBlock:^(NSError *error) {
            NSLog(@"8888");

                
                self.isDing = NO;

        }];
        
        
    }
}


#pragma mark - 定位处理
-(void)ML_StartLocation{

    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager *LocationManager = [[CLLocationManager alloc]init];
        LocationManager.delegate = self;
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        LocationManager.distanceFilter = 10.0f;
        [LocationManager requestWhenInUseAuthorization];
        [LocationManager startUpdatingLocation];
    }
    else
    {
        //不能定位提示
        UIAlertController *AlertVC = [UIAlertController alertControllerWithTitle:Localized(@"允许\"定位\"提示",nil) message:Localized(@"请在设置中打开定位",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *Enter = [UIAlertAction actionWithTitle:Localized(@"打开定位",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *SettingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:SettingsUrl];
        }];
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:Localized(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [AlertVC addAction:Enter];
        [AlertVC addAction:Cancel];
        [self presentViewController:AlertVC animated:YES completion:nil];
    }
}

#pragma mark---------定位失败-----------

-(void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error{
    if([error code] ==kCLErrorDenied){

    } else if([error code] ==kCLErrorDenied){
        //访问被拒绝
        kplaceToast(@"位置访问被拒绝")
    } else if ([error code] == kCLErrorLocationUnknown) {

       kplaceToast(@"无法获取位置信息")
    } else {
        NSLog(@"定位error-----%@", error);
    }
    // Privacy - Location Always and When In Use Usage Description和Privacy - Location When In Use Usage Description

}




#pragma mark ------- UICollectionView---------
#pragma mark -点击item----collectionDelegate-----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.picArray.count == 0) {
        return 1;
    }else{
        if (self.isVideo) {
            return self.picArray.count;
        }else{
            if (self.picArray.count == 9) {
                return self.picArray.count;
            }else{
                return self.picArray.count + 1;
            }
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.picArray.count == 0) {
        MLFabuSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"daywbFlow" forIndexPath:indexPath];
            //从数组里面把model取出来
            //用photo对象中的originImage属性来展示图片
        cell.img.image = [UIImage imageNamed:@"editInfo_add_picture"];
        cell.delectimg.hidden = YES;
        return cell;
    }else{
        
        if (self.picArray.count == 9 || self.isVideo) {
            MLFabuSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"daywbFlow" forIndexPath:indexPath];
            //从数组里面把model取出来
            [self.nmarray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                cell.delectimg.hidden = NO;
             cell.cancel_block = ^{
                NSLog(@"删除。。。。。");
                 [self.picArray removeObjectAtIndex:indexPath.row];
                 NSLog(@"删除--picArray-----%@---%lu",self.picArray,(unsigned long)self.picArray.count);
                 self.titlenumber.text = [NSString stringWithFormat:@"上传照片(%lu/9)",(unsigned long)self.picArray.count];
                 [self.daywbtopitemview reloadData];
                };
                //用photo对象中的originImage属性来展示图片
                self.photo = [self.picArray objectAtIndex:indexPath.row];
                cell.img.image = self.photo.originImage;
            return cell;

    }else{
        NSInteger totalRow = [collectionView numberOfItemsInSection:indexPath.section];//first get total rows in that section by current
        if (indexPath.row == totalRow -1) {
            MLFabuSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"daywbFlow" forIndexPath:indexPath];
                //从数组里面把model取出来
                //用photo对象中的originImage属性来展示图片
            cell.img.image = [UIImage imageNamed:@"Slice 13"];
            cell.delectimg.hidden = YES;
            return cell;
        }else{
            MLFabuSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"daywbFlow" forIndexPath:indexPath];
                //从数组里面把model取出来
            [self.nmarray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                cell.delectimg.hidden = NO;
             cell.cancel_block = ^{
                NSLog(@"删除。。。。。");
                 [self.picArray removeObjectAtIndex:indexPath.row];
                 NSLog(@"删除--picArray-----%@---%lu",self.picArray,(unsigned long)self.picArray.count);
                 self.titlenumber.text = [NSString stringWithFormat:@"上传照片(%lu/9)",(unsigned long)self.picArray.count];
                 [self.daywbtopitemview reloadData];
                };
                //用photo对象中的originImage属性来展示图片
                self.photo = [self.picArray objectAtIndex:indexPath.row];
                cell.img.image = self.photo.originImage;
            return cell;
             }
          }
        }
  }


- (NSURL *)jjMovConvert2Mp4:(NSURL *)movUrl{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetMediumQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [self dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    return mp4Url;
}

- (NSString*)dataPath{
    NSString *dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dataPath]){
        [fm createDirectoryAtPath:dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    return dataPath;
}

- (void)bigViewClick:(UIGestureRecognizer *)gr
{
    [gr.view removeFromSuperview];
}

- (void)handleSwipeFrom
{
    ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
    tanV.dic = @{@"type" : @(ML_TanchuangViewType_DongBao), @"data" : Localized(@"是否退出此次动态编辑，退出后此条动态不被保存", nil)};
    tanV.ML_TanchuangClickBlock = ^(NSInteger tag) {
        if (tag == 1) {
            [super ML_backClickklb_la];
        }
    };
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row < self.picArray.count) {
        
        ZZPhoto *photo = [self.picArray objectAtIndex:indexPath.row];

        UIImageView *bigView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        bigView.backgroundColor = [UIColor blackColor];
        bigView.userInteractionEnabled = YES;
        bigView.contentMode = UIViewContentModeScaleAspectFit;
        bigView.image = photo.originImage;
        [KEY_WINDOW.window addSubview:bigView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigViewClick:)];
        [bigView addGestureRecognizer:tap];
        
        
        return;
    }
    
    ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
    photoController.selectPhotoOfMax = 9 - self.picArray.count;
    //设置相册中完成按钮旁边小圆点颜色。
//        photoController.roundColor = [UIColor greenColor];
    [photoController showIn:self result:^(id responseObject){
        //self.picArray = (NSMutableArray *)responseObject;
        //[mutableArray addObjectsFromArray:array1];
        [self.picArray addObjectsFromArray:responseObject];
        NSLog(@"555555----%@",self.picArray);
        //self.titlenumber.text = [NSString stringWithFormat:@"上传照片(%lu/9)",(unsigned long)self.picArray.count];
        ZZPhoto *phont = self.picArray[0];
        if (phont.type == 2) {
            self.isVideo = YES;
        }else{
            self.isVideo = NO;
        }
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        [[PHImageManager defaultManager] requestAVAssetForVideo:phont.asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                AVURLAsset* urlAsset = (AVURLAsset*)asset;
                NSNumber *size;
                [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                NSLog(@"url--------%@",urlAsset.URL);
                //调用MOV转换成Mp4
                NSString *filePath = [[self jjMovConvert2Mp4: urlAsset.URL] absoluteString];
                //NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
               self.videopathhtml = filePath;
                self.isVideo = YES;
               // NSLog(@"size is %f",[size floatValue]/(1024.0*1024.0));
         }
        }];
        [self.daywbtopitemview reloadData];
    }];
}

-(void)ImageAyyay:(NSArray *)dataSoure success:(void (^)(id res))success{
    NSMutableArray * array = [NSMutableArray array];
//    NSString *endpoint = @"https://oss-cn-shenzhen.aliyuncs.com";//后台给的
    
    NSString *endpoint = self.dataDict[@"endpoint"];
//    NSString *endpoint = @"oss.zgdouyou.com";;
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.dataDict[@"accessKeyId"] secretKeyId:self.dataDict[@"accessKeySecret"] securityToken:self.dataDict[@"securityToken"]];//以上三个参数都是后台给的
    self.client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];

    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    for (int i = 0; i<dataSoure.count; i++) {
        put.bucketName = self.dataDict[@"bucketName"];;
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        NSString *str = [formatter stringFromDate:date];
        NSString *ttttt = [self giveformatter];
        NSString *iconpath = [NSString stringWithFormat:@"%@/%@%d",str,ttttt,i];
        //NSString *toalpath = [NSString stringWithFormat:@"%@.mp4",iconpath];
        if (self.isVideo == YES) {
            self.toalpath = [NSString stringWithFormat:@"%@.mp4",iconpath];
        }else{
            self.toalpath = [NSString stringWithFormat:@"%@.png",iconpath];
        }
        put.objectKey = self.toalpath;
        put.uploadingData = dataSoure[i]; // 直接上传NSData字节
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        };
        OSSTask * putTask = [self.client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                [array addObject:put.objectKey];//多张图片时这里面存放的图片名字的数组在把这些名字弄成json字符串 给服务器
                if (dataSoure.count > 1) {
                    if (i == dataSoure.count-1) {
                        success(array);
                    }
                }else{
                    success(array);
                }
            } else {
                NSLog(@"upload object failed, error: %@" , task.error);
            }
            return nil;
        }];
        [putTask waitUntilFinished];
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gaiTongwei" object:nil];
}

@end
