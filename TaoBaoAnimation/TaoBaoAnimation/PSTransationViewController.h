//
//  PSTransationViewController.h
//  TaoBaoAnimation
//
//  Created by 孙扬 on 16/6/23.
//  Copyright © 2016年 MichealSun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PSTransationViewController : UIViewController

/**
 *  背景的View
 */
@property (nonatomic ,strong)UIImage *Ps_backgroundImage;

/**
 *  这个控制器的容器视图，不要用self.view 用self.PS_ContentView
 */
@property (nonatomic ,strong)UIView *Ps_ContentView;

/**
 *  contentView 高度比例
 */
@property (nonatomic ,assign)CGFloat Ps_scaleOfHeight;

/**
 *  maskView
 */
@property(nonatomic,strong) UIView * Ps_maskView;


/**
 *  重写了dismiss方法
 */
- (void)ps_dismiss;

/**
 *  空间转image
 */
UIImage* convertViewToImage(UIView* v);

@end
