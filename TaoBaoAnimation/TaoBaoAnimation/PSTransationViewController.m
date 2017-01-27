//
//  PSTransationViewController.m
//  TaoBaoAnimation
//
//  Created by 孙扬 on 16/6/23.
//  Copyright © 2016年 MichealSun. All rights reserved.
//

#import "PSTransationViewController.h"


#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif

#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

@interface PSTransationViewController ()

@property (nonatomic ,strong) UIImageView *Ps_backgroundImageView;
@end

@implementation PSTransationViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _Ps_backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _Ps_backgroundImageView.image = self.Ps_backgroundImage;
    [self.view addSubview:_Ps_backgroundImageView];
    [_Ps_backgroundImageView addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(ps_close)]];
    //rootVC上的maskView
    _Ps_maskView = ({
        UIView * maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        maskView.alpha = 0;
        maskView;
    });
    self.view.userInteractionEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ps_show];
}

#pragma mark - public 
- (void)ps_dismiss {
    [self ps_close];
}

UIImage* convertViewToImage(UIView* v){
    
    UIGraphicsBeginImageContext(v.bounds.size);
    
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - private
- (void)ps_close
{
    CGRect frame = _Ps_ContentView.frame;
    frame.origin.y += _Ps_ContentView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[self ps_enumSubViews] enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * stop) {
            obj.alpha = 0;
        }];
        //maskView隐藏
        [_Ps_maskView setAlpha:0.f];
        //popView下降
        _Ps_ContentView.frame = frame;
        
        //同时进行 感觉更丝滑
        [_Ps_backgroundImageView.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [_Ps_backgroundImageView.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            //移除
            [_Ps_ContentView removeFromSuperview];
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }];
}

- (void)ps_show
{
    [[UIApplication sharedApplication].windows[0] addSubview:_Ps_ContentView];
    [_Ps_ContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 0;
    }];
    CGRect frame = _Ps_ContentView.frame;
    frame.origin.y = self.view.bounds.size.height - _Ps_ContentView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        [_Ps_backgroundImageView.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_Ps_ContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 1;
            }];
            [_Ps_backgroundImageView.layer setTransform:[self secondTransform]];
            //显示maskView
            [_Ps_maskView setAlpha:0.5f];
            //popView上升
            _Ps_ContentView.frame = CGRectMake(0, (1 - _Ps_scaleOfHeight) * SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * _Ps_scaleOfHeight);
            
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
        }];
        
    }];
    
}

- (NSMutableArray *)ps_enumSubViews {
    NSMutableArray *array = [NSMutableArray array];
    [_Ps_ContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.origin.y < 0) {
            [array addObject:obj];
        }
    }];
    return array;
}
#pragma mark - transform
- (CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self ps_close];
}

#pragma mark - lazyLoad 
- (UIView *)Ps_ContentView {
    if (!_Ps_ContentView) {
            NSAssert(_Ps_scaleOfHeight, @"\nlake of property : _Ps_scaleOfHeight");
            NSAssert(_Ps_scaleOfHeight > 0, @"\nproperty _Ps_scaleOfHeight is not in range");
            NSAssert(_Ps_scaleOfHeight < 1, @"\nproperty _Ps_scaleOfHeight is not in range");
        _Ps_ContentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * _Ps_scaleOfHeight)];
        _Ps_ContentView.backgroundColor = [UIColor whiteColor];
    }
    return _Ps_ContentView;
}

@end
