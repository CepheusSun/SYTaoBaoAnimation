//
//  ViewController.m
//  TaoBaoAnimation
//
//  Created by 孙扬 on 16/6/23.
//  Copyright © 2016年 MichealSun. All rights reserved.
//

#import "ViewController.h"
#import "ToViewController.h"


@interface ViewController ()
@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zoro.jpg"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
    _imageView = imageView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ToViewController *toVC = [ToViewController new];
    toVC.Ps_backgroundImage = convertViewToImage(self.navigationController.view);
    [self presentViewController:toVC animated:NO completion:nil];
}


@end
