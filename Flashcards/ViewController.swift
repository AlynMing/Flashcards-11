//
//  ViewController.swift
//  Flashcards
//
//  Created by Essence Cain on 2/20/20.
//  Copyright © 2020 Essence Cain. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel! //answer
    @IBOutlet weak var frontLabel: UILabel! //question
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current flashcard index
    var currentIndex = 0
    
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
        
        
        //Read saved flashcards
        readSavedFlashcards()
        
        //Adding our intial flashcard if needed
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the capital of New Mexico?", answer: "Santa Fe", extraAnswerOne: "Albuquerque", extraAnswerTwo: "Farmington", isExisting: true)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        if(frontLabel.isHidden == true) {
            frontLabel.isHidden = false;
        } else {
            frontLabel.isHidden = true;
        }
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer)
        
        //Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        if isExisting {
            
            //Replace existing flashcard
            flashcards[currentIndex] = flashcard
        } else {
            
            //Adding flashcard i nthe flashcards array
            flashcards.append(flashcard)
            
            //Logging to the console
            print("Added a new flashcard")
            print("We now have \(flashcards.count) flashcards")
            
            //Update current index
            currentIndex = flashcards.count - 1
            print("Our current index is \(currentIndex)")
        }
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
        
        buttonOne.setTitle(extraAnswerOne, for: .normal)
        buttonTwo.setTitle(answer, for: .normal)
        buttonThree.setTitle(extraAnswerTwo, for: .normal)

        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        //Disable the Next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        //Disable the Prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
        
    }
    
    func updateLabels() {
        //Get current flashcards
        let currentFlashcard = flashcards[currentIndex]
        
        //Update label
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
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
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //Decrease current index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //Increase current index
        currentIndex = currentIndex + 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        
        //Show confirmation
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteCurrentFlashcard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard() {
        
        //Delete current
        flashcards.remove(at: currentIndex)
        
        //Special case: Check if last card was deleted
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
            
        updateNextPrevButtons()
            
        updateLabels()
            
        saveAllFlashcardsToDisk()
        }
    }
    
    
    func saveAllFlashcardsToDisk() {
        
        //From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        //Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //Log it
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        //Read dictionary array from disk(if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            //In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //Put all these cards in our flashcards array
                flashcards.append(contentsOf: savedCards)
                
            
        }
    }
}

