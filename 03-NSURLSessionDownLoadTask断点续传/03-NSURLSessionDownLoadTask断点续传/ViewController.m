//
//  ViewController.m
//  03-NSURLSessionDownLoadTask断点续传
//
//  Created by qingyun on 16/4/29.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#define KURLStr @"http://dlsw.baidu.com/sw-search-sp/soft/b8/25870/Wireshark1.10.6Intel64.1396001840.dmg"


@interface ViewController ()<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *ProgressView;
@property (strong,nonatomic)NSURLSessionDownloadTask *task;
//保存当前下载数据
@property (strong,nonatomic)NSData *resumeData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)TouchRequest:(UIButton *)sender {

    //判断当前是否正在下载
    if(_task){
      //暂停当前下载任务，保存当前已经下载的数据，方便下次重新下载时，按当前进度的继续下载，从而实现断点续传
      [_task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
          _resumeData=resumeData;
      }];
        _task=nil;
       [sender setTitle:@"开始" forState:UIControlStateNormal];
    }else{
    //1.创建会话对象
      NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    //2.创建Task
       //判断是否是首次创建任务
        if (!_resumeData) {
          _task=[session downloadTaskWithURL:[NSURL URLWithString:KURLStr]];
        }else{
          _task=[session downloadTaskWithResumeData:_resumeData];
        }
        //3.启动Task
        [_task resume];
        //4.标题改变
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }
    
}

#pragma mark NSURLSessionDownloadDelegate
//重复调用
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
   //计算进度条
    float value=(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
    
    __weak UIProgressView *tempView=_ProgressView;
    //刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        tempView.progress=value;
    });
}
//下载完成后调用
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
   //下载完成后调用
    NSHTTPURLResponse *response=(NSHTTPURLResponse *)downloadTask.response;
    NSURL *desURL=[NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/qingyun/Desktop/%@",response.suggestedFilename]];
    
    if ([[NSFileManager defaultManager]copyItemAtURL:location toURL:desURL error:nil]) {
        NSLog(@"======ok");
    } ;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
