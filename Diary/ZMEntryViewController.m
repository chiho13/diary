//
//  ZMNewEntryViewController.m
//  Diary
//
//  Created by Anthony Ho on 10/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import "ZMEntryViewController.h"
#import "ZMDiaryEntry.h"
#import "ZMCoreDataStack.h"
#import <CoreLocation/CoreLocation.h>

@interface ZMEntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, assign) enum ZMDiaryEntryMood pickedMood;
@property (nonatomic, strong) UIImage *pickedImage;

@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end


@implementation ZMEntryViewController

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
    
    NSDate *date;
    
    if (self.entry !=nil){
        self.textView.text = self.entry.body;
        self.pickedMood=self.entry.mood;
        
        date= [NSDate dateWithTimeIntervalSince1970:self.entry.date];
        [self setPickedImage:[UIImage imageWithData:self.entry.imageData]];
    } else {
        self.pickedMood= ZMDiaryEntryMoodAverage;
        date = [NSDate date];
        [self loadLocation];
    }
    
    NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEE d MMM yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    self.textView.inputAccessoryView = self.accessoryView;
    
    self.imageButton.layer.cornerRadius=CGRectGetWidth(self.imageButton.frame)/2.0f;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissSelf{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)loadLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000;
    
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark =[placemarks firstObject];
        self.location = placemark.name;
    }];
}

-(void)insertDiaryEntry {
    ZMCoreDataStack *coreDataStack =[ZMCoreDataStack defaultStack];
    ZMDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"ZMDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData =  UIImageJPEGRepresentation(self.pickedImage, 0.75);
    entry.mood = self.pickedMood;
    entry.location = self.location;
    
    [coreDataStack saveContext];
    
}
-(void) updateDiaryEntry{
    ZMCoreDataStack *coreDataStack = [ZMCoreDataStack defaultStack];
    self.entry.body=self.textView.text;
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    self.entry.mood = self.pickedMood;
    
    [coreDataStack saveContext];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setPickedMood:(enum ZMDiaryEntryMood)pickedMood{
    _pickedMood = pickedMood;
    
    self.badButton.alpha = 0.5f;
    self.averageButton.alpha=0.5f;
    self.goodButton.alpha=0.5f;
    
    switch (pickedMood){
        case ZMDiaryEntryMoodGood:
            self.goodButton.alpha= 1.0f;
            break;
        case ZMDiaryEntryMoodAverage:
            self.averageButton.alpha= 1.0f;
            break;
        case ZMDiaryEntryMoodBad:
            self.badButton.alpha= 1.0f;
            break;
    
        
    }
}

-(void) setPickedImage:(UIImage *) pickedImage{
    _pickedImage = pickedImage;
    if (pickedImage==nil){
        [self.imageButton setImage: [UIImage imageNamed:@"icn_noimage"] forState: UIControlStateNormal];
    } else{
        [self.imageButton setImage: pickedImage forState: UIControlStateNormal];
    }
}


-(void) promptForSource{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    
    [actionSheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex !=actionSheet.cancelButtonIndex){
        if(buttonIndex !=actionSheet.firstOtherButtonIndex){
            [self promptForPhotoRoll];
        } else{
            [self promptForCamera];
        }
    }
}
-(void) promptForCamera{
    UIImagePickerController * controller = [[UIImagePickerController alloc ]init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void) promptForPhotoRoll{
    UIImagePickerController * controller = [[UIImagePickerController alloc ]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)doneWasPressed:(id)sender {
    if(self.entry !=nil){
        [self updateDiaryEntry];
    }else{
        [self insertDiaryEntry];
        
    }
    
    [self dismissSelf];
}

- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}
- (IBAction)badWasPressed:(id)sender {
    self.pickedMood = ZMDiaryEntryMoodBad;
}
- (IBAction)averageWasPressed:(id)sender {
    self.pickedMood = ZMDiaryEntryMoodAverage;

}
- (IBAction)goodWasPressed:(id)sender {
    self.pickedMood = ZMDiaryEntryMoodGood;

}
- (IBAction)imageButtonWasPressed:(id)sender {
}

- (IBAction)imageSelectionButtonWasPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptForSource];
    }else {
        [self promptForPhotoRoll];
    }
    }
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
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

@end
