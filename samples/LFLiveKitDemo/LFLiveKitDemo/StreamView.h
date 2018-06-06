//
//  StreamView.h
//  LFLiveKitDemo
//
//  Created by Pavlos Vinieratos on 06/06/2018.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LFLiveKit/LFLiveKit.h>


@interface StreamView : UIView

@property (nonatomic, weak) LFLiveSession *session;
@property (nonatomic) NSString *state;

@end
