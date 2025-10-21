
import Foundation

// Observable wrapper fyrir gögn bindingu
class Skygjanlegt<T> {
    typealias Athugandi = (T) -> Void
    
    var gildi: T {
        didSet {
            athugendur.forEach { $0(gildi) }
        }
    }
    
    private var athugendur: [Athugandi] = []
    
    init(_ upphafGildi: T) {
        self.gildi = upphafGildi
    }
    
    func binda(_ athugandi: @escaping Athugandi) {
        athugendur.append(athugandi)
        athugandi(gildi) // Kalla strax með núverandi gildi
    }
    
    func hreinsa() {
        athugendur.removeAll()
    }
}

// ViewModel grunnur protokoll
protocol GrunnSynasafnslikan {
    associatedtype SynastadaTagund
    var synastada: Skygjanlegt<SynastadaTagund> { get }
}

