//
//  VoiceSelectionPage.swift
//  Echo
//
//  Created by Gavin Henderson on 28/09/2023.
//

import Foundation
import SwiftUI
import AVFAudio

struct VoiceSelectionPage: View {
    @EnvironmentObject var voiceEngine: VoiceEngine
    
    @State var cuePitch: Double = 0
    @State var cueVolume: Double = 0
    @State var cueRate: Double = 0
    @State var cueVoiceId: String = ""
    @State var cueVoiceName: String = ""
    
    @State var speakingPitch: Double = 0
    @State var speakingVolume: Double = 0
    @State var speakingRate: Double = 0
    @State var speakingVoiceId: String = ""
    @State var speakingVoiceName: String = ""
    
    func loadSettings() {
        speakingPitch = Double(voiceEngine.speakingVoiceOptions.pitch)
        speakingVolume = Double(voiceEngine.speakingVoiceOptions.volume)
        speakingRate = Double(voiceEngine.speakingVoiceOptions.rate)
        
        cuePitch = Double(voiceEngine.cueVoiceOptions.pitch)
        cueVolume = Double(voiceEngine.cueVoiceOptions.volume)
        cueRate = Double(voiceEngine.cueVoiceOptions.rate)
    }
    
    func loadVoices() {
        speakingVoiceId = voiceEngine.speakingVoiceOptions.voiceId
        cueVoiceId = voiceEngine.cueVoiceOptions.voiceId
        
        let cueVoice = AVSpeechSynthesisVoice(identifier: cueVoiceId) ?? AVSpeechSynthesisVoice()
        let speakingVoice = AVSpeechSynthesisVoice(identifier: speakingVoiceId) ?? AVSpeechSynthesisVoice()
                
        speakingVoiceName = "\(speakingVoice.name) (\(getLanguage(speakingVoice.language)))"
        cueVoiceName = "\(cueVoice.name) (\(getLanguage(cueVoice.language)))"
    }
    
    func save() {
        let cueVoice = VoiceOptions(
            voiceId: cueVoiceId,
            rate: Float(cueRate),
            pitch: Float(cuePitch),
            volume: Float(cueVolume)
        )
        let speakingVoice = VoiceOptions(
            voiceId: speakingVoiceId,
            rate: Float(speakingRate),
            pitch: Float(speakingPitch),
            volume: Float(speakingVolume)
        )
        
        voiceEngine.cueVoiceOptions = cueVoice
        voiceEngine.speakingVoiceOptions = speakingVoice
        voiceEngine.save()
    }
    
    var body: some View {
        Form {
                VoiceOptionsArea(
                    title: "Speaking Voice",
                    // swiftlint:disable:next line_length
                    helpText: "Your speaking voice is the voice that is used to communicate with your communication partner. Select the options that you want to represent your voice.",
                    pitch: $speakingPitch,
                    rate: $speakingRate,
                    volume: $speakingVolume,
                    voiceId: $speakingVoiceId,
                    voiceName: $speakingVoiceName,
                    playSample: {
                        let speakingVoice = VoiceOptions(
                            voiceId: speakingVoiceId,
                            rate: Float(speakingRate),
                            pitch: Float(speakingPitch),
                            volume: Float(speakingVolume)
                        )
                        voiceEngine.play(
                            "Thank you for using Echo, this is your speaking voice.",
                            voiceOptions: speakingVoice
                        )
                    }
                )
                VoiceOptionsArea(
                    title: "Cue Voice",
                    // swiftlint:disable:next line_length
                    helpText: "Your cue voice is the voice that is used to speak information to you. Select the options tht you want to hear when Echo is talking to you.",
                    pitch: $cuePitch,
                    rate: $cueRate,
                    volume: $cueVolume,
                    voiceId: $cueVoiceId,
                    voiceName: $cueVoiceName,
                    playSample: {
                        let cueVoice = VoiceOptions(
                            voiceId: cueVoiceId,
                            rate: Float(cueRate),
                            pitch: Float(cuePitch),
                            volume: Float(cueVolume)
                        )
                        voiceEngine.play("Thank you for using Echo, this is your cue voice", voiceOptions: cueVoice)
                    }
                )
        }
        .onAppear {
            loadSettings()

            if speakingVoiceId == "" || cueVoiceId == "" {
                loadVoices()
            }
        }
        .onDisappear {
            save()
        }
    }
}

private struct PreviewWrapper: View {
    @StateObject var voiceEngine: VoiceEngine = VoiceEngine()
    
    var body: some View {
        NavigationStack {
            Text("Main Page")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    navigationDestination(isPresented: .constant(true), destination: {
                        VoiceSelectionPage()
                            .environmentObject(voiceEngine)

                    })
                    
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

struct VoiceSelectionPage_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PreviewWrapper().preferredColorScheme(.light)
    }
}
