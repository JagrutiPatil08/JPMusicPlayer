//
//  ViewController.h
//  JPMusicPlayer
//
//  Created by Kalyani on 04/11/16.
//  Copyright © 2016 Jagruti Patil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

{
    AVAudioPlayer *audioPlayer;
    BOOL isPlaying;
    NSTimer *timer;

}
@property (strong, nonatomic) IBOutlet UISlider *sliderDuration;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewArtWork;
@property (strong, nonatomic) IBOutlet UIButton *Play;

- (IBAction)Play:(id)sender;


- (IBAction)Stop:(id)sender;

@end

