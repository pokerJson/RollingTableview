//
//  ViewController.m
//  RollingTbleview
//
//  Created by CYAX_BOY on 17/3/18.
//  Copyright © 2017年 CYAX_BOY. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "BezierPathView.h"
#import "Masonry.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define ImageHight 181.0f*([UIScreen mainScreen].bounds.size.width)/375

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BezierPathView *beizierView;
    
    CALayer      *_contentLayer2;
    CAShapeLayer *_maskLayer2;

}


@property (nonatomic,strong)UITableView *tableview;
//tableview上的头视图
@property (nonatomic,strong)UIImageView *zoomImageView;
@property (nonatomic,strong)UIImageView *headimageview;//头像



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableview];
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.tableview addSubview:self.zoomImageView];
    NSString *imgstr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489836287183&di=3b228d805fb467371283d0506dfb7259&imgtype=0&src=http%3A%2F%2Ftx.haiqq.com%2Fuploads%2Fallimg%2F150325%2F122259EJ-13.jpg";
    [self.zoomImageView sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:nil];

    //贝塞尔曲线
    beizierView =[[BezierPathView alloc]initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, 40)];
    
    [self.tableview addSubview:beizierView];
    
    /*
        头像这里放在tablevie上 因为zoomImageView有剪裁 突出部分会被剪切
     */
    [self.tableview addSubview:self.headimageview];

    __block NSData *headImageData;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        headImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgstr]];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            UIImage *img = [UIImage imageWithData:headImageData];
            _contentLayer2.contents = (id)img.CGImage;//头像
        });
    });

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float y = scrollView.contentOffset.y;
    NSLog(@"mybikeviewcontroller.yyyyyyyy==%f",y);
    if (y < -ImageHight) {
        _tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        CGRect frame = _zoomImageView.frame;
        frame.origin.y = y;
        frame.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        _zoomImageView.frame = frame;
        
        //改变zezierview的frame
        CGFloat offsetY = scrollView.contentOffset.y;
        float yyy = -offsetY-ImageHight;
        beizierView.frame = CGRectMake(0, -yyy*0.6-40, SCREEN_WIDTH, (yyy*0.6+40));
        beizierView.up = NO;
        //异步执行，setNeedsDisplay会调用自动调用drawRect方法
        [beizierView setNeedsDisplay];
        
//        //重新设置下  手势滑动猛地的话会缩小 ---=-==-==-=-==+++++++++=
        self.headimageview.transform = CGAffineTransformMakeScale(1, 1);//scale最下面的那一个
        self.headimageview.center = CGPointMake((39+82/2), -28);
    }else if(y>=-ImageHight && y <= -64){
        
        _tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //>-ImageHight
        CGRect frame = _zoomImageView.frame;
        frame.origin.y = y;
        frame.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        _zoomImageView.frame = frame;
        
        //改变zezierview的frame
        CGFloat offsetY = scrollView.contentOffset.y;
        float yyy = -offsetY-ImageHight;//181
        beizierView.frame = CGRectMake(0, -yyy*0.4-40, SCREEN_WIDTH, (yyy*0.4+40));
        beizierView.up = YES;
        
        NSLog(@"64-ImageHight+offsetY===%f",64-(ImageHight+offsetY));
        //异步执行，setNeedsDisplay会调用自动调用drawRect方法
        [beizierView setNeedsDisplay];
        
        ///xxxxxxxxxxxxxxxxxxxx 头像缩放
        //向上偏移量计算
        float rar = (-offsetY-64);
        float raduis = rar/(ImageHight-64);
        self.headimageview.transform = CGAffineTransformMakeScale(raduis, raduis);//scale最下面的那一个
        CGFloat yyyyyyy = -28*raduis;//28高度是6上面基本的中心位置
        self.headimageview.center = CGPointMake((39+82/2), yyyyyyy);
        
    }else if(y > -64){
//        _topviewrr.hidden = NO;
//        self.nameLabel.hidden = YES;
    }else{
    }
}


//代理xxxx
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"test%ld",(long)indexPath.row];
    return cell;

}

- (UIImageView *)headimageview
{
    if (!_headimageview) {
        _headimageview = [[UIImageView alloc]initWithFrame:CGRectMake(39, -70, 76, 78)];
        _headimageview.contentMode = UIViewContentModeScaleAspectFill;//重点（不设置那将只会被纵向拉伸）
        _headimageview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _headimageview.userInteractionEnabled = YES;
        CGMutablePathRef bubblePath1 = CGPathCreateMutable();
        CGPoint origin1 = _headimageview.bounds.origin;
        CGFloat radius1 = CGRectGetWidth(_headimageview.bounds) *0.45;
        CGFloat wi1 = CGRectGetWidth(_headimageview.bounds);
        CGPathMoveToPoint(bubblePath1, NULL, origin1.x+0.5*wi1, origin1.y + wi1);
        CGPathAddQuadCurveToPoint(bubblePath1, NULL, origin1.x+0.05*wi1, origin1.y + 1.5 *radius1, origin1.x+0.05*wi1, origin1.y + radius1);
        CGPathAddArcToPoint(bubblePath1, NULL, origin1.x+0.05*wi1, origin1.y, origin1.x + 0.5*wi1, origin1.y, radius1);
        CGPathAddArcToPoint(bubblePath1, NULL, origin1.x + 0.95*wi1 , origin1.y, origin1.x + 0.95*wi1, origin1.y + radius1, radius1);
        CGPathAddQuadCurveToPoint(bubblePath1, NULL, origin1.x+0.95*wi1, origin1.y + 1.5 *radius1, origin1.x+0.5*wi1, origin1.y + wi1);
        
        _maskLayer2 = [CAShapeLayer layer];
        _maskLayer2.fillColor = [UIColor redColor].CGColor;
        _maskLayer2.strokeColor = [UIColor orangeColor].CGColor;
        _maskLayer2.frame = _headimageview.bounds;
        _maskLayer2.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
        
        /*!
         * 非常关键设置自动拉伸的效果且不变形
         */
        _maskLayer2.contentsScale = [UIScreen mainScreen].scale;
        /*!
         * 可以通过conents或path来设置mask，效果不一样
         */
        
        _maskLayer2.path = bubblePath1;
        CGPathRelease(bubblePath1);
        
        _contentLayer2 = [CALayer layer];
        _contentLayer2.mask = _maskLayer2;
        _contentLayer2.frame = _headimageview.bounds;
        
        [_headimageview.layer addSublayer:_contentLayer2];
        
        
    }
    return _headimageview;
}

- (UIImageView *)zoomImageView
{
    if (!_zoomImageView) {
        _zoomImageView = [[UIImageView alloc]init];
        _zoomImageView.frame = CGRectMake(0, -ImageHight, SCREEN_WIDTH, ImageHight);
        _zoomImageView.userInteractionEnabled = YES;
        _zoomImageView.autoresizesSubviews = YES;
        _zoomImageView.contentMode = UIViewContentModeScaleAspectFill;//重点（不设置那将只会被纵向拉伸）
        _zoomImageView.clipsToBounds = YES;
        
        //毛玻璃 ios8自带的
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        //  毛玻璃视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        [_zoomImageView addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_zoomImageView).with.insets(UIEdgeInsetsMake(0,0,0,0));
        }];
        //设置模糊透明度
        effectView.alpha = 1.0f;
        
        
    }
    return _zoomImageView;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.contentInset = UIEdgeInsetsMake(ImageHight, 0, 0, 0);
    }
    return _tableview;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
