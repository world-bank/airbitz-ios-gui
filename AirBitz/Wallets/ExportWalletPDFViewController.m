//
//  ExportWalletPDFViewController.m
//  AirBitz
//
//  Created by Adam Harris on 6/3/14.
//  Copyright (c) 2014 AirBitz. All rights reserved.
//

#import "ExportWalletPDFViewController.h"
#import "Util.h"
#import "CommonTypes.h"


@interface ExportWalletPDFViewController () <UIWebViewDelegate>
{

}

@property (weak, nonatomic) IBOutlet UIView     *viewDisplay;
@property (weak, nonatomic) IBOutlet UIWebView  *webView;

@end

@implementation ExportWalletPDFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // resize ourselves to fit in area
    [Util resizeView:self.view withDisplayView:self.viewDisplay];

    self.webView.scalesPageToFit = YES;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadData:self.dataPDF MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action Methods

- (IBAction)buttonBackTouched:(id)sender
{
    [self animatedExit];
}

#pragma mark - Misc Methods

- (void)animatedExit
{
	[UIView animateWithDuration:0.35
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^
	 {
		 CGRect frame = self.view.frame;
		 frame.origin.x = frame.size.width;
		 self.view.frame = frame;
	 }
                     completion:^(BOOL finished)
	 {
		 [self exit];
	 }];
}

- (void)exit
{
	[self.delegate exportWalletPDFViewControllerDidFinish:self];
}

@end