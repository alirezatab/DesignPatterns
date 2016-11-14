//
//  ViewController.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/10/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    private var allAlbums = [Album]()
    private var currentAlbumData : (titles:[String], values:[String])?
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
    }
    
    func showDataForAlbum(albumIndex: Int) {
        // defensive code: make sure the requested index is lower than the amount of albums
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

