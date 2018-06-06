//
//  StreamView.m
//  LFLiveKitDemo
//
//  Created by Pavlos Vinieratos on 06/06/2018.
//  Copyright © 2018 admin. All rights reserved.
//

#import "StreamView.h"
#import "UIControl+YYAdd.h"
#import "UIView+YYAdd.h"


@interface StreamView ()

@property (nonatomic, strong) UIButton *subtitleButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *startLiveButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) LFLiveDebug *debugInfo;
@property (nonatomic, strong) UILabel *stateLabel;

@end


@implementation StreamView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (!(self = [super initWithFrame:frame])) return self;

	self.backgroundColor = UIColor.blueColor;
	[self addSubview:self.containerView];
	[self.containerView addSubview:self.stateLabel];
	[self.containerView addSubview:self.closeButton];
	[self.containerView addSubview:self.cameraButton];
	[self.containerView addSubview:self.subtitleButton];
	[self.containerView addSubview:self.startLiveButton];

	return self;
}

- (UIView *)containerView
{
	if (!_containerView) {
		_containerView = [UIView new];
		_containerView.frame = self.bounds;
		_containerView.backgroundColor = [UIColor clearColor];
		_containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	return _containerView;
}

- (UILabel *)stateLabel
{
	if (!_stateLabel) {
		_stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 40)];
		_stateLabel.text = @"state";
		_stateLabel.textColor = [UIColor whiteColor];
		_stateLabel.font = [UIFont boldSystemFontOfSize:14.f];
	}
	return _stateLabel;
}

- (UIButton *)closeButton
{
	if (!_closeButton) {
		_closeButton = [UIButton new];
		_closeButton.size = CGSizeMake(44, 44);
		_closeButton.left = self.width - 10 - _closeButton.width;
		_closeButton.top = 20;
		[_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
		_closeButton.exclusiveTouch = YES;
		[_closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {

		}];
	}
	return _closeButton;
}

- (UIButton *)cameraButton
{
	if (!_cameraButton) {
		_cameraButton = [UIButton new];
		_cameraButton.size = CGSizeMake(44, 44);
		_cameraButton.origin = CGPointMake(_closeButton.left - 10 - _cameraButton.width, 20);
		[_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
		_cameraButton.exclusiveTouch = YES;
		__weak typeof(self) _self = self;
		[_cameraButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
			AVCaptureDevicePosition devicePositon = _self.session.captureDevicePosition;
			_self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
		}];
	}
	return _cameraButton;
}

- (UIButton *)subtitleButton
{
	if (!_subtitleButton) {
		_subtitleButton = [UIButton new];
		_subtitleButton.size = CGSizeMake(44, 44);
		_subtitleButton.origin = CGPointMake(_cameraButton.left - 10 - _subtitleButton.width, 20);
		[_subtitleButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateNormal];
		_subtitleButton.exclusiveTouch = YES;
		__weak typeof(self) _self = self;
		[_subtitleButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
			[_self.session sendSubtitle:@"bla"];
		}];
	}
	return _subtitleButton;
}

- (UIButton *)startLiveButton
{
	if (!_startLiveButton) {
		_startLiveButton = [UIButton new];
		_startLiveButton.size = CGSizeMake(self.width - 60, 44);
		_startLiveButton.left = 30;
		_startLiveButton.bottom = self.height - 50;
		_startLiveButton.layer.cornerRadius = _startLiveButton.height/2;
		[_startLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[_startLiveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
		[_startLiveButton setTitle:@"start" forState:UIControlStateNormal];
		[_startLiveButton setBackgroundColor:[UIColor colorWithRed:50 green:32 blue:245 alpha:1]];
		_startLiveButton.exclusiveTouch = YES;
		__weak typeof(self) _self = self;
		[_startLiveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
			_self.startLiveButton.selected = !_self.startLiveButton.selected;
			if (_self.startLiveButton.selected) {
				[_self.startLiveButton setTitle:@"stop" forState:UIControlStateNormal];
				LFStreamInfo *stream = [LFStreamInfo new];
				//				stream.url = @"rtmp://192.168.4.26:1935/live/te";
				//				stream.url = @"rtmp://stream-staging-eu.mycujoo.tv/live/18b98ecedc10411a8fe392629949aaed";
				stream.url = @"rtmp://stream.mycujoo.tv/live/6e672ca99aa84c009d8031e94d7867f6";
				[_self.session startLive:stream];
				_self.session.saveLocalVideo = YES;
				NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
				[NSFileManager.defaultManager removeItemAtPath:[path stringByAppendingString:@"/bla.mp4"] error:NULL];
				_self.session.saveLocalVideoUrl = [NSURL fileURLWithPath:[path stringByAppendingString:@"/bla.mp4"]];
				_self.session.recording = YES;
			} else {
				NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
				[_self.startLiveButton setTitle:@"start" forState:UIControlStateNormal];
				[_self.session stopLive];
				[[NSFileManager.defaultManager contentsOfDirectoryAtPath:path
																   error:NULL] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					NSLog(@"blabla %@", obj);
				}];
			}
		}];
	}
	return _startLiveButton;
}

- (NSString *)state
{
	return self.stateLabel.text;
}

- (void)setState:(NSString *)state
{
	self.stateLabel.text = state;
}

@end
