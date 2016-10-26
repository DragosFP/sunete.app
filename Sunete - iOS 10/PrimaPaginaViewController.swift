//
//  PrimaPaginaViewController.swift
//  Sunete - iOS 10
//
//  Created by Dragos Florin on 10/9/16.
//  Copyright © 2016 Dragos Florin. All rights reserved.
//

import UIKit
import AVFoundation

class PrimaPaginaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sunete : [Sunet] = []
    var asculta : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try sunete = context.fetch(Sunet.fetchRequest())
            tableView.reloadData()
        }catch{}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sunete.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let linie = UITableViewCell()
        
        let sunet = sunete [indexPath.row]
        
        linie.textLabel?.text = sunet.nume
        
        return linie
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sunet = sunete [indexPath.row]
        do{
            asculta = try AVAudioPlayer(data: sunet.audio! as Data)
            asculta?.play()
            } catch {}
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
        let sunet = sunete [indexPath.row]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(sunet)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                try sunete = context.fetch(Sunet.fetchRequest())
                tableView.reloadData()
            }catch{}
        }
    }
    
}
