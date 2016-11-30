//
//  ViewController.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/10/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var scroller: HorizontalScroller!
    // private is only seen in ViewController and not any of the extension within the file
    // fileprivate is private for other files but even etensions of this file can see it
    fileprivate var allAlbums = [Album]()
    fileprivate var currentAlbumData : (titles:[String], values:[String])?
    fileprivate var currentAlbumIndex = 0
    
    // We will use this array as a stack to push and pop operation for the undo option
    var undoStack: [(Album, Int)] = [] // The undoStack will hold a tuple of two arguments
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1
        self.navigationController?.navigationBar.isTranslucent = false
        currentAlbumIndex = 0
        
        //2
        //Get a list of all the albums via the API. Remember, the plan is to use the facade of LibraryAPI rather than PersistencyManager directly
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        //3
        //the uitableview that presents the album data
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.backgroundView = nil
        view.addSubview(dataTable!)
        
        self.showDataForAlbum(currentAlbumIndex)
        
        scroller.delegate = self
        reloadScroller()
        //loadPreviousState()
        
        
        // The above code creates a toolbar with two buttons and a flexible space between them. The undo button is disabled here because the undo stack starts off empty. Note that the toolbar is already in the storyboard, so all you need to do is set the toolbar items.
        let undoButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action:  #selector(ViewController.undoAction))
        undoButton.isEnabled = false
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(ViewController.deleteAlbum))
        let toolbarButtonItems = [undoButton, space, trashButton]
        toolbar.setItems(toolbarButtonItems, animated: true)
        
        
        // iOS sends a UIApplicationDidEnterBackgroundNotification notification when the app enters the background. You can use this notification to call saveCurrentState
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.saveCurrentState), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        // uses LibraryAPI to trigger the saving of album data whenever the ViewController saves its state.
        LibraryAPI.sharedInstance.saveAlbums()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showDataForAlbum(_ albumIndex: Int) {
        // defensive code: make sure the requested index is lower than the amount of albums
        if (albumIndex < allAlbums.count && albumIndex > -1) {
            //fetch albums
            let album = allAlbums[albumIndex]
            //save the albums data to present it later in tableview
            currentAlbumData = album.ae_tableRepresentation()
        } else{
            currentAlbumData = nil
        }
        // we have the data we need, let's refresh our tableview
        dataTable!.reloadData()
    }
    
    func reloadScroller() {
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        if currentAlbumIndex < 0 {
            currentAlbumIndex = 0
        } else if currentAlbumIndex >= allAlbums.count {
            currentAlbumIndex = allAlbums.count - 1
        }
        scroller.reload()
        showDataForAlbum(currentAlbumIndex)
    }
    
    // This is what the optional method initialViewIndexForHorizontalScroller was meant for! Since that method’s not implemented in the delegate, ViewController in this case, the initial view is always set to the first view.
    func initialViewIndex(_ scroller: HorizontalScroller) -> Int {
        // Now the HorizontalScroller first view is set to whatever album is indicated by currentAlbumIndex.
        return currentAlbumIndex
    }
    
    //MARK: Memento Pattern
    func saveCurrentState() {
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed album.
        // Since it's only one piece of information we can use NSUserDefaults.
        UserDefaults.standard.set(currentAlbumIndex, forKey: "currentAlbumIndex")
    }
    
    func loadPreviousState() {
        // loadPreviousState loads the previously saved index
        currentAlbumIndex = UserDefaults.standard.integer(forKey: "currentAlbumIndex")
        showDataForAlbum(currentAlbumIndex)
    }

    func addAlbumAtIndex(album: Album, index: Int) {
        LibraryAPI.sharedInstance.addAlbum(album: album, index: index)
        currentAlbumIndex = index
        reloadScroller()
    }
    
    func deleteAlbum() {
        // 1 - Get the album to delete.
        let deleteAlbum : Album = allAlbums[currentAlbumIndex]
        // 2 - Create a variable called undoAction which stores a tuple of Album and the index of the album. You then add the tuple into the stack
        let undoAction = (deleteAlbum, currentAlbumIndex)
        undoStack.insert(undoAction, at: 0)
        // 3 - Use LibraryAPI to delete the album from the data structure and reload the scroller.
        LibraryAPI.sharedInstance.deleteAlbum(index: currentAlbumIndex)
        reloadScroller()
        // 4 - ince there’s an action in the undo stack, you need to enable the undo button.
        let barButtonItems = toolbar.items as [UIBarButtonItem]!
        let undoButton : UIBarButtonItem = barButtonItems![0]
        undoButton.isEnabled = true
        // 5 - astly check to see if there are any albums left; if there aren’t any you can disable the trash button
        if (allAlbums.count == 0) {
            let trashButton : UIBarButtonItem = barButtonItems![2]
            trashButton.isEnabled = false
        }
    }
    
    func undoAction() {
        let barButtonItems = toolbar.items as [UIBarButtonItem]!
        // 1 - The method “pops” the object out of the stack, giving you a tuple containing the deleted Album and its index. You then proceed to add the album back.
        if undoStack.count > 0 {
            let (deleteAlbum, index) = undoStack.remove(at: 0)
            addAlbumAtIndex(album: deleteAlbum, index: index)
        }
        // 2 - Since you also deleted the last object in the stack when you “popped” it, you now need to check if the stack is empty. If it is, that means that there are no more actions to undo. So you disable the Undo button.
        if undoStack.count == 0 {
            let undoButton : UIBarButtonItem = barButtonItems![0]
            undoButton.isEnabled = false
        }
        // 3 - You also know that since you undid an action, there should be at least one album cover. Hence you enable the trash button.
        let trashButton : UIBarButtonItem = barButtonItems![2]
        trashButton.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


///You can actually add the methods to the main class declaration or to the extension; the compiler doesn’t care that the data source methods are actually inside the UITableViewDataSource extension. For humans reading the code though, this kind of organization really helps with readability.
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let albumData = currentAlbumData {
            return albumData.titles.count
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        if let albumData = currentAlbumData {
            cell.textLabel!.text = albumData.titles[indexPath.row]
            cell.detailTextLabel!.text = albumData.values[indexPath.row]
        }
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    
}



extension ViewController: HorizontalScrollerDelegate {
    func numberOfViewsForHorizontalScroller(_ scroller: HorizontalScroller) -> (Int) {
        return allAlbums.count
    }
    
    func horizontalScrollerViewAtIndex(_ scroller: HorizontalScroller, index: Int) -> (UIView) {
        let album = allAlbums[index]
        let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), albumCover: album.coverUrl)
        if currentAlbumIndex == index {
            albumView.highlightAlbum(didHighlightView: true)
        } else {
            albumView.highlightAlbum(didHighlightView: false)
        }
        return albumView
    }
    
    func horizontalScrollerClickedViewAtIndex(_ scroller: HorizontalScroller, index: Int) {
        //1
        let previousAlbumView = scroller.viewAtIndex(currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(didHighlightView: false)
        //2
        currentAlbumIndex = index
        //3
        let albumView = scroller.viewAtIndex(index) as! AlbumView
        albumView.highlightAlbum(didHighlightView: true)
        //4
        showDataForAlbum(index)
    }
}
