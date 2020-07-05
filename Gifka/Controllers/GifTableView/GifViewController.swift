//
//  ViewController.swift
//  Gifka
//
//  Created by Александр on 04.07.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SDWebImage


class GifViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var serachTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    var dataManager = DataManager()
    var gifs = [Gifs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonWidthConstraint.constant = 0
        
        searchTextField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.7681049705, green: 1, blue: 0.9786186814, alpha: 1)
        tableView.register(UINib(nibName: "GifTableViewCell", bundle: nil), forCellReuseIdentifier: "GifTableViewCell")
        
        DispatchQueue.global().async {
            self.loadGifs(for: "cats")
        }
    }
    
    func loadGifs(for name: String) {
        dataManager.fetchGif(searchedGif: name) { [weak self] searchedGifs in
            self?.gifs = searchedGifs
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.buttonWidthConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        searchTextField.text = ""
        searchTextField.endEditing(true)
        loadGifs(for: "cats")
    }
}

// MARK: TableView

extension GifViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GifTableViewCell", for: indexPath) as! GifTableViewCell
        if !gifs.isEmpty {
            let arrayOfGifs = gifs[indexPath.row]
            
            DispatchQueue.global().async {
                cell.configure(with: arrayOfGifs)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "fullImage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullImage" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let imagesVC = segue.destination as! FullImageViewController
                imagesVC.gifId = gifs[indexPath.row].id
            }
        }
    }
}

//MARK: SearchTextField

extension GifViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.buttonWidthConstraint.constant = 50
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            print(1)
            loadGifs(for: "cats")
        }
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchedText = searchTextField.text {
            loadGifs(for: searchedText)
        }
    }
    
    
}


