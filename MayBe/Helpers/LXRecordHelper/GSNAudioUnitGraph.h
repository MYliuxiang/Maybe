//
//  GSNAudioUnitGraph.h
//  RecordDemo
//
//  Created by 杨浩 on 2019/8/27.
//  Copyright © 2019 杨浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSNAudioUnitGraph : NSObject

@property (nonatomic, copy)void (^callback)(NSData *data);
@property (nonatomic, copy)void (^cancleback)(void);


- (void)startRecored;
- (void)stopRecored;
- (void)cancleRecored;

@end


NS_ASSUME_NONNULL_END
