//
//  ViewController.m
//  LFLiveKitDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import <LFLiveKit/LFLiveKit.h>
#import "StreamView.h"


inline static NSString *formatedSpeed(float bytes, float elapsed_milli)
{
	if (elapsed_milli <= 0) {
		return @"N/A";
	}

	if (bytes <= 0) {
		return @"0 KB/s";
	}

	float bytes_per_sec = ((float)bytes) * 1000.f /  elapsed_milli;
	if (bytes_per_sec >= 1000 * 1000) {
		return [NSString stringWithFormat:@"%.2f MB/s", ((float)bytes_per_sec) / 1000 / 1000];
	} else if (bytes_per_sec >= 1000) {
		return [NSString stringWithFormat:@"%.1f KB/s", ((float)bytes_per_sec) / 1000];
	} else {
		return [NSString stringWithFormat:@"%ld B/s", (long)bytes_per_sec];
	}
}


@interface ViewController () <LFLiveSessionDelegate>

@property (nonatomic) StreamView *previewView;
@property (nonatomic, strong) LFLiveSession *session;

@end


@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self requestAccessForVideo];
	[self requestAccessForAudio];

	(void)self.session;
}

- (void)requestAccessForVideo
{
	__weak typeof(self) _self = self;
	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	switch (status) {
		case AVAuthorizationStatusNotDetermined: {
			// 许可对话没有出现，发起授权许可
			[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
				if (granted) {
					dispatch_async(dispatch_get_main_queue(), ^{
						[_self.session setRunning:YES];
					});
				}
			}];
			break;
		}
		case AVAuthorizationStatusAuthorized: {
			// 已经开启授权，可继续
			dispatch_async(dispatch_get_main_queue(), ^{
				[_self.session setRunning:YES];
			});
			break;
		}
		case AVAuthorizationStatusDenied:
		case AVAuthorizationStatusRestricted:
			// 用户明确地拒绝授权，或者相机设备无法访问

			break;
		default:
			break;
	}
}

- (void)requestAccessForAudio
{
	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
	switch (status) {
		case AVAuthorizationStatusNotDetermined: {
			[AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
			}];
			break;
		}
		case AVAuthorizationStatusAuthorized: {
			break;
		}
		case AVAuthorizationStatusDenied:
		case AVAuthorizationStatusRestricted:
			break;
		default:
			break;
	}
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskLandscape;
}

- (LFLiveSession *)session
{
	if (_session) return _session;

	/*
	 LFAudioConfiguration *audioConfig = [LFAudioConfiguration defaultConfiguration];

	 LFVideoConfiguration *videoConfig = [LFVideoConfiguration new];
	 videoConfig.videoSize = CGSizeMake(640, 360);
	 videoConfig.videoBitrate    =  800 * 1024;
	 videoConfig.videoMaxBitrate = 1000 * 1024;
	 videoConfig.videoMinBitrate =  500 * 1024;
	 videoConfig.videoFrameRate = 24;
	 videoConfig.videoMaxKeyframeInterval = 48;
	 videoConfig.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
	 videoConfig.autorotate = NO;
	 videoConfig.sessionPreset = LFCaptureSessionPreset720x1280;
	 */

	LFAudioConfiguration *audioConfig = [LFAudioConfiguration new];
	audioConfig.numberOfChannels = 2;
	audioConfig.audioBitrate = LFAudioBitrate96Kbps;
	audioConfig.audioSampleRate = LFAudioSampleRate44100Hz;

	LFVideoConfiguration *videoConfig = [LFVideoConfiguration new];
	videoConfig.sessionPreset = LFCaptureSessionPreset720x1280;
	videoConfig.videoFrameRate = 25;
	videoConfig.videoMaxKeyframeInterval = videoConfig.videoFrameRate * 2;
	videoConfig.videoBitrate    = 1000 * 1024;
	videoConfig.videoMinBitrate =  500 * 1024;
	videoConfig.videoMaxBitrate = 3000 * 1024;
	videoConfig.videoSize = CGSizeMake(1280, 720);
	videoConfig.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
	videoConfig.autorotate = NO;

	_session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfig
											  videoConfiguration:videoConfig
													 captureType:LFCaptureMaskDefault];

	/**    自己定制单声道  */
	/*
	 LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
	 audioConfiguration.numberOfChannels = 1;
	 audioConfiguration.audioBitrate = LFLiveAudioBitRate_64Kbps;
	 audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
	 _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
	 */

	/**    自己定制高质量音频96K */
	/*
	 LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
	 audioConfiguration.numberOfChannels = 2;
	 audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
	 audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
	 _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
	 */

	/**    自己定制高质量音频96K 分辨率设置为540*960 方向竖屏 */

	/*
	 LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
	 audioConfiguration.numberOfChannels = 2;
	 audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
	 audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;

	 LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
	 videoConfiguration.videoSize = CGSizeMake(540, 960);
	 videoConfiguration.videoBitRate = 800*1024;
	 videoConfiguration.videoMaxBitRate = 1000*1024;
	 videoConfiguration.videoMinBitRate = 500*1024;
	 videoConfiguration.videoFrameRate = 24;
	 videoConfiguration.videoMaxKeyframeInterval = 48;
	 videoConfiguration.orientation = UIInterfaceOrientationPortrait;
	 videoConfiguration.sessionPreset = LFCaptureSessionPreset540x960;

	 _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
	 */


	/**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */

	/*
	 LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
	 audioConfiguration.numberOfChannels = 2;
	 audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
	 audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;

	 LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
	 videoConfiguration.videoSize = CGSizeMake(720, 1280);
	 videoConfiguration.videoBitRate = 800*1024;
	 videoConfiguration.videoMaxBitRate = 1000*1024;
	 videoConfiguration.videoMinBitRate = 500*1024;
	 videoConfiguration.videoFrameRate = 15;
	 videoConfiguration.videoMaxKeyframeInterval = 30;
	 videoConfiguration.landscape = NO;
	 videoConfiguration.sessionPreset = LFCaptureSessionPreset360x640;

	 _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
	 */


	/**    自己定制高质量音频128K 分辨率设置为720*1280 方向横屏  */

	/*
	 LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
	 audioConfiguration.numberOfChannels = 2;
	 audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
	 audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;

	 LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
	 videoConfiguration.videoSize = CGSizeMake(1280, 720);
	 videoConfiguration.videoBitRate = 800*1024;
	 videoConfiguration.videoMaxBitRate = 1000*1024;
	 videoConfiguration.videoMinBitRate = 500*1024;
	 videoConfiguration.videoFrameRate = 15;
	 videoConfiguration.videoMaxKeyframeInterval = 30;
	 videoConfiguration.landscape = YES;
	 videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;

	 _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
	 */

	_session.adaptiveBitrate = YES;
	_session.delegate = self;
	_session.showDebugInfo = YES;
	self.previewView = [[StreamView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.previewView];
	self.previewView.session = _session;
	_session.previewView = self.previewView;

	/*本地存储*/
	//        _session.saveLocalVideo = YES;
	//        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
	//        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
	//        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
	//        _session.saveLocalVideoPath = movieURL;


	return _session;
}

#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state
{
	NSLog(@"liveStateDidChange: %ld", state);
	switch (state) {
		case LFLiveStateReady:
			self.previewView.state = @"ready";
			break;
		case LFLiveStatePending:
			self.previewView.state = @"pending";
			break;
		case LFLiveStateStart:
			self.previewView.state = @"start";
			break;
		case LFLiveStateError:
			self.previewView.state = @"error";
			break;
		case LFLiveStateStop:
			self.previewView.state = @"stop";
			break;
		default:
			break;
	}
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo
{
	NSLog(@"debugInfo uploadSpeed: %@", formatedSpeed(debugInfo.currentBandwidth, debugInfo.elapsedMilli));
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session socketError:(LFLiveSocketError)socketError
{
	NSLog(@"socketError: %ld", socketError);
}

@end
