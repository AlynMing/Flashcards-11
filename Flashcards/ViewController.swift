//
//  ViewController.swift
//  Flashcards
//
//  Created by Essence Cain on 2/20/20.
//  Copyright © 2020 Essence Cain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel! //answer
    @IBOutlet weak var frontLabel: UILabel! //question
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20.0;
        card.layer.shadowRadius = 15.0;
        card.layer.shadowOpacity = 0.5;
        backLabel.clipsToBounds = true;
        frontLabel.clipsToBounds = true;
        backLabel.layer.cornerRadius = 20.0;
        frontLabel.layer.cornerRadius = 20.0;
        buttonOne.layer.cornerRadius = 20.0;
        buttonOne.layer.borderWidth = 3.0;
        buttonOne.layer.borderColor = #colorLiteral(red: 0.4288981259, green: 0.8103226423, blue: 0.9652158618, alpha: 1);
        buttonTwo.layer.cornerRadius = 20.0;
        buttonTwo.layer.borderWidth = 3.0;
        buttonTwo.layer.borderColor = #colorLiteral(red: 0.4288981259, green: 0.8103226423, blue: 0.9652158618, alpha: 1);
        buttonThree.layer.cornerRadius = 20.0;
        buttonThree.layer.borderWidth = 3.0;
        buttonThree.layer.borderColor = #colorLiteral(red: 0.4288981259, green: 0.8103226423, blue: 0.9652158618, alpha: 1);
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        if(frontLabel.isHidden == true) {
            frontLabel.isHidden = false;
        } else {
            frontLabel.isHidden = true;
        }
    }
    
    @IBAction func didTapButtonOne(_ sender: Any) {
        buttonOne.isHidden = true;
    }
    
    @IBAction func didTapButtonTwo(_ sender: Any) {
        frontLabel.isHidden = true;
    }
    
    @IBAction func didTapButtonThree(_ sender: Any) {
        buttonThree.isHidden = true;
    }
    
}

