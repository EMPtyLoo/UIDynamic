//
//  ViewController.m
//  UIDynamic
//
//  Created by EMPty on 4/8/16.
//  Copyright (c) 2016 EMPty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *red;
@property (nonatomic,strong) UIDynamicAnimator* anim;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//懒加载
- (UIDynamicAnimator*) anim
{
    if (!_anim) {
        _anim = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _anim;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取当前触摸的手指
    UITouch* touch = [touches anyObject];
    //根据手指取出位置
    CGPoint point = [touch locationInView:touch.view];
    
    
   //吸附
    UISnapBehavior* snap = [[UISnapBehavior alloc]initWithItem:self.red snapToPoint:point];
    //注意:吸附行为默认只能吸附一次 如果想多次吸附,必须从仿真器中移除,重新添加
    //设置吸附行为的减震 越小越明显
    snap.damping = 1;
    
    [self.anim removeAllBehaviors];
    //将物理仿真行为添加到物理仿真器中
    [self.anim addBehavior:snap];
    
    
}

- (void)collision
{
    //碰撞
    //1.创建物理仿真器
    //2.创建物理仿真行为
    UIGravityBehavior* gravity = [[UIGravityBehavior alloc]initWithItems:@[self.red]];
    
    //碰撞仿真行为
    UICollisionBehavior* collision = [[UICollisionBehavior alloc]initWithItems:@[self.red]
                                      ];
    //设置碰撞边界
    //    collision.translatesReferenceBoundsIntoBoundary = YES;
    //添加直线边界  identifier是用来标记  方便删除的
    //    [collision addBoundaryWithIdentifier:@"line1" fromPoint:CGPointMake(0, 120) toPoint:CGPointMake(320, 340)];
    
    //添加图形的边界
    //内切椭圆
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 320, 500)];
    
    [collision addBoundaryWithIdentifier:@"b" forPath:path];
    
    //3.将物理仿真行为加入到仿真器中
    [self.anim addBehavior:gravity];
    [self.anim addBehavior:collision];
}

- (void)gravity
{//演示重力行为
    //1.创建物理仿真器
    //并且指定了当前控制器的view作为仿真范围
    //    self.anim.referenceView = self.view;
    
    //2.创建物理仿真行为
    //并且指定红色view作为仿真元素
    
    //重力行为
    UIGravityBehavior* gravity = [[UIGravityBehavior alloc]initWithItems:@[self.red]];
    
    /*
     重力方向
     @property (readwrite, nonatomic) CGVector gravityDirection;
     重力角度  水平向右是0°  顺时针为正
     @property (readwrite, nonatomic) CGFloat angle;
     重力的加速度
     @property (readwrite, nonatomic) CGFloat magnitude;
     
     */
    //    gravity.gravityDirection = CGVectorMake(1, 1);//右下角
    gravity.angle = M_PI_2; //1/2pi
    gravity.magnitude = 1.0;
    
    //3.将物理仿真行为添加到仿真器中
    [self.anim addBehavior:gravity];

    
}

@end
