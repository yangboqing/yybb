//
//  BackgroundAudio.m
//  browser
//
//  Created by 王 毅 on 13-8-21.
//
//

#import "BackgroundAudio.h"
#import "SettingPlistConfig.h"



@implementation BackgroundAudio
@synthesize _player;
@synthesize session;
+ (BackgroundAudio *)getObject{
    @synchronized(@"BackgroundAudio") {
        static BackgroundAudio *getObject = nil;
        if (getObject == nil){
            getObject = [[BackgroundAudio alloc] init];
        }
        return getObject;
    }
}

- (id)init{
    if ( self=[super init] ) {
        
        NSError *error;
        session = [AVAudioSession sharedInstance];
        
        [session setActive:![self audioIsBusy] withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        //后台播放
        [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
        //        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        //设置代理 可以处理电话打进时中断音乐播放
        //        [[AVAudioSession sharedInstance] setDelegate:self];
        
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emptyAudio" ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
        
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil ];
        [_player setVolume:0.0];
        _player.numberOfLoops = -1;
        
    }
    
    return  self;
    
}

- (void)setSessionActive:(BOOL)isActive{
    NSError *error;
    //静音状态下播放，当前是否为激活状态
    [session setActive:isActive withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
}

- (void)playMainAudio{
    //    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [_player prepareToPlay];
    [_player play];
    
}

- (void)stopMainAudio{
    //    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    
    [_player stop];
    
}


- (BOOL)isPlaying{
    return [_player isPlaying];
}

//- (BOOL)isplayothermusic{
//    AudioSessionInitialize (NULL, NULL, NULL, NULL);
//    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
//    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);
//    AudioSessionSetActive (true);
//
//    UInt32 audioIsPlaying;
//    UInt32 size = sizeof(audioIsPlaying);
//    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &size, &audioIsPlaying);
//
//
//
//
//
//    if (!audioIsPlaying){
//        NSLog(@"没有其他音乐播放");
//        return NO;
//    }else{
//        NSLog(@"有其他音乐播放");
//        return YES;
//    }
//}


- (BOOL)audioIsBusy{
    UInt32 otherAudioIsPlaying;                                   // 1
    
    UInt32 propertySize = sizeof (otherAudioIsPlaying);
    
    
    
    AudioSessionGetProperty (                                     // 2
                             
                             kAudioSessionProperty_OtherAudioIsPlaying,
                             
                             &propertySize,
                             
                             &otherAudioIsPlaying
                             
                             );
    
    
    
    if (otherAudioIsPlaying) {                                    // 3
        
        //        NSLog(@"有其他音乐播放");
        
        return YES;
        
    } else {
        
        //        NSLog(@"没有其他音乐播放");
        
        return NO;
        
    }
}

- (void)firstEnableMainAudioStrength:(int)index{

    switch (index) {
        case 1:
//            [self setSessionActive:YES];
            [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
            [self playMainAudio];
            
            break;
        case 2:
            
            if ([self audioIsBusy] == NO) {
                [self playMainAudio];
            }
            break;
            
        default:
            break;
    }
    
    
    
}


/*
 当有电话打进的时候，这里可以处理将正在播放的音乐停止，然后打完电话后再重新播放
 
 - (void)beginInterruption
 
 {
 
 //停止播放的事件
 
 }
 
 
 - (void)endInterruption
 
 {
 
 //继续播放的事件
 
 }
 
 */

- (void)dealloc{
    
}


@end
