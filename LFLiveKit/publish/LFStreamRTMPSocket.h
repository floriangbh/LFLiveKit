//
//  LFStreamRTMPSocket.h
//  LaiFeng
//
//  Created by LaiFeng on 16/5/20.
//  Copyright © 2016年 LaiFeng All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LFStreamInfo.h"
#import "LFBuffer.h"
#import "LFLiveDebug.h"


@class LFStreamRTMPSocket;

@protocol LFStreamRTMPSocketDelegate <NSObject>

/** callback buffer current status (回调当前缓冲区情况，可实现相关切换帧率 码率等策略)*/
- (void)socketBufferStatus:(nullable LFStreamRTMPSocket *)socket status:(LFBufferState)status;
/** callback socket current status (回调当前网络情况) */
- (void)socketStatus:(nullable LFStreamRTMPSocket *)socket status:(LFLiveState)status;
/** callback socket error */
- (void)socketDidError:(nullable LFStreamRTMPSocket *)socket error:(LFLiveSocketError)error;
@optional
/** callback debugInfo */
- (void)socketDebug:(nullable LFStreamRTMPSocket *)socket debugInfo:(nullable LFLiveDebug *)debugInfo;
@end


@interface LFStreamRTMPSocket : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithStream:(nullable LFStreamInfo *)stream;
- (nullable instancetype)initWithStream:(nullable LFStreamInfo *)stream
					  reconnectInterval:(NSInteger)reconnectInterval
						 reconnectCount:(NSInteger)reconnectCount;

- (void)setDelegate:(nullable id<LFStreamRTMPSocketDelegate>)delegate;
- (void)start;
- (void)stop;
- (void)sendFrame:(nullable LFFrame *)frame;
- (void)sendSubtitle:(NSString *)text;

@end
