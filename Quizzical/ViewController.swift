//
//  ViewController.swift
//  Quizzical
//
//  Created by Casey Conway on 4/21/19.
//  Copyright © 2019 Casey Conway. All rights reserved.
//

import UIKit
import GameKit //TODO: Might not need this
import AudioToolbox

class ViewController: UIViewController {

    //MARK: - Properties
    var isLightningModeOn = true //tracks whether lighting mode is on. Defaults to true
    
    //MARK: - Outlets
    //Buttons and labels
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var resultField: UILabel!
    @IBOutlet weak var answerOneButton: UIButton!
    @IBOutlet weak var answerTwoButton: UIButton!
    @IBOutlet weak var answerThreeButton: UIButton!
    @IBOutlet weak var answerFourButton: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    
    //Lighting mode components
    @IBOutlet weak var lightningModeSwitchTitle: UILabel!
    @IBOutlet weak var lightningModeSwitchSubtitle: UILabel!
    @IBOutlet weak var lightningModeSwitchToggle: UISwitch!
    @IBOutlet weak var countDownLabel: UILabel! //count down timer label for lightning mode
    
    //Check box images to indicate correct answer
    @IBOutlet weak var checkAnswerButtonOne: UIImageView!
    @IBOutlet weak var checkAnswerButtonTwo: UIImageView!
    @IBOutlet weak var checkAnswerButtonThree: UIImageView!
    @IBOutlet weak var checkAnswerButtonFour: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load game sounds
        gameSounds.loadGameSounds()
        //Set the button style to rounded for the whole game
        roundAllButtons()
        //Set up the landing page
        setUpLandingPage()
    }
    
    //MARK: - Helpers
    
    //Round all the buttons
    func roundAllButtons(){
        let allButtons: [UIButton] = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton, progressButton]
        for button in allButtons {
            button.layer.cornerRadius = 8.0
        }
    }
    
    //Set up the landing page of the app. Users only see this once when opening.
    func setUpLandingPage(){
        gameLoadSound.playGameSound()
        questionField.isHidden = true
        resultField.text = "Welcome to Quizzical!"
        resultField.isHidden = false
        showLightningModeToggle(isAvailable: true)
        hideAllAnswerButtons()
        hideAllCheckMarks()
        progressButton.setTitle("Begin Game",for: UIControl.State())
        countDownLabel.isHidden = true
    }
    
    //Show or hide lightning mode toggle
    func showLightningModeToggle(isAvailable: Bool) {
        if isAvailable == true {
            lightningModeSwitchTitle.isHidden = false
            lightningModeSwitchSubtitle.isHidden = false
            lightningModeSwitchToggle.isHidden = false
            lightningModeSwitchToggle.isEnabled = true
        } else {
            lightningModeSwitchTitle.isHidden = true
            lightningModeSwitchSubtitle.isHidden = true
            lightningModeSwitchToggle.isHidden = true
            lightningModeSwitchToggle.isEnabled = false
        }
    }
    
    //Start a new game
    func startNewGame(){
        //Hide the lightning mode switch
        showLightningModeToggle(isAvailable: false)
        //Play the start game sound
        gameStartSound.playGameSound()
        //Update progress button title
        progressButton.setTitle("Next Question", for: UIControl.State())
        //Show question field and hide results field
        questionField.isHidden = false
        resultField.isHidden = true
        //Show the question and options
        displayQuestion()
    }
    
    //Show a question
    func displayQuestion() {
        //Hide certain fields
        resultField.isHidden = true
        progressButton.isHidden = true
        hideAllCheckMarks()
        
        //Get a random question that hasn't been asked before
        let currentQuestion = quizManager.returnRandomUnaskedQuestion()
        
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
        
        //If in lightning mode, start a countdown timer that gives you 15 seconds to answer a question
        if isLightningModeOn == true {
            startCountDownTimer(withTimeLimitInSeconds: 15)
        }
    }
    
    //Sets up a timer
    func startCountDownTimer(withTimeLimitInSeconds timeLimit: Int){
        let originalQuestion = quizManager.currentQuestion
        var timeRemaining = timeLimit
        countDownLabel.text = "\(timeRemaining) s"
        countDownLabel.isHidden = false
        timeRemaining -= 1
        
        //Start the countdown timer, shown in the UI
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
            //Continue countdown if there's time left, we're on the same question, and that question is unanswered
            if timeRemaining > 0 && originalQuestion.question == quizManager.currentQuestion.question && self.progressButton.isHidden == true {
                //Time's running out
                self.countDownLabel.text = "\(timeRemaining) s"
                timeRemaining -= 1
            } else {
                //Something's up... In any event, we need to stop the countdown and hide the label
                timer.invalidate()
                self.countDownLabel.isHidden = true
                
                //If it's the time that's up then...
                if timeRemaining == 0 {
                    if quizManager.isGameOver() {
                        //Game over
                        self.gameOver()
                    } else {
                        //Ran out of time but game continues.
                        //Show results screen with no button selected.
                        //Values for pressed button and answer are zero to represent nothing pressed
                        self.setSelectedAnswerButtonState(exceptPressedButtonNumber: 0)
                        self.checkAndDisplayResults(forSelectedAnswerNumber: 0)
                    }
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
            
            if buttonNumber == quizManager.currentQuestion.correctAnswerNumber {
                allCheckMarks[buttonNumber - 1].isHidden = false
            }
            buttonNumber += 1
        }
        
        //Update state for progress button
        progressButton.isHidden = false
        //If no unasked questions remaining, change the text field to "Complete Quiz",
        if quizManager.isGameOver() {
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
    func checkAndDisplayResults(forSelectedAnswerNumber selectedAnswerNumber: Int) {
        //Display results message
        resultField.isHidden = false
        
        //Set the text
        if quizManager.currentQuestion.isAnswerCorrect(forSelectedAnswerNumber: selectedAnswerNumber) {
            //Answer is correct
            quizManager.correctAnswers += 1
            resultField.textColor = correctColor
            resultField.text = "That is correct!"
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
    
    //Shows the score when the quiz is complete, offers button to play again, and displays switch for lighting mode
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
        if quizManager.gotMoreThanHalfCorrect() {
            questionField.text = "Way to go! You got..."
            resultField.text = quizManager.returnScoreString()
            resultField.textColor = correctColor
        } else {
            questionField.text = "Better luck next time! You got..."
            resultField.text = quizManager.returnScoreString()
            resultField.textColor = wrongColor
        }
        
        //Show lighting mode switch
        showLightningModeToggle(isAvailable: true)
    }
    
    //Shows score and resets quiz questions
    func gameOver(){
        displayScore()
        quizManager.resetQuiz()
    }
    
    //MARK: - Actions
    
    //Check answer for the given selected answer button and show the result
    @IBAction func checkAnswer(_ sender: UIButton) {
        //Hide countdown timer
        countDownLabel.isHidden = true
        
        //Gets the number corresponding to the button pressed
        let selectedAnswerNumber = getButtonNumber(forButtonPressed: sender)

        //Changes buttons for the selected answer state and reveals answer
        setSelectedAnswerButtonState(exceptPressedButtonNumber: selectedAnswerNumber)
        
        //Updates the text in the result field
        checkAndDisplayResults(forSelectedAnswerNumber: selectedAnswerNumber)
    }
    
    //Progresses through the quiz when progress button pressed
    //Next state determined by state of game: over, beginning, or in progress
    @IBAction func progressThroughQuiz() {
        if quizManager.isGameOver() {
            //Game is over.
            //Reset unasked question indices and number of correct answers
            gameOver()
        } else if quizManager.isGameBeginning() {
            //Game is beginning. Display first question of a new game
            startNewGame()
        } else {
            //Game in progress. Display next question of a continued game
            displayQuestion()
        }
    }
    
    //Lighting mode switch toggled
    @IBAction func lightningModeToggled() {
        //Switches the state whether lighting mode is on
        isLightningModeOn = !isLightningModeOn
        //Switches the state of the UI button accordingly
        lightningModeSwitchToggle.isOn = isLightningModeOn
    }
    
}


