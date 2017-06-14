//
//  ProfilesView.swift
//  Drag and Drop
//
//  Created by Andrei Movila on 6/13/17.
//  Copyright © 2017 Andrei Movila. All rights reserved.
//

import UIKit
import Contacts
class ProfilesView: UIView,UITableViewDragDelegate,UITableViewDropDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var itemsArray = [ProfileModel]()
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let provider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = itemsArray[indexPath.row]
        return [dragItem]
    }
    
    
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        parseImagesFromCoordinator(coordinator: coordinator)
        parseStringsFromCoordinator(coordinator: coordinator)
        parseProfileModelsFromCoordinator(coordinator: coordinator)
        parseContactsFromCoordinator(coordinator: coordinator)
    }
    
    func parseImagesFromCoordinator(coordinator:UITableViewDropCoordinator){
        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            // Consume drag items.
            let addToExisting = coordinator.proposal.intent == .insertIntoDestinationIndexPath
            for image in items{
                let profileModel = addToExisting ? self.itemsArray[(coordinator.destinationIndexPath?.row)!] : ProfileModel()
                profileModel.image = image as! UIImage
                if addToExisting == false {
                    self.itemsArray.append(profileModel)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func parseStringsFromCoordinator(coordinator:UITableViewDropCoordinator)
    {
        let addToExisting = coordinator.proposal.intent == .insertIntoDestinationIndexPath
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            for string in items{
                let profileModel = addToExisting ? self.itemsArray[(coordinator.destinationIndexPath?.row)!] : ProfileModel()
                
                if let _:URL = URL(string: string as! String){
                    profileModel.subtitle = string as! String
                } else {
                    profileModel.title = string as! String
                }
                if addToExisting == false {
                    self.itemsArray.append(profileModel)
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    func parseContactsFromCoordinator(coordinator:UITableViewDropCoordinator)
    {
        coordinator.session.loadObjects(ofClass: ProfileModel.self) { items in
            for model in items{
                let profileModel = model as! ProfileModel
                self.itemsArray.append(profileModel)
            }
            self.tableView.reloadData()
        }
    }
    
    
    func parseProfileModelsFromCoordinator(coordinator:UITableViewDropCoordinator)
    {
        for dropItem in coordinator.items{
            if let profile : ProfileModel = dropItem.dragItem.localObject as? ProfileModel{
                if (dropItem.sourceIndexPath) != nil {
                    itemsArray.remove(at: (dropItem.sourceIndexPath?.row)!)
                    self.itemsArray.insert( profile, at: (coordinator.destinationIndexPath?.row)!)
                }
                else if coordinator.destinationIndexPath != nil{
                    self.itemsArray.insert( profile, at: (coordinator.destinationIndexPath?.row)!)
                }
                else {
                    self.itemsArray.insert( profile, at: 0)
                }
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if destinationIndexPath?.row == itemsArray.count {
            return UITableViewDropProposal(dropOperation: .copy, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(dropOperation: .move, intent: .insertIntoDestinationIndexPath)
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        cell.setupWithProfileModel(model: itemsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}




