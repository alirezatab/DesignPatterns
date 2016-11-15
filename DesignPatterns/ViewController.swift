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
    //private is only seen in ViewController and not any of the extension within the file
    //fileprivate is private for other files but even etensions of this file can see it
    private var allAlbums = [Album]()
    fileprivate var currentAlbumData : (titles:[String], values:[String])?
    private var currentAlbumIndex = 0
    
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
        
        self.showDataForAlbum(albumIndex: currentAlbumIndex)
    }
    
    func showDataForAlbum(albumIndex: Int) {
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

extension ViewController : HorizontalScrollerDelegate{
    func horizontalScrollerClicledViewAtIndex(scroller: HorizontalScroller, index: Int) {
        //1 
        let previousAlbumView = scroller.viewAtIndex(index: currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(didHighlightView: false)
        //2
        
        
    }
}
