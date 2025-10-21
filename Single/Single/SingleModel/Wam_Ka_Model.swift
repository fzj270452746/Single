
import UIKit

// Leikjakort með tímastjórnun
struct LeikjaSpjald {
    var auðkenni: String
    var grunnGogn: FlisaGogn
    var sekundurEftir: Int
    var erUtrunnid: Bool
    var erValid: Bool
}

extension LeikjaSpjald {
    // Býr til stokkinn af leikjaspjöldum
    static func byyjaLeikjastokk(fjoldi: Int, parHamur: Bool) -> [LeikjaSpjald] {
        var nyrStokkur: [LeikjaSpjald] = []
        
        if parHamur {
            let jafnFjoldi = fjoldi % 2 == 0 ? fjoldi : fjoldi - 1
            let allirFlisa: [FlisaGogn] = [
                flisaTong1, flisaTong2, flisaTong3, flisaTong4, flisaTong5, flisaTong6, flisaTong7, flisaTong8, flisaTong9,
                flisaTiao1, flisaTiao2, flisaTiao3, flisaTiao4, flisaTiao5, flisaTiao6, flisaTiao7, flisaTiao8, flisaTiao9,
                flisaWan1, flisaWan2, flisaWan3, flisaWan4, flisaWan5, flisaWan6, flisaWan7, flisaWan8, flisaWan9
            ]
            
            var blandadurStokkur = allirFlisa.shuffled()
            let fjoldiPara = jafnFjoldi / 2
            
            for stadsetning in 0..<min(fjoldiPara, blandadurStokkur.count) {
                let nuverdandiFlisa = blandadurStokkur[stadsetning]
                let fyrriTimi = Int.random(in: 15...30)
                let seinniTimi = Int.random(in: 15...30)
                
                nyrStokkur.append(LeikjaSpjald(auðkenni: UUID().uuidString, grunnGogn: nuverdandiFlisa, sekundurEftir: fyrriTimi, erUtrunnid: false, erValid: false))
                nyrStokkur.append(LeikjaSpjald(auðkenni: UUID().uuidString, grunnGogn: nuverdandiFlisa, sekundurEftir: seinniTimi, erUtrunnid: false, erValid: false))
            }
            
            nyrStokkur.shuffle()
            return nyrStokkur
        } else {
            // Hlaupa hamur: þrefaldur rás
            let fjoldiThrefaldur = (fjoldi / 3) * 3
            
            var moguleikarHlaupar: [(String, Int)] = []
            let flokkarAllir = [flokkTong, flokkTiao, flokkWan]
            
            for flokkurNu in flokkarAllir {
                for byrjunTala in 1...7 {
                    moguleikarHlaupar.append((flokkurNu, byrjunTala))
                }
            }
            
            var fjoldiByggdir = 0
            while fjoldiByggdir < fjoldiThrefaldur {
                moguleikarHlaupar.shuffle()
                
                for (flokkNu, byrjunNu) in moguleikarHlaupar {
                    guard fjoldiByggdir < fjoldiThrefaldur else { break }
                    
                    if let flisa1 = nalgastFlisu(flokkur: flokkNu, tolugildi: byrjunNu),
                       let flisa2 = nalgastFlisu(flokkur: flokkNu, tolugildi: byrjunNu + 1),
                       let flisa3 = nalgastFlisu(flokkur: flokkNu, tolugildi: byrjunNu + 2) {
                        
                        nyrStokkur.append(LeikjaSpjald(auðkenni: UUID().uuidString, grunnGogn: flisa1, sekundurEftir: Int.random(in: 15...30), erUtrunnid: false, erValid: false))
                        nyrStokkur.append(LeikjaSpjald(auðkenni: UUID().uuidString, grunnGogn: flisa2, sekundurEftir: Int.random(in: 15...30), erUtrunnid: false, erValid: false))
                        nyrStokkur.append(LeikjaSpjald(auðkenni: UUID().uuidString, grunnGogn: flisa3, sekundurEftir: Int.random(in: 15...30), erUtrunnid: false, erValid: false))
                        fjoldiByggdir += 3
                    }
                }
            }
            
            nyrStokkur.shuffle()
            return nyrStokkur
        }
    }

    // Nær í flísu samkvæmt flokki og tölu
    static func nalgastFlisu(flokkur: String, tolugildi: Int) -> FlisaGogn? {
        switch flokkur {
        case flokkTong:
            switch tolugildi {
            case 1: return flisaTong1
            case 2: return flisaTong2
            case 3: return flisaTong3
            case 4: return flisaTong4
            case 5: return flisaTong5
            case 6: return flisaTong6
            case 7: return flisaTong7
            case 8: return flisaTong8
            case 9: return flisaTong9
            default: return nil
            }
        case flokkTiao:
            switch tolugildi {
            case 1: return flisaTiao1
            case 2: return flisaTiao2
            case 3: return flisaTiao3
            case 4: return flisaTiao4
            case 5: return flisaTiao5
            case 6: return flisaTiao6
            case 7: return flisaTiao7
            case 8: return flisaTiao8
            case 9: return flisaTiao9
            default: return nil
            }
        case flokkWan:
            switch tolugildi {
            case 1: return flisaWan1
            case 2: return flisaWan2
            case 3: return flisaWan3
            case 4: return flisaWan4
            case 5: return flisaWan5
            case 6: return flisaWan6
            case 7: return flisaWan7
            case 8: return flisaWan8
            case 9: return flisaWan9
            default: return nil
            }
        default:
            return nil
        }
    }

    // Athugar hvort tvö spjöld séu eins
    static func erutSommuPor(_ fyrsta: LeikjaSpjald, _ annaid: LeikjaSpjald) -> Bool {
        let flokkurSamsvara = fyrsta.grunnGogn.flokkurTegund == annaid.grunnGogn.flokkurTegund
        let titillSamsvara = fyrsta.grunnGogn.titillTala == annaid.grunnGogn.titillTala
        let nidurstada = flokkurSamsvara && titillSamsvara
        
        return nidurstada
    }

    // Athugar hvort þrjú spjöld myndi raðbundna hlaup
    static func erRadbundinHlaup(_ fylki: [LeikjaSpjald]) -> Bool {
        guard fylki.count == 3 else { return false }
        
        let flokkurinn = fylki[0].grunnGogn.flokkurTegund
        if !fylki.allSatisfy({ $0.grunnGogn.flokkurTegund == flokkurinn }) { return false }
        
        let tolugildi = fylki.compactMap { Int($0.grunnGogn.titillTala) }.sorted()
        guard tolugildi.count == 3 else { return false }
        
        return tolugildi[0] + 1 == tolugildi[1] && tolugildi[1] + 1 == tolugildi[2]
    }
}

