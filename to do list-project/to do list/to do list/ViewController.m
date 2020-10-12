#import "ViewController.h"
@interface ViewController ()<UIAlertViewDelegate>
@property (nonatomic) NSMutableArray *items;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.items =@[@{@"name" : @"e.g. take out the task",@"category" : @"home"},@{@"name" : @"e.g. reply to that important email",@"category" : @"work"}].mutableCopy;
    self.navigationItem.title = @"To Do List";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];//1
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - adding item
-(void)addNewItem:(UIBarButtonItem *)sender{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"New to-do item" message:@"please enter the name of the new to-do item" delegate:self cancelButtonTitle:@"Cencel" otherButtonTitles:@"Add Item", nil];
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != alertView.cancelButtonIndex){
        UITextField *itemNameField = [alertView textFieldAtIndex:0];
        NSString *itemName = itemNameField.text;
        NSDictionary *item = @{@"name":itemName,@"category":@"home"};
        [self.items addObject:item];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TodoItemRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text=item[@"name"];
    if ([item[@"completed"]boolValue]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *item = [self.items[indexPath.row]mutableCopy];
    BOOL completed =[item[@"completed"]boolValue];
    item[@"completed"]=@(!completed);
    self.items[indexPath.row]=item;
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=([item[@"completed"]boolValue])?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [_items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
