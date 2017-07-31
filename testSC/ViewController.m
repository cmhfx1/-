//
//  ViewController.m
//  testSC
//
//  Created by fx on 2017/7/19.
//  Copyright © 2017年 fx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak)UIScrollView *sc;

/** sc 子视图 */
@property (nonatomic,weak)UIButton *leftBtn;
@property (nonatomic,weak)UIButton *middleBtn;
@property (nonatomic,weak)UIButton *rightBtn;

@property (nonatomic,strong)NSArray *source;

/** */
@property (nonatomic,assign)NSInteger feeling;


@property (nonatomic,strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //1 配置 scrollview
    [self createScrollView];
    
    
    //2 添加 子视图，由于没有合适的图片 UIButton 代理 UIImageView
    //3 设置 数据源 ，同样  由于 没有 图片 用字符串 代替
    [self setupScrollview];
    
    

    
    // 4 初始化设置
    [self initSetting];
    
    // 5 定时器
    [self setupTimer];
    
    
    
    //6 kvo
    [self addObserver: self forKeyPath: @"feeling" options: NSKeyValueObservingOptionNew context: nil];

    
}


- (void)createScrollView
{
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    sc.pagingEnabled = YES;
    sc.delegate = self;
    sc.contentSize  =  CGSizeMake(375*3, 0);
    [self.view addSubview:sc];
    self.sc = sc;
    sc.backgroundColor = [UIColor yellowColor];
}


- (void)setupScrollview
{
    // 三个子视图
    for (int i = 0; i < 6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor blackColor];
        btn.frame = CGRectMake(i*375, 0, 375, 667);
        [self.sc addSubview:btn];
        [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                self.leftBtn = btn;
                break;
                
            case 1:
                self.middleBtn = btn;
                break;
                
            case 2:
                self.rightBtn = btn;
                break;
        }
    }
    
    // 数据源
    NSArray *source = @[@"0",@"1",@"2",@"3",@"4"];
    self.source = source;
}


- (void)initSetting
{
    
    NSInteger count = self.source.count;
    
    // 初始化 contentOffset
    _sc.contentOffset = CGPointMake(375, 0);
    self.feeling = 0;
    
    [self.leftBtn setTitle:_source[self.feeling-1 < 0 ? count-1 :self.feeling-1] forState:UIControlStateNormal];
    [self.middleBtn setTitle:_source[self.feeling < 0 ? count-1 :(self.feeling == count ? 0:self.feeling)] forState:UIControlStateNormal];
    [self.rightBtn setTitle:_source[self.feeling+1 >= count ? 0 :self.feeling+1] forState:UIControlStateNormal];
}


- (void)setupTimer
{
    __weak typeof(self)weakself = self;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        weakself.feeling+=1;
        
    }];
    self.timer = timer;
}


#pragma mrak -- kvo ----

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
     NSInteger count = _source.count;
    _feeling = self.feeling < 0 ? count-1 :(self.feeling == count ? 0:self.feeling);//self.feeling 死循环
    
    NSLog(@"%ld",self.feeling);
    [self.leftBtn setTitle:_source[self.feeling-1 < 0 ? count-1 :self.feeling-1] forState:UIControlStateNormal];
    
    [self.middleBtn setTitle:_source[self.feeling] forState:UIControlStateNormal];
    [self.rightBtn setTitle:_source[self.feeling+1 >= count ? 0 :self.feeling+1] forState:UIControlStateNormal];
    
    
    _sc.contentOffset = CGPointMake(375, 0);
}


#pragma mrak -- scrollviewDelegate ----


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    if (x == 1*375) return;
    
    if (x == 2*375) {
        self.feeling+=1;
    }else if(x == 0){
        self.feeling-=1;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    __weak typeof(self)weakself = self;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        weakself.feeling+=1;
        
    }];
    self.timer = timer;
}


//  用户看到的只有中间视图，所以为了简单起见，只需要添加中间视图的点击响应

- (void)tap:(UIButton *)btn
{
    if (btn == self.middleBtn) {
        NSLog(@"middle");
    }
    
    // 但处理的逻辑 依据 feeling
}



@end
