//
//  BackgroundAudio.h
//  browser
//
//  Created by 王 毅 on 13-8-21.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioSession.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>
@interface BackgroundAudio : NSObject{
    AVAudioPlayer *_player;
    AVAudioSession *session;
}

@property (nonatomic , retain)AVAudioPlayer *_player;
@property (nonatomic , retain)AVAudioSession *session;
+ (BackgroundAudio *)getObject;

//首次启动时调用的判断本地选项做出相应处理
- (void)firstEnableMainAudioStrength:(int)index;

- (void)setSessionActive:(BOOL)isActive;

- (void)playMainAudio;

- (void)stopMainAudio;

- (BOOL)audioIsBusy;

- (BOOL)isPlaying;
@end
