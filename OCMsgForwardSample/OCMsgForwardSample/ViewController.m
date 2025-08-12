//
//  ViewController.m
//  OCMsgForwardSample
//
//  Created by Jack on 8/12/25.
//

#import "ViewController.h"
#import "MyClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MyClass *obj = [MyClass new];
    
    // 测试动态方法解析
    [obj dynamicMethod];  // 会调用动态添加的IMP
    
    // 测试备用接收者
    [obj performSelector:@selector(anotherMethod)];
    
    // 测试完整转发
    [obj performSelector:@selector(unknownMethod)];
    
    // 测试无法识别的选择器
    [obj performSelector:@selector(nonExistentMethod)];
    
}


@end
