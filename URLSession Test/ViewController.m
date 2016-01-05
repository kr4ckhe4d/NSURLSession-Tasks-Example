//
//  ViewController.m
//  URLSession Test
//
//  Created by Nipuna H Herath on 1/5/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
NSURLSessionDownloadTask *getImageTask;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressView setProgress:0 animated:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)fetchImage:(id)sender {
    //Getting the Image and viewing it on the Image View
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSString *imageURL = @"https://2.bp.blogspot.com/-kptChpiuaf0/VeSjz-zMUzI/AAAAAAAAAxE/REIiZ4qVI2s/s1600/150824_GoogleBlog_Share.png";
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:self delegateQueue:nil];
    
    getImageTask = [session downloadTaskWithURL:[NSURL URLWithString:imageURL]];
    
    [getImageTask resume];
    
}
- (IBAction)printData:(id)sender {
    //Getting JSON data using NSURLSession
    NSString *weatherURL = @"http://api.openweathermap.org/data/2.5/weather?q=Colombo&appid=2de143494c0b295cca9337e1e96b00e0";
     
     
     NSURLSession *session = [NSURLSession sharedSession];
     
     [[session dataTaskWithURL:[NSURL URLWithString:weatherURL ] completionHandler:^(NSData *data,
     NSURLResponse *response,
     NSError *error){
     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
     NSLog(@"%@", json);
     }]resume];
     
    
}

//Image download Completion Handler
-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    // use code above from completion handler
    UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = downloadedImage;
    }
                   );
    
}

//Image Download Progress bar
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
        float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:progress];
        });
}

@end
