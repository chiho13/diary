//
//  ZMNewEntryViewController.m
//  Diary
//
//  Created by Anthony Ho on 10/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import "ZMNewEntryViewController.h"
#import "ZMDiaryEntry.h"
#import "ZMCoreDataStack.h"

@interface ZMNewEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end


@implementation ZMNewEntryViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissSelf{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)insertDiaryEntry {
    ZMCoreDataStack *coreDataStack =[ZMCoreDataStack defaultStack];
    ZMDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"ZMDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.body = self.textField.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
    
}

- (IBAction)doneWasPressed:(id)sender {
    [self insertDiaryEntry];
    [self dismissSelf];
}
- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
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
