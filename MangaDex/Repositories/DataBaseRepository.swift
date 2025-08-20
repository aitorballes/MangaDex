import SwiftData
import Foundation

protocol DataBaseRepository {
    func importAuthors(_ networkRepository: DataRepository) async throws
}

struct DataBaseRepositoryImpl: DataBaseRepository {
    let modelContext: ModelContext
    
    func importAuthors(_ networkRepository: DataRepository) async throws {
        let authors = try await networkRepository.getAuthors()
        authors.forEach { author in            
            modelContext.insert(author.toModel())
        }
    }
}
            

