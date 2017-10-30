//
//  ViewController.swift
//  FMDBTest01
//
//  Created by Koulutus on 04/10/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var familyname: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    @IBAction func SAVEaction(_ sender: UIButton) {
        if FileManager.default.fileExists(atPath: dbpath)
        {
            // No DB connection to file so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be opened
            if (connectiontoFMDB.open())
            {
                let sqlstatement = "insert into person (firstname, familyname, phone) values ('\(self.firstname.text!)','\(self.familyname.text!)','\(self.phone.text!)');"
                let result = connectiontoFMDB.executeUpdate(sqlstatement, withArgumentsIn: [])
                if !result {
                    self.status.text = "SAVE FAILURE"
                }
                NSLog(connectiontoFMDB.debugDescription)
            }
            connectiontoFMDB.close()
        }
    }
    
    @IBAction func LOADaction(_ sender: UIButton) {
        if FileManager.default.fileExists(atPath: dbpath)
        {
            // No DB connection to file so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be opened
            if (connectiontoFMDB.open())
            {
                let sqlstatement = "select familyname, phone from person where firstname = '\(self.firstname.text!)';"
                let resultset : FMResultSet = connectiontoFMDB.executeQuery(sqlstatement, withArgumentsIn: [])!
                if resultset.next() == true {
                    self.familyname.text = resultset.string(forColumn: "familyname")
                    self.phone.text = resultset.string(forColumn: "phone")
                } else
                {
                    self.status.text = "QUERY FAILURE"
                }
                NSLog(connectiontoFMDB.debugDescription)
            }
            connectiontoFMDB.close()
        }
    }
    
    @IBAction func DELETEaction(_ sender: UIButton) {
        if FileManager.default.fileExists(atPath: dbpath)
        {
            // No DB connection to file so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be opened
            if (connectiontoFMDB.open())
            {
                let sqlstatement = "delete from person where firstname = '\(self.firstname.text!)';"
                let result = connectiontoFMDB.executeUpdate(sqlstatement, withArgumentsIn: [])
                if !result == true {
                    self.status.text = "DELETE FAILURE"
                }
                NSLog(connectiontoFMDB.debugDescription)
            }
            connectiontoFMDB.close()
        }
    }

    @IBAction func UPDATEaction(_ sender: UIButton) {
        if FileManager.default.fileExists(atPath: dbpath)
        {
            // No DB connection to file so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be opened
            if (connectiontoFMDB.open())
            {
                let sqlstatement = "select familyname, phone from person where firstname = '\(self.firstname.text!)';"
                let resultset : FMResultSet = connectiontoFMDB.executeQuery(sqlstatement, withArgumentsIn: [])!
                if resultset.next() == true {
                    self.familyname.text = resultset.string(forColumn: "familyname")
                    self.phone.text = resultset.string(forColumn: "phone")
                } else
                {
                    self.status.text = "UPDATE FAILURE"
                }
                NSLog(connectiontoFMDB.debugDescription)
            }
            connectiontoFMDB.close()
        }
    }
    
    var dbpath : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // we use default filemanager in this exercise
        // it is FilemManager.default
        
        //find path to database
        let pathdummy = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // The path to DB location is set into document directory root
        // and name of DB is set as mydatabase.db
        
        dbpath = pathdummy[0].appendingPathComponent("mydatabase.db").path

        if !FileManager.default.fileExists(atPath: dbpath)
        {
            // No DB found so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)

            //connection to DB must be established if it is not working
            if (connectiontoFMDB.open())
            {
                let sqlstatement = "create table if not exists person (id integer primary key autoincrement, firstname text, familyname text, phone integer);"
                connectiontoFMDB.executeStatements(sqlstatement)
                NSLog(connectiontoFMDB.debugDescription)
                NSLog(dbpath)
           }
            connectiontoFMDB.close()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

