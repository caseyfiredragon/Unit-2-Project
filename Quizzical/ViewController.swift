//
//  ViewController.swift
//  Quizzical
//
//  Created by Casey Conway on 4/21/19.
//  Copyright © 2019 Casey Conway. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {

    //Properties
    
    //Game sounds and functions in the SoundProvier file
    
    let totalQuestions = qAndASet.count //Total number of questions
    var correctAnswers = 0 //Keeps track of correct answers
    var currentQuestion = qAndASet[0] //Keeps track of the current question
    
    //Array used to track what questions remain unasked...
    //by storing the index of their position in the qAndASet array.
    //Index values are removed from this array when a question is asked.
    var unaskedQuestionIndices = Array(0...(qAndASet.count - 1))
    
    //Colors for result text field when right or wrong answer selected
    let correctColor = UIColor(red: 65.0/255, green: 145.0/255, blue: 135.0/255, alpha: 1.0)
    let wrongColor = UIColor(red: 242.0/255, green: 166.0/255, blue: 110.0/255, alpha: 1.0)
    
    //Enabled/Disabled Button Color Settings
    let enabledButtonBackgroundColor: UIColor = UIColor(red: 54/255.0, green: 119/255.0, blue: 147/255.0, alpha: 1.0)
    let disabledButtonBackgroundColor: UIColor = UIColor(red: 54/255.0, green: 119/255.0, blue: 147/255.0, alpha: 0.5)
    let enabledButtonTextColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let disabledButtonTextColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
    
    // Outlets
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var resultField: UILabel!
    @IBOutlet weak var answerOneButton: UIButton!
    @IBOutlet weak var answerTwoButton: UIButton!
    @IBOutlet weak var answerThreeButton: UIButton!
    @IBOutlet weak var answerFourButton: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    
    //Check box images to indicate correct answer
    @IBOutlet weak var checkAnswerButtonOne: UIImageView!
    @IBOutlet weak var checkAnswerButtonTwo: UIImageView!
    @IBOutlet weak var checkAnswerButtonThree: UIImageView!
    @IBOutlet weak var checkAnswerButtonFour: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Round all buttons
        let allButtons: [UIButton] = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton, progressButton]
        for button in allButtons {
            button.layer.cornerRadius = 8.0
        }
        
        //Start the quiz by showing the first question and playing a sound
        loadGameSounds()
        gameStartSound.playGameSound()
        displayQuestion()
    }
    
    //HELPERS
    
    //Load game sounds
    func loadGameSounds() {
        for gameSound in gameSounds {
            let path = Bundle.main.path(forResource: gameSound.fileName, ofType: "m4a")
            let soundUrl = URL(fileURLWithPath: path!)
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound.systemSoundID)
        }
    }
    
    //Show a question
    func displayQuestion() {
        //Hide certain fields
        resultField.isHidden = true
        progressButton.isHidden = true
        hideAllCheckMarks()
        
        //Get a random question that hasn't been asked before
        let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: unaskedQuestionIndices.count-1)
        let currentQuestionIndex = unaskedQuestionIndices[randomIndex]
        currentQuestion = qAndASet[currentQuestionIndex]
        //remove question index from the array of unasked questions
        unaskedQuestionIndices.remove(at: randomIndex)
        
        //Set up labels and buttons with q&a's and enabled state
        displayAnswerButtons()
        questionField.text = currentQuestion.question
        answerOneButton.setTitle(currentQuestion.answers[0],for: UIControl.State())
        answerTwoButton.setTitle(currentQuestion.answers[1],for: UIControl.State())
        answerThreeButton.setTitle(currentQuestion.answers[2],for: UIControl.State())
        if currentQuestion.answers.count > 3 {
            answerFourButton.setTitle(currentQuestion.answers[3],for: UIControl.State())
        } else {
            answerFourButton.isHidden = true
        }
        
        //Start a countdown timer that gives you 15 seconds to answer a question
        setupTimer(delay: 15)
    }
    
    //Sets up a timer
    func setupTimer(delay seconds: Int){
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        let originalQuestion = self.currentQuestion
        // progresses the game at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            //Only execute the timer if on the same unanswered question when the time's up
            if originalQuestion.question == self.currentQuestion.question && self.resultField.isHidden == true {
                if self.unaskedQuestionIndices.count == 0 {
                    //game over
                    self.displayScore()
                } else {
                    //Ran out of time but game continues.
                    //Show results screen with no button selected.
                    //Values for pressed button and answer are zero to represent nothing pressed
                    self.setSelectedAnswerButtonState(exceptPressedButtonNumber: 0)
                    self.checkAnswerAndSetResultField(forSelectedAnswerNumber: 0)
                    
                }
            }
        }
    }
    
    //Hides all check marks which indicate correct answer on buttons
    func hideAllCheckMarks(){
        let allCheckMarks: [UIImageView] = [checkAnswerButtonOne, checkAnswerButtonTwo, checkAnswerButtonThree, checkAnswerButtonFour]
        for checkMark in allCheckMarks {
            checkMark.isHidden = true
        }
    }
    
    //Changes buttons for the selected answer state and reveals answer
    func setSelectedAnswerButtonState(exceptPressedButtonNumber pressedButtonNumber: Int){
        let answerButtons: [UIButton] = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        let allCheckMarks: [UIImageView] = [checkAnswerButtonOne, checkAnswerButtonTwo, checkAnswerButtonThree, checkAnswerButtonFour]
        
        //Update state for answer buttons
        var buttonNumber = 1 //counter
        //if pressedButtonNumber == 0 then no buttons will appear selected
        for button in answerButtons {
            if buttonNumber != pressedButtonNumber {
                button.setTitleColor(disabledButtonTextColor, for: UIControl.State())
            } else {
                button.setTitleColor(.white, for: UIControl.State())
            }
            button.isEnabled = false
            button.backgroundColor = disabledButtonBackgroundColor
            
            if buttonNumber == currentQuestion.correctAnswerNumber {
                allCheckMarks[buttonNumber - 1].isHidden = false
            }
            buttonNumber += 1
        }
        
        //Update state for progress button
        //If no unasked questions remaining, show "Complete Quiz",
        progressButton.isHidden = false
        if unaskedQuestionIndices.count == 0 {
            //Game is over
            progressButton.setTitle("Complete Quiz",for: UIControl.State())
        }
    }
    
    //Displays the answer buttons in a ready-to-be-selected state
    func displayAnswerButtons(){
        let answerButtons: [UIButton] = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        for button in answerButtons {
            button.isEnabled = true
            button.setTitleColor(enabledButtonTextColor, for: UIControl.State())
            button.backgroundColor = enabledButtonBackgroundColor
            button.isHidden = false
        }
    }
    
    //Returns the answer number given button pressed, starting at 1
    func getButtonNumber(forButtonPressed buttonPressed: UIButton) -> Int {
        let answerButtons: [UIButton] = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        var answerNumber = 0
        var n = 1
        for button in answerButtons {
            if button == buttonPressed {
                answerNumber = n
            }
            n += 1
        }
        return answerNumber
    }
    
    //Hides all the answer buttons
    func hideAllAnswerButtons(){
        let answerButtons: [UIButton] = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        for button in answerButtons {
            button.isHidden = true
        }
    }
    
    //Sets result field text and color according to whether answer is correct or question timed out. Play sounds accordingly.
    func checkAnswerAndSetResultField(forSelectedAnswerNumber selectedAnswerNumber: Int) {
        resultField.isHidden = false
        
        if currentQuestion.isAnswerCorrect(forSelectedAnswerNumber: selectedAnswerNumber) {
            //answer is right
            resultField.textColor = correctColor
            resultField.text = "That is correct!"
            correctAnswers += 1
            correctAnswerSound.playGameSound()
        } else {
            //answer is wrong or timed out
            resultField.textColor = wrongColor
            if selectedAnswerNumber == 0 {
                resultField.text = "Time's up!"
                timesUpSound.playGameSound()
            } else {
                resultField.text = "Sorry, that's wrong."
                incorrectAnswerSound.playGameSound()
            }
        }
    }
    
    //Shows the score when the quiz is complete and offers button to play again
    func displayScore() {
        //Play game end sound
        gameEndSound.playGameSound()
        
        //Hide the answer buttons
        hideAllAnswerButtons()
        hideAllCheckMarks()
        
        //Show play again button
        progressButton.setTitle("Play again",for: UIControl.State())
        progressButton.isHidden = false
        
        //Display score
        resultField.isHidden = false
        if correctAnswers * 2 >= totalQuestions {
            //If you got half or more right
            questionField.text = "Way to go! You got..."
            resultField.text = "\(correctAnswers) of \(totalQuestions) correct!"
            resultField.textColor = correctColor
        } else {
            questionField.text = "Better luck next time! You got..."
            resultField.text = "\(correctAnswers) of \(totalQuestions) correct."
            resultField.textColor = wrongColor
        }
    }
    
    //ACTIONS
    
    //Check answer when button selected and show the result
    @IBAction func checkAnswer(_ sender: UIButton) {
        //Gets the number corresponding to the button pressed
        let selectedAnswerNumber = getButtonNumber(forButtonPressed: sender)
        
        //Changes buttons for the selected answer state and reveals answer
        setSelectedAnswerButtonState(exceptPressedButtonNumber: selectedAnswerNumber)
        
        //Updates the text in the result field
        checkAnswerAndSetResultField(forSelectedAnswerNumber: selectedAnswerNumber)
    }
    
    //Progresses through the quiz when progress button pressed
    //Next state determined by number of unasked questions remaining
    @IBAction func progressThroughQuiz() {
        let questionsRemaining = unaskedQuestionIndices.count
        if questionsRemaining == 0 {
        //Game is over. Show score
            unaskedQuestionIndices = Array(0...(qAndASet.count - 1))
            displayScore()
            //Reset unasked question indices
        } else {
        //Show next question
            if questionsRemaining == totalQuestions {
            //Game is about to begin.
                //Play game start sound
                gameStartSound.playGameSound()
                //Set progress button title.
                progressButton.setTitle("Next Question", for: UIControl.State())
                //Reset number of correct answers 
                correctAnswers = 0
            }
            displayQuestion()
        }
    }

}


