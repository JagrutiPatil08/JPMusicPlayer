//
//  ViewController.m
//  JPMusicPlayer
//
//  Created by Kalyani on 04/11/16.
//  Copyright © 2016 Jagruti Patil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isPlaying = false;
    
    self.sliderDuration.userInteractionEnabled = NO;
    
    self.sliderDuration.minimumValue = 0;
    self.sliderDuration.value = 0;
    
    [self.sliderDuration setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startTimer {
//    timer = [NSTimer scheduledTimerWithTimeInterval: target:self selector:@selector(updateDurationSlider) userInfo:nil repeats:YES];
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDurationSlider) userInfo:nil repeats:YES];
    self.sliderDuration.maximumValue=audioPlayer.duration;
}

-(void)updateDurationSlider {
    
    if (self.sliderDuration.value == audioPlayer.duration) {
        timer = nil;
    }
    self.sliderDuration.value = audioPlayer.currentTime;
}


-(BOOL)initializeAudioPlayer{
    BOOL status = false;
    NSURL *musicURL =[[NSBundle mainBundle]URLForResource:@"myMusic" withExtension:@"mp3"];
    if (musicURL !=nil) {
        NSError *error;
        audioPlayer =[[AVAudioPlayer alloc]initWithContentsOfURL:musicURL error:&error];
        if (error !=nil) {
            NSLog(@"%@",error.localizedDescription);
        }
        else{
            [self getArtWorkWithFileURL:musicURL];
            
            self.sliderDuration.maximumValue = audioPlayer.duration;

            status =true;
        }
    }
    return status;
    
}
-(void)getArtWorkWithFileURL:(NSURL *)fileURL {
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                           withKey:AVMetadataCommonKeyArtwork
                                                          keySpace:AVMetadataKeySpaceCommon];
        
        for (AVMetadataItem *item in artworks) {
            if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                
                NSData *data = [item.value copyWithZone:nil];
                
                UIImage *image = [UIImage imageWithData:data];
                
                [self performSelectorOnMainThread:@selector(updateArtWork:) withObject:image waitUntilDone:NO];
                NSLog(@"%@",data);
                
            } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                
                NSData *data = [item.value copyWithZone:nil];
                
                UIImage *image = [UIImage imageWithData:data];
                [self performSelectorOnMainThread:@selector(updateArtWork:) withObject:image waitUntilDone:NO];
            }
        }
    }];
}


-(void)updateArtWork:(UIImage *)image {
    
    self.imageViewArtWork.image  = image;
}




- (IBAction)Play:(id)sender {
    UIButton *button = sender;

    if (button.tag == 101) {
        //start playing and rename button title to pause
        
        if (isPlaying) {
            [audioPlayer play];
            [self startTimer];
        }
        else {
            if ([self initializeAudioPlayer]) {
                [audioPlayer play];
                [self startTimer];
                isPlaying = true;
            }
            else {
                NSLog(@"Something went wrong while initializing audio player.");
            }
        }
        
        [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        button.tag = 102;
    }
    else if (button.tag == 102) {
        //start playing and rename button title to pause
        [audioPlayer pause];
        [timer invalidate];
        button.tag = 101;
        [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    
    
    
}

- (IBAction)Stop:(id)sender {
    
    [audioPlayer stop];
    isPlaying = false;
    self.sliderDuration.value = 0;
    [timer invalidate];
    timer = nil;
    self.Play.tag = 101;

    

}
@end
