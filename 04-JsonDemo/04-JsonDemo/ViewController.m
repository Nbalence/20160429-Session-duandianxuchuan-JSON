//
//  ViewController.m
//  04-JsonDemo
//
//  Created by qingyun on 16/4/29.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     NSString *str=[NSString stringWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Address" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"========%@",str);
    NSData *jsonData=[NSData dataWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Address" withExtension:@"json"]];
    //解析json数据
    id objc=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
   
    
    if ([objc isKindOfClass:[NSArray class]]) {
        NSLog(@"数组======%@",objc);
    }
    if ([objc isKindOfClass:[NSDictionary class]]) {
        NSLog(@"==字典====%@",objc);
    }
    
    //封装json数据
    NSDictionary *dic=@{@"username":@"zhangsan",@"pwd":@"123",@"phone":@[@"12345678",@"987654567890"]};
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"=====%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
