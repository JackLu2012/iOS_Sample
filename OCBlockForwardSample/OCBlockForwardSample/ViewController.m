//
//  ViewController.m
//  OCBlockForwardSample
//
//  Created by Jack on 8/15/25.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) int(^blk)(int) ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    __block int mul = 10;  // result is 24
//    static int mul = 10; // result is 24
    // int mul = 10;  // result is 40
    
    _blk = ^int(int num) {
        return mul * num;
    };
    mul = 6;
    [self excuteBlock];
}

- (void)excuteBlock {
    int result = _blk(4);
    NSLog(@"result is %d", result);
}


@end
