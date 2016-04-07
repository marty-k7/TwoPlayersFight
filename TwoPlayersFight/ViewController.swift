//
//  ViewController.swift
//  TwoPlayersFight
//
//  Created by MacBook Retina i7  on 04/04/16.
//  Copyright © 2016 marty.k7. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var enemyImg: UIImageView!
    @IBOutlet weak var playerImg: UIImageView!
    @IBOutlet weak var printLbl: UILabel!
    @IBOutlet weak var enemyAttackBtn: UIButton!
    @IBOutlet weak var playerAttackBtn: UIButton!
    @IBOutlet weak var enemyHpLbl: UILabel!
    @IBOutlet weak var playerHpLbl: UILabel!
    @IBOutlet weak var enmAttBtnLbl: UILabel!
    @IBOutlet weak var plrAttBtnLbl: UILabel!
    @IBOutlet weak var restartBtn: UIButton!
    
    var player1: Character!
    var enemy1: Character!
    
    var bgSound: AVAudioPlayer!
    var playerSound: AVAudioPlayer!
    var enemySound: AVAudioPlayer!
    var deathSound: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGame()
    }
    
    func initializeGame() {
        let randomAtt1 = Int(arc4random_uniform(UInt32(30))) //random attack from 1 to 30
        let randomAtt2 = Int(arc4random_uniform(UInt32(30)))
        
        
        player1 = Character(name: "Golden Knight", startingHp: 100, attckPwr: randomAtt1)
        enemy1 = Character(name: "Ugly Orc", startingHp: 100, attckPwr: randomAtt2)
        playerHpLbl.text = "\(player1.hp) HP"
        enemyHpLbl.text = "\(enemy1.hp) HP"
        
        
        
        //enemy sound when attacked
        let enemySoundPath = NSBundle.mainBundle().pathForResource("orc", ofType: "wav")
        let enemySoundUrl = NSURL(fileURLWithPath: enemySoundPath!)
        do {
            try enemySound = AVAudioPlayer(contentsOfURL: enemySoundUrl)
            enemySound.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        //player sound when attacked
        let playerSoundPath = NSBundle.mainBundle().pathForResource("soldier", ofType: "wav")
        let playerSoundUrl = NSURL(fileURLWithPath: playerSoundPath!)
        do {
            try playerSound = AVAudioPlayer(contentsOfURL: playerSoundUrl)
            playerSound.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        //background sound
        let bgSoundPath = NSBundle.mainBundle().pathForResource("background", ofType: "wav")
        let bgSOundUrl = NSURL(fileURLWithPath: bgSoundPath!)
        do {
            try bgSound = AVAudioPlayer(contentsOfURL: bgSOundUrl)
            bgSound.prepareToPlay()
            bgSound.numberOfLoops = -1
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        //death sound
        let deathSoundPath = NSBundle.mainBundle().pathForResource("death", ofType: "wav")
        let deathSoundUrl = NSURL(fileURLWithPath: deathSoundPath!)
        do {
            try deathSound = AVAudioPlayer(contentsOfURL: deathSoundUrl)
            deathSound.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        bgSound.play()
    }
    
    @IBAction func onEnemyAttackTapped(sender: AnyObject) {
        if player1.atemptAttack(enemy1.attckPwr)  {
            printLbl.text = "\(enemy1.name) attacked \(player1.name)!"
            playerHpLbl.text = "\(player1.hp) HP"
            disableButton(playerAttackBtn)
            disableButton(enemyAttackBtn)
            enemySound.play()
            
            let origX = self.enemyImg.center.x
            let origY = self.enemyImg.center.y
            
            UIView.animateWithDuration(1.5, delay: 0.0, options: .CurveEaseIn, animations: { self.enemyImg.center = CGPoint(x: origX - 140, y: origY  + 10) }, completion: {finish in })
            
             //UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseIn, animations: { self.enemyImg.center = CGPoint(x: origX, y: origY)}, completion: {finish in} )
//            var frame = self.playerImg.frame
//            frame.origin.x = 600
//            //frame.origin.y = 120
//            UIView.animateWithDuration(2, animations: {
//                self.playerImg.frame = frame })
            
//                //let origX = vc.leftPlayerImg.center.x
//                let origY = vc.leftPlayerImg.center.y
//                
//                UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseIn, animations: { self.vc.leftPlayerImg.center = CGPoint(x: origX + 100, y: origY) }, completion: { finished in (self.playPunchSound()) }
//                )
//                
//                UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseIn, animations: { self.vc.leftPlayerImg.center = CGPoint(x: origX, y: origY) }, completion: { finished in }
            
        }
        if !player1.isAlive {
            printLbl.text = "\(player1.name) has died! \(enemy1.name) won!"
            playerHpLbl.text = ""
            playerImg.hidden = true
            endGame()
           
        }
    
    }
   
    @IBAction func onPlayerAttackTapped(sender: AnyObject) {
        if enemy1.atemptAttack(player1.attckPwr) {
            printLbl.text = "\(player1.name) hits to \(enemy1.name) for \(player1.attckPwr) HP!!!"
            enemyHpLbl.text = "\(enemy1.hp) HP"
            disableButton(enemyAttackBtn)
            disableButton(playerAttackBtn)
            playerSound.play()
            
            let origX = self.playerImg.center.x
            let origY = self.playerImg.center.y
            UIView.animateWithDuration(1.5, delay: 0, options: .CurveEaseIn, animations: {self.playerImg.center = CGPoint(x: origX + 100, y: origY + 10) }, completion: {finish in})
            
            
        }
        if !enemy1.isAlive {
            printLbl.text = "\(player1.name) just killed \(enemy1.name)"
            enemyHpLbl.text = ""
            enemyImg.hidden = true
            endGame()
    
            //bouthBtnsDisabled()
            
        }
    }
    @IBAction func onRestartTapted(sender: AnyObject) {
        restarGameForPlayer()
        initializeGame()
    }
    
    func restarGameForPlayer() {
        playerImg.hidden = false
        enemyImg.hidden = false
        plrAttBtnLbl.hidden = false
        enmAttBtnLbl.hidden = false
        playerAttackBtn.hidden = false
        enemyAttackBtn.hidden = false
        restartBtn.hidden = true
        //bouthBtnsEnabled()
        printLbl.text = "Press attack to start"
        
        
        
    }
    func endGame() {
        enmAttBtnLbl.hidden = true
        plrAttBtnLbl.hidden = true
        enemyAttackBtn.hidden = true
        playerAttackBtn.hidden = true
        restartBtn.hidden = false
        deathSoundPlay()
    }
    
   
//    func bouthBtnsDisabled() {
//        playerAttackBtn.enabled = false
//        enemyAttackBtn.enabled = false
//        
//    }
//    func bouthBtnsEnabled()  {
//        playerAttackBtn.enabled = true
//        enemyAttackBtn.enabled = true
//    }
    
    func enableButton(timer:NSTimer) {
        
        let btn = timer.userInfo as? UIButton
        btn?.enabled = true
    }
    
    func disableButton(btn: UIButton) {
        
            
        btn.enabled = false
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableButton:", userInfo: btn, repeats: false)
        
    }
    
    func deathSoundPlay() {
        if enemySound.playing || playerSound.playing {
            enemySound.stop()
            playerSound.stop()
            //deathSound.play()
            deathSound.playAtTime(deathSound.deviceCurrentTime - 1.0)
        } else {
            deathSound.play()
    }
    }
}

