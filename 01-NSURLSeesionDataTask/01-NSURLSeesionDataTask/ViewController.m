//
//  ViewController.m
//  01-NSURLSeesionDataTask
//
//  Created by qingyun on 16/4/29.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

#define KURLStr @"http://www.weather.com.cn/data/cityinfo/101010100.html"
@interface ViewController ()
@end

@implementation ViewController

- (IBAction)touchRequest:(id)sender {
    //1.创建会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    //2.创建dataLoadtask对象，任务
    NSURLSessionDataTask *loadTask=[session dataTaskWithURL:KURLStr completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //2.1.是否请求成功
        NSLog(@"=======%@",error);
        NSHTTPURLResponse *HttpResponse=(NSHTTPURLResponse *)response;
        if (HttpResponse.statusCode==200) {
           //2.2数据解析
            NSString *objStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"=========%@",objStr);
           //3.更新UI
            
        }
    }];
    //3.启动任务
    [loadTask resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
