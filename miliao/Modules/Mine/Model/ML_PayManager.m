

#import "ML_PayManager.h"
#import <StoreKit/StoreKit.h>

@interface ML_PayManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic,strong) NSArray *profuctIdArr;
@property (nonatomic,copy) NSString *currentProId;
@property (nonatomic,copy) NSString *orderNumber;
//@property (nonatomic,copy) NSString *transaction_id;
@end

@implementation ML_PayManager

static ML_PayManager *__ML_PayManager;
+ (ML_PayManager *)sharedPayManager {
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        __ML_PayManager = [[ML_PayManager alloc]init];
        
    });
    return __ML_PayManager;
}


- (void)goChongWithProduct:(NSDictionary *)product
{

    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    if([SKPaymentQueue canMakePayments]){
        self.orderNumber = product[@"orderNumber"];
        _currentProId = [NSString stringWithFormat:@"%@", product[@"pid"]];
        [self requestProductData:_currentProId];
    }else{
        NSLog(@"不允许程序内付费");
    }

}

//请求商品
- (void)requestProductData:(NSString *)productId{
    NSLog(@"-------------请求对应的产品信息----------------");
    //
    [SVProgressHUD showWithStatus:Localized(@"加载中",nil) maskType:SVProgressHUDMaskTypeBlack];
    
    
    NSSet *nsset = [NSSet setWithObjects:productId, nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        [SVProgressHUD dismiss];
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_currentProId]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [SVProgressHUD show];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    [SVProgressHUD dismiss];
    NSLog(@"------------反馈信息结束-----------------");
}

//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    
    [SVProgressHUD show];
    for(SKPaymentTransaction *tran in transaction){
        
        
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"交易完成");
                [self verifyPurchaseWithPaymentTransaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self completeTransaction:tran];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"已经购买过商品");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [SVProgressHUD showErrorWithStatus:@"购买失败"];
            }
                break;
            default:
                break;
        }
    }
}

/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];

    //收据数据不为空
    if (receiptData.length == 0 || !receiptData) return;
    NSString *base64EncodeStr = [receiptData base64EncodedStringWithOptions:0];
    
    NSDictionary *param = @{@"receipt-data":base64EncodeStr};
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
//
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\", \"password\" : \"%@\"}", receiptString, @"01e3f0b4ec804bb2b573b4b9678b45bb"];//拼接请求数据
//    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        
    //创建请求到苹果官方进行购买验证 [ML_AppUtil isCensor]?AppStore:SANDBOX
    NSURL *url=[NSURL URLWithString:AppStore];
#if DEBUG
    url=[NSURL URLWithString:SANDBOX];
#endif
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        [SVProgressHUD dismiss];
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"responseData=====%@",dic);
    
    if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");
        [SVProgressHUD dismiss];
//        NSDictionary *dicReceipt= dic[@"receipt"];
//        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
//        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
//        self.transaction_id = [self giveformatter]; // dicInApp[@"transaction_id"];
        
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
//        NSString *dataStr = [receiptData base64EncodedString];
        [self payInfoReceiptdata:receiptString];
        
//        if (self.refreshBlock) {
//            self.refreshBlock(self.transaction_id);
//        }
        
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}

//付款成功后告诉后台
- (void)payInfoReceiptdata:(NSString *)receiptString{
    
      kSelf;
      ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"receipt" : receiptString, @"orderNumber" : self.orderNumber} urlStr:@"wallet/applePayNotify"];
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
     } error:^(MLNetworkResponse *response) {
  
     } failure:^(NSError *error) {
  
     }];
      
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

+ (void)zhiChongGo
{
    
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict
{

    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}

@end
