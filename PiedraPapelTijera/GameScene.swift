//
//  GameScene.swift
//  PiedraPapelTijera
//
//  Created by Juan Salazar on 17/10/16.
//  Copyright (c) 2016 Juan Salazar. All rights reserved.
//

import SpriteKit

var fondo: SKSpriteNode!

var soundWin: SKAction!
var soundFall: SKAction!

var labelInicial: SKLabelNode!
var labelPiedra: SKLabelNode!
var labelPapel: SKLabelNode!
var labelTijera: SKLabelNode!
var labelResultado: SKLabelNode!
var labelScoreUser: SKLabelNode!
var labelScoreMaquina: SKLabelNode!

var piedraButton: SKSpriteNode!
var papelButton: SKSpriteNode!
var tijeraButton: SKSpriteNode!

var nodeSelected: SKSpriteNode!
var nodeMaquina: SKSpriteNode!

var isGame: Bool = false

var numeroAleatorio: Int!

var selUsuario: Int!
var selMaquina: Int!

var win: Int!
var scoreUser: Int!
var scoreMaquina: Int!

let PIEDRA: Int = 1
let PAPEL: Int = 2
let TIJERA: Int = 3

let JUGADOR: Int = 1
let MAQUINA: Int = 2
let EMPATE: Int = 0

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        self.initGame()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(isGame){
            /** El Juego comienza */
            let touch = touches.first
            let touchLocation = touch!.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            /** Posicion para mostrar la opcion seleccionada por el Jugador */
            var positionNode: CGPoint!
            positionNode = CGPointMake(150, (self.frame.height / 2) + 30)
            
            if (touchedNode.name == "piedraButton"){
                print("piedra!!")
                juegoUsuario(imageNameNode: "piedra", postitionNode: positionNode)
                juegoMaquina()
                selUsuario = 1
                
            } else if (touchedNode.name == "papelButton"){
                print("papel!!")
                juegoUsuario(imageNameNode: "papel", postitionNode: positionNode)
                juegoMaquina()
                selUsuario = 2
            } else if (touchedNode.name == "tijeraButton"){
                print("tijera!!")
                juegoUsuario(imageNameNode: "tijera", postitionNode: positionNode)
                juegoMaquina()
                selUsuario = 3
            }
            isGame = false
            quienGana()
        
        } else {
            
            /** Reiniciamos el Juego antes de empezar */
            resetGame()
            
            let showBig = SKAction.scaleTo(1.8, duration: 0.4)
            let showSmall = SKAction.scaleTo(0.1, duration: 0.4)
            let fadeLabel = SKAction.fadeOutWithDuration(0.2)
            let animarLabel = SKAction.sequence([showBig, showSmall, fadeLabel])
            labelInicial.runAction(animarLabel, completion: {
                
                labelPiedra = SKLabelNode(fontNamed: "Noteworthy-Light")
                labelPiedra.text = "Piedra"
                labelPiedra.fontSize = 30
                labelPiedra.zPosition = 15
                labelPiedra.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
                self.addChild(labelPiedra)
                
                let big = SKAction.scaleTo(4, duration: 0.3)
                let small = SKAction.scaleTo(0.5, duration: 0.5)
                let fade = SKAction.fadeOutWithDuration(0.1)
                let seqAnimaLabel = SKAction.sequence([big, small, fade])
                
                labelPiedra.runAction(seqAnimaLabel, completion: {
                    
                    labelPapel = SKLabelNode(fontNamed: "Noteworthy-Light")
                    labelPapel.text = "Papel"
                    labelPapel.fontSize = 30
                    labelPapel.zPosition = 15
                    labelPapel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
                    self.addChild(labelPapel)
                    
                    labelPapel.runAction(seqAnimaLabel, completion: {
                        labelTijera = SKLabelNode(fontNamed: "Noteworthy-Light")
                        labelTijera.text = "Tijera"
                        labelTijera.fontSize = 30
                        labelTijera.zPosition = 15
                        labelTijera.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
                        self.addChild(labelTijera)
                        
                        labelTijera.runAction(seqAnimaLabel, completion: {
                            /** Aqui se temina la animacion de el Label de Tijera */
                            
                            piedraButton = SKSpriteNode(imageNamed: "piedra")
                            piedraButton.position = CGPoint(x: self.frame.midX - 160, y: 180)
                            piedraButton.size = CGSize(width: 120, height: 100)
                            piedraButton.name = "piedraButton"
                            self.addChild(piedraButton)
                            
                            papelButton = SKSpriteNode(imageNamed: "papel")
                            papelButton.position = CGPoint(x: self.frame.midX, y: 180)
                            papelButton.size = CGSize(width: 120, height: 100)
                            papelButton.name = "papelButton"
                            self.addChild(papelButton)
                            
                            tijeraButton = SKSpriteNode(imageNamed: "tijera")
                            tijeraButton.position = CGPoint(x: self.frame.midX + 160, y: 180)
                            tijeraButton.size = CGSize(width: 120, height: 100)
                            tijeraButton.name = "tijeraButton"
                            self.addChild(tijeraButton)
                            
                            if(labelScoreUser == nil) {
                                labelScoreUser = SKLabelNode(fontNamed: "Noteworthy-Light")
                                labelScoreUser.text = "\(scoreUser)"
                                labelScoreUser.fontSize = 30
                                labelScoreUser.zPosition = 5
                                labelScoreUser.fontColor = UIColor.redColor()
                                labelScoreUser.position = CGPoint(x: CGRectGetMidX(self.frame) - 110, y: CGRectGetMaxY(self.frame) - 160)
                                self.addChild(labelScoreUser)
                            }
                            
                            if (labelScoreMaquina == nil) {
                                labelScoreMaquina = SKLabelNode(fontNamed: "Noteworthy-Light")
                                labelScoreMaquina.text = "\(scoreMaquina)"
                                labelScoreMaquina.fontSize = 30
                                labelScoreMaquina.zPosition = 5
                                labelScoreMaquina.fontColor = UIColor.redColor()
                                labelScoreMaquina.position = CGPoint(x: CGRectGetMidX(self.frame) + 110, y: CGRectGetMaxY(self.frame) - 160)
                                self.addChild(labelScoreMaquina)
                            }
                            
                        })
                    })
                    
                })
                
            })
            
            isGame = true
            
        }

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func initGame() {
        
        /** Ubicamos el Fondo */
        fondo = SKSpriteNode(imageNamed: "fondo")
        fondo.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        fondo.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.addChild(fondo)
        
        labelInicial = SKLabelNode(fontNamed: "Noteworthy-Light")
        labelInicial.text = "Toca para inciar !!"
        labelInicial.fontSize = 30
        labelInicial.fontColor = UIColor.blackColor()
        labelInicial.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(labelInicial)
        
        /** Se inicializan los puntajes */
        scoreUser = 0
        scoreMaquina = 0
        
        /** Variable para controlar quien Gano */
        // Empate = 0
        // Jugador Gana = 1
        // Maquina Gana = 2
        win = EMPATE
        
        /** Se inicializan  los sonidos del Juego */
        soundWin = SKAction.playSoundFileNamed("win.mp3", waitForCompletion: true)
        soundFall = SKAction.playSoundFileNamed("fall.mp3", waitForCompletion: true)
        
    }
    
    func quienGana() {
        
        if (selUsuario == PIEDRA && selMaquina == PAPEL) {
            win = MAQUINA
        } else if (selUsuario == PIEDRA && selMaquina == TIJERA) {
            win = JUGADOR
        } else if (selUsuario == PAPEL && selMaquina == TIJERA) {
            win = MAQUINA
        } else if (selUsuario == PAPEL && selMaquina == PIEDRA) {
            win = JUGADOR
        } else if (selUsuario == TIJERA && selMaquina == PIEDRA) {
            win = MAQUINA
        } else if (selUsuario == TIJERA && selMaquina == PAPEL) {
            win = JUGADOR
        } else if (selUsuario == selMaquina) {
            win = EMPATE
        }
        
        if (win == JUGADOR) {
            labelResultado = SKLabelNode(fontNamed: "Noteworthy-Light")
            labelResultado.text = "Ganaste !!!"
            labelResultado.fontSize = 50
            labelResultado.zPosition = 100
            labelResultado.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            self.addChild(labelResultado)
            
            labelScoreUser.runAction(soundWin)
            
            scoreUser = scoreUser + 1
            labelScoreUser.text = "\(scoreUser)"
            
        } else if (win == MAQUINA) {
            labelResultado = SKLabelNode(fontNamed: "Noteworthy-Light")
            labelResultado.text = "Perdiste !!!"
            labelResultado.fontSize = 50
            labelResultado.zPosition = 100
            labelResultado.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            self.addChild(labelResultado)
            
            labelScoreMaquina.runAction(soundFall)
            
            scoreMaquina = scoreMaquina + 1
            labelScoreMaquina.text = "\(scoreMaquina)"
        } else if (win == EMPATE) {
            labelResultado = SKLabelNode(fontNamed: "Noteworthy-Light")
            labelResultado.text = "Empate !!!"
            labelResultado.fontSize = 50
            labelResultado.zPosition = 100
            labelResultado.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            self.addChild(labelResultado)
        }
        
        labelInicial = SKLabelNode(fontNamed: "Noteworthy-Light")
        labelInicial.text = "Pulsa para Jugar de nuevo"
        labelInicial.fontSize = 35
        labelInicial.zPosition = 100
        labelInicial.fontColor = UIColor.blackColor()
        labelInicial.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 50)
        self.addChild(labelInicial)
        
    }
    
    /** Se obtiene la seleccion del usuario */
    func juegoUsuario(imageNameNode imageNameNode:String, postitionNode:CGPoint) {
        
        nodeSelected = SKSpriteNode(imageNamed: imageNameNode)
        nodeSelected.position = postitionNode
        nodeSelected.size = CGSize(width: 250, height: 250)
        self.addChild(nodeSelected)
        
    }
    
    /** Obtener el Juego de la maquina */
    func juegoMaquina() {
        
        numeroAleatorio = crearNumerosAleatorios(min: 1, max: 3)
        
        var positionNode: CGPoint!
        positionNode = CGPointMake(self.frame.width - 150, (self.frame.height / 2) + 30)
        
        if (numeroAleatorio == PIEDRA){
            // Piedra
            nodeMaquina = SKSpriteNode(imageNamed: "piedra")
            nodeMaquina.position = positionNode
            nodeMaquina.size = CGSize(width: 250, height: 250)
            self.addChild(nodeMaquina)
            selMaquina = 1
            
        } else if (numeroAleatorio == PAPEL){
            // Papel
            nodeMaquina = SKSpriteNode(imageNamed: "papel")
            nodeMaquina.position = positionNode
            nodeMaquina.size = CGSize(width: 250, height: 250)
            self.addChild(nodeMaquina)
            selMaquina = 2
        } else if (numeroAleatorio == TIJERA) {
            // Tijera
            nodeMaquina = SKSpriteNode(imageNamed: "tijera")
            nodeMaquina.position = positionNode
            nodeMaquina.size = CGSize(width: 250, height: 250)
            self.addChild(nodeMaquina)
            selMaquina = 3
        }
        
    }
    
    func resetGame() {
        let delNodo = SKAction.removeFromParent()
        
        if (piedraButton != nil) {
            piedraButton.runAction(delNodo)
        }
        
        if (papelButton != nil) {
            papelButton.runAction(delNodo)
        }
        
        if (tijeraButton != nil) {
            tijeraButton.runAction(delNodo)
        }
        
        if (nodeSelected != nil) {
            nodeSelected.runAction(delNodo)
        }
        
        if (nodeMaquina != nil) {
            nodeMaquina.runAction(delNodo)
        }
        
        if (labelResultado != nil) {
            labelResultado.runAction(delNodo)
        }
    }
    
    
    /** Funcion encargada de crear un numero aleatorio */
    func crearNumerosAleatorios(min min:Int, max:Int ) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + min))) + min
    }
}
