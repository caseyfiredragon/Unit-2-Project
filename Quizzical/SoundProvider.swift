//
//  SoundProvider.swift
//  Quizzical
//
//  Created by Casey Conway on 4/25/19.
//  Copyright © 2019 Casey Conway. All rights reserved.
//

import AudioToolbox

//Custom type created to hold related values and functions for game sounds
class GameSound {
    var systemSoundID: SystemSoundID = 0
    let fileName: String
    
    init (fileName: String) {
        self.fileName = fileName
    }
    
    //Plays game sound
    func playGameSound(){
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    //Loads game sound
    func loadGameSounds() {
        let path = Bundle.main.path(forResource: fileName, ofType: "m4a")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &systemSoundID)
    }
}

//Declare properties of custom type GameSound
let gameLoadSound = GameSound(fileName: "GameLoadSound")
let gameStartSound = GameSound(fileName: "GameStartSound")
let gameEndSound = GameSound(fileName: "GameEndSound")
let timesUpSound = GameSound(fileName: "TimesUpSound")
let incorrectAnswerSound = GameSound(fileName: "IncorrectAnswerSound")
let correctAnswerSound = GameSound(fileName: "CorrectAnswerSound")

class GameSounds {
    let gameSoundSet: [GameSound]
    
    init(gameSoundSet: [GameSound]){
        self.gameSoundSet = gameSoundSet
    }
    
    //Load game sounds
    func loadGameSounds() {
        for gameSound in gameSoundSet {
            let path = Bundle.main.path(forResource: gameSound.fileName, ofType: "m4a")
            let soundUrl = URL(fileURLWithPath: path!)
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound.systemSoundID)
        }
    }
}

//Organize all the sounds in an array
let gameSounds = GameSounds(gameSoundSet:[gameLoadSound,gameStartSound,gameEndSound,timesUpSound,incorrectAnswerSound,correctAnswerSound])
