//
//  ZMEntryListViewController.m
//  Diary
//
//  Created by Anthony Ho on 13/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import "ZMEntryListViewController.h"
#import "ZMCoreDataStack.h"
#import "ZMDiaryEntry.h"
#import "ZMEntryViewController.h"

@interface ZMEntryListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;

@end

@implementation ZMEntryListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"edit"]){
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        ZMEntryViewController *entryViewController = (ZMEntryViewController*) navigationController.topViewController;
        entryViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    } //method is when segue is performed
    //grab index path of that cell that is tapped and the configure entryviewcontroller
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];

    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ZMDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entry.body;
    
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZMDiaryEntry * entry = [ self.fetchedResultsController objectAtIndexPath:indexPath];
    ZMCoreDataStack *coreDataStack = [ZMCoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections] [section];
    return [sectionInfo name];
    
}

-(NSFetchRequest*) entryListFetchRequest {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ZMDiaryEntry"];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
}


- (NSFetchedResultsController*) fetchedResultsController {
    if(_fetchedResultsController !=nil){
        return _fetchedResultsController;
    }
    ZMCoreDataStack *coreDataStack = [ZMCoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self entryListFetchRequest];
    
    _fetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResultsController.delegate=self;
    
    return _fetchedResultsController;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController*) controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type){
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

-(void) controller:(NSFetchedResultsController*) controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch(type){
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections: [NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation: UITableViewRowAnimationAutomatic];
}

}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView endUpdates];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
