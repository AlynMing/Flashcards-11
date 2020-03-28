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
    var extraAnswerOne: String
    var extraAnswerTwo: String
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
    var correctAnswerButton: UIButton!
    
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
            updateFlashcard(question: "What is the capital of New Mexico?", answer: "Santa Fe", extraAnswerOne: "Albuquerque", extraAnswerTwo: "Farmington", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          //First start with the flashcard invisible and slightly smaller in size
          card.alpha = 0.0
          card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
          
          //Animation
          UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
              self.card.alpha = 1.0
              self.card.transform = CGAffineTransform.identity
          })
      }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
       flipFlashcard()
    }
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromTop, animations: {
            //self.frontLabel.isHidden = true
            if(self.frontLabel.isHidden == true) {
                self.frontLabel.isHidden = false;
                        } else {
                self.frontLabel.isHidden = true;
                        }
        })
    }
    
    func animateCardOut(reverse: Bool) {
        var translation = CGFloat(-300.0)
        if reverse {
            translation = CGFloat(300.0)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: translation, y: 0.0)
        }, completion: { finished in
            
            //Update labels
            self.updateLabels()
            
            //Run other animation
            self.animateCardIn(reverse: reverse)
        })
    }
    
    func animateCardIn(reverse: Bool) {
        var translation = CGFloat(300.0)
        if reverse {
            translation = CGFloat(-300.0)
        }
        //Start on the right side (don't animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: translation, y: 0.0)
        
        //Animate card going back to original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        
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
        
        //Update Buttons
        let buttons = [buttonOne, buttonTwo, buttonThree].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
        
        //Iterate over both arrays at the same time
        for(button, answer) in zip(buttons, answers) {
            //Set the title of this random button, with a random answer
            button?.setTitle(answer, for: .normal)
            
            //If this is the correct answer save the button
            if answer == currentFlashcard.answer {
                correctAnswerButton = button
            }
        }
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
        if buttonOne == correctAnswerButton {
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            buttonOne.isEnabled = false
        }
    }
    
    @IBAction func didTapButtonTwo(_ sender: Any) {
        if buttonTwo == correctAnswerButton {
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            buttonTwo.isEnabled = false
        }
    }
    
    @IBAction func didTapButtonThree(_ sender: Any) {
        if buttonThree == correctAnswerButton{
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            buttonThree.isEnabled = false
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //Decrease current index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        
        animateCardOut(reverse: true)
        
        //Update buttons
        updateNextPrevButtons()
        
        
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //Increase current index
        currentIndex = currentIndex + 1
        
        animateCardOut(reverse: false)
        
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
            return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne, "extraAnswerTwo": card.extraAnswerTwo]
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
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extraAnswerOne"]!, extraAnswerTwo: dictionary["extraAnswerTwo"]!)
            }
            
            //Put all these cards in our flashcards array
                flashcards.append(contentsOf: savedCards)
                
            
        }
    }
}

