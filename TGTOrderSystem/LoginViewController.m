//
//  LoginViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/5.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "XGGHttpsManager.h"
#import "ShowTipView.h"


#import "AppUntils.h"
#import "LTDocument.h"
#import "V1HttpTool.h"
#import "V2HttpTool.h"

#define kContainerIdentifier @"iCloud.com.tgt.order"


@interface LoginViewController ()
{
    LoginView     *_loginView;
    
    MBProgressHUD *hud;
    
    int           _biaoZhi;
    
    NSString      *_iCloudUUID;
    
    BOOL          _isLoaded;
}

@property (strong, nonatomic) NSMutableDictionary *files;/* 文档文件信息，键为文件名，值为创建日期 */
@property (strong, nonatomic) NSMetadataQuery *query;/* 查询文档对象 */
@property (strong, nonatomic) LTDocument *document;/* 当前选中文档 */
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _biaoZhi = 0;

    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:0.1176 green:0.6784 blue:0.9255 alpha:1];
    
    //添加手势，点击周围隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
   
   // [self loadDocuments];
    
    
    [self initViews];
    
}

- (void) initViews {

    float width = ADAPTER(320);
    NSLog(@"%f",KScreenWidth);
    _loginView = [[LoginView alloc] initWithFrame:CGRectMake((KScreenWidth - width)/2, ADAPTER_HEIGHT(250), width, 240)];
    [self.view addSubview:_loginView];
    [_loginView.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *companyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight - 70, KScreenWidth, 20)];
    companyLab.font = [UIFont systemFontOfSize:14];
    companyLab.textColor = [UIColor whiteColor];
    companyLab.textAlignment = NSTextAlignmentCenter;
    companyLab.text = @"深圳市途鸽信息有限公司";
    [self.view addSubview:companyLab];
}

#pragma mark - 登录事件
- (void)loginAction:(UIButton *)sender {

    [_loginView.userName resignFirstResponder];
    [_loginView.password resignFirstResponder];
    
    
    if ([_loginView.userName.text isEqualToString:@""]) {
        
        [ShowTipView showTipView:self.view msg:@"请先输入账号"];
        return;
    }
    if ([_loginView.password.text isEqualToString:@""]) {
        
        [ShowTipView showTipView:self.view msg:@"请先输入密码"];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    // 参数
    NSString *uesrName = [_loginView.userName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pwd = [_loginView.password.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@/web/api/login?u=%@&p=%@",BaseURL_V2,uesrName,pwd];
    
    [XGGHttpsManager requstURL:url parametes:nil httpMethod:Http_GET progress:^(float progress) {
        ;
    } success:^(NSDictionary *dict, BOOL success) {
        /* 登录后将设备的UUID上传给服务器 */
        /* 从iCloud上加载UUID信息 */
       
        /* ------------------------- */
        
        NSLog(@"%@",dict);
        
       
        NSDictionary *dic = (NSDictionary *)dict;
        NSString *message = [NSString stringWithFormat:@"%@",dic[@"message"]];
        if ([message isEqualToString:@"<null>"]||[message isEqualToString:@"(null)"]||[message isEqualToString:@""]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
            NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
            [login setObject:@"YES" forKey:@"islogin"];
            [login setObject:uesrName forKey:@"TGTACOUNT"];
            [login synchronize];
            
            NSString *aID = [NSString stringWithFormat:@"%@",dic[@"a"]];
            NSString *user_id = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
            NSUserDefaults *aid = [NSUserDefaults standardUserDefaults];
            [aid setObject:aID forKey:@"aid"];
            [aid setObject:user_id forKey:@"user_id"];
            [aid synchronize];
           
            [self loadDocuments];

        } else {
            [ShowTipView showTipView:self.view msg:message];
            
            [self loadDocuments];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [hud hideAnimated:YES];
        [ShowTipView showTipView:self.view msg:@"登录失败，请重试"];
    }];
}
#pragma mark - tapAction
- (void)tapAction {
    
    [_loginView.userName resignFirstResponder];
    [_loginView.password resignFirstResponder];
}



/* 从iCloud上加载所有文档信息 */
- (void)loadDocuments
{
    if (!self.query) {
        self.query = [[NSMetadataQuery alloc] init];
        self.query.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];
        //注意查询状态是通过通知的形式告诉监听对象的
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(metadataQueryFinish:)
                                                     name:NSMetadataQueryDidFinishGatheringNotification
                                                   object:self.query];//数据获取完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(metadataQueryFinish:)
                                                     name:NSMetadataQueryDidUpdateNotification
                                                   object:self.query];//查询更新通知
    }
    //开始查询
    [self.query startQuery];
}


/* 查询更新或者数据获取完成的通知调用 */
- (void)metadataQueryFinish:(NSNotification *)notification
{
    NSLog(@"数据获取成功！======");
    NSArray *items = self.query.results;//查询结果集
    self.files = [NSMutableDictionary dictionary];
    //变量结果集，存储文件名称、创建日期
//    for (NSMetadataItem *item1 in items) {
//        NSString *fileName = [item1 valueForAttribute:NSMetadataItemFSNameKey];
//        NSLog(@"数据获取成功！===%@===",fileName);
//    }
        NSMetadataItem *item = items.firstObject;
        NSString *fileName = [item valueForAttribute:NSMetadataItemFSNameKey];
//        NSLog(@"数据获取成功！===%@===",fileName);
        if ([fileName hasPrefix:@"UUID.txt"]) {
            //获取文档URL
            NSURL *url = [self getUbiquityFileURL:fileName];
            //创建文档操作对象
            LTDocument *document = [[LTDocument alloc] initWithFileURL:url];
            self.document = document;
            //打开文档并读取文档内容
            [document openWithCompletionHandler:^(BOOL success) {
                if(success){
                    NSLog(@"读取数据成功.");
                    NSString *UUIDStr = [[NSString alloc] initWithData:document.data
                                                               encoding:NSUTF8StringEncoding];
                    [self.query stopQuery];
                   
                        [self PostUUIDToServer:UUIDStr];
                  
                }else{
                    NSLog(@"读取数据失败.");
                    [ShowTipView showTipView:self.view msg:@"错误9001"];
                }
            }];
        }
        else  //这一步重新获取是因为防止第一次登录app时不能获取iCloud上应有的数据
        {
           
            //获取文档URL
            NSURL *url = [self getUbiquityFileURL:@"UUID.txt"];
            //创建文档操作对象
            LTDocument *document = [[LTDocument alloc] initWithFileURL:url];
            self.document = document;
            //打开文档并读取文档内容
            [document openWithCompletionHandler:^(BOOL success) {
                if(success){
                    NSLog(@"读取数据成功.");
                    NSString *UUIDStr = [[NSString alloc] initWithData:document.data
                                                              encoding:NSUTF8StringEncoding];
                    [self.query stopQuery];
               
                    [self PostUUIDToServer:UUIDStr];
                   
                }else{
                    NSLog(@"读取数据失败.%i",_biaoZhi);
                    _biaoZhi = _biaoZhi+1;
                    [self addUUIDToiCloud];
                }
            }];

            
        }
  
}

/* 点击添加文档 */
- (void)addUUIDToiCloud {
  

    //创建文档URL
    NSString *fileName;
    if (_biaoZhi<15) {
    fileName = [NSString stringWithFormat:@"%i.txt",_biaoZhi];
    }
    else{
    fileName = [NSString stringWithFormat:@"UUID.txt"];
    }
    NSURL *url = [self getUbiquityFileURL:fileName];
    if (url) {
        //创建云端文档对象
        LTDocument *document = [[LTDocument alloc] initWithFileURL:url];
        //设置文档内容
        NSString *dataString;
        NSLog(@"==%@==",[AppUntils getUUIDString]);
        if (![AppUntils readUUIDFromKeyChain]) {
            dataString = @"";
        }
        dataString = [AppUntils getUUIDString];
        
        document.data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        //保存或创建文档，UIDocumentSaveForCreating是创建文档
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success)
         {
             if (success) {
                 NSLog(@"创建文档成功.");
                 
                 //从iCloud上加载所有文档信息
                
             }else{
                 NSLog(@"创建文档失败.");
                 [ShowTipView showTipView:self.view msg:@"错误9002"];
             }
             
         }];
    }
  
    else{
        
        [ShowTipView showTipView:self.view msg:@"您还未登录iCloud或没有打开iCloud Drive功能，请尝试后重新登陆"];
    }
}



#pragma  mark 登录后将设备的UUID上传给服务器
-(void)PostUUIDToServer:(NSString *)UUIDStr{
    /* 登录后将设备的UUID上传给服务器 */
    int i = _biaoZhi;
    NSLog(@"UUID###%@###",UUIDStr);
    
    NSDictionary *dict = @{@"uuid":UUIDStr};
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    NSString *sign_md5 = [V2HttpTool searchOrderWithUUID:dict requestTime:requestTime];
    NSDictionary *dic = @{@"accountId":@"tgt_ipad",
                          @"data":dict,
                          @"requestTime":@"time_test",
                          @"serviceName":@"queryLocatEquip",
                          @"sign":sign_md5,
                          @"version":@"OSSV2"};

    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];

    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hideAnimated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.queryLocatEquip",BaseURL_V2];
    NSURL *url1=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url1];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data_dic;
    NSURLSession *session=[NSURLSession  sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

        if(error == nil){
           
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                                
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                         NSLog(@"%@",dict[@"data"]);
                    NSDictionary *dicUUID = dict[@"data"];
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:dicUUID[@"code"] forKey:@"UUID"];
                    [user synchronize];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    //                    [alert show];
                } else if([dict[@"resultCode"] isEqualToString:@"3001"]){

                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UUID为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                        [alert show];
                }else if([dict[@"resultCode"] isEqualToString:@"3002"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UUID在系统不存在" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }else if([dict[@"resultCode"] isEqualToString:@"3003"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UUID在系统中重复" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                
            });
        } else {
           
        }
    }];
    
    [task resume];
}


#pragma mark - 私有方法
/**
 *  取得云端存储文件的地址
 *  @param fileName 文件名，如果文件名为nil，则重新创建一个URL
 *  @return 文件地址
 */
- (NSURL *)getUbiquityFileURL:(NSString *)fileName{
    //取得云端URL基地址(参数中传入nil则会默认获取第一个容器)，需要一个容器标示
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [manager URLForUbiquityContainerIdentifier:kContainerIdentifier];
    NSURL *url2 = [manager URLForUbiquityContainerIdentifier:nil];
    //取得Documents目录
    url = [url URLByAppendingPathComponent:@"Documents"];
    //取得最终地址
    url = [url URLByAppendingPathComponent:fileName];
    return url;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
