//
//  ViewController.m
//  02-NSURLSessionDownLoadTask
//
//  Created by qingyun on 16/4/29.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#define KurlStr @"http://img2.3lian.com/img2007/19/33/005.jpg"


@interface ViewController ()<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation ViewController


- (IBAction)requestClick:(id)sender {
#if 0 //1.创建会话对象
    NSURLSession *seesion=[NSURLSession sharedSession];
    //2.创建下载任务
    __weak UIImageView *tempView=_imageView;
    NSURLSessionDownloadTask *task=[seesion downloadTaskWithURL:[NSURL URLWithString:KurlStr] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //处理下载结果
        NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
        if (httpResponse.statusCode==200) {
         //获取图片
            NSData *iconData=[[NSData alloc] initWithContentsOfURL:location];
            UIImage *image=[UIImage imageWithData:iconData];
         //更新UI 主线程更新
            dispatch_async(dispatch_get_main_queue(), ^{
                tempView.image=image;
            });
        }
    }];
    //启动任务
    [task resume];
#endif
    //1.创建会话对象
    NSURLSession *seesion=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    //2.创建下载任务
    NSURLSessionDownloadTask *task=[seesion downloadTaskWithURL:[NSURL URLWithString:KurlStr]];
    
    //3.启动任务
    [task resume];
}

#pragma mark   NSURLSessionDownLoadTaskDelegate

//下载完成时候调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
//1.取出图片
    NSData *data=[[NSData alloc] initWithContentsOfURL:location];
    UIImage *image=[UIImage imageWithData:data];
    __weak UIImageView *tempView=_imageView;
//2.更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        tempView.image=image;
    });
}
//重复调用
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //1进度比例
    float value=(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
    //2.更新进度条
    __weak UIProgressView *tempView=_progressView;
    
     dispatch_async(dispatch_get_main_queue(), ^{
         tempView.progress=value;
     });
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
