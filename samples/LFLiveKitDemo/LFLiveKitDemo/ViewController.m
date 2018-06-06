//
//  ViewController.m
//  LFLiveKitDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import "LFLivePreview.h"


@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.view addSubview:[[LFLivePreview alloc] initWithFrame:self.view.bounds]];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskLandscape;
}

@end
