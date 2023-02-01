//
//  FirebaseManager.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/30.
//

import Combine
import Firebase
import FirebaseDatabase

class FirebaseManager<T: Codable> {
    typealias Entity = T
    
    private let reference: DatabaseReference
    private let rootChildID: String
    
    init(rootChildID: String) {
        self.rootChildID = rootChildID
        let database = Database.database()
        reference = database.reference()
    }

    func setValue(uid: String,
                  childId: String,
                  model: Entity) -> AnyPublisher<Void, Error> {
        guard let encodedData = try? JSONEncoder().encode(model)
        else { return Fail<Void, Error>(error: FirebaseError.encoding).eraseToAnyPublisher() }
        guard let jsonData = try? JSONSerialization.jsonObject(with: encodedData)
        else { return Fail<Void, Error>(error: FirebaseError.JSONSerialization).eraseToAnyPublisher() }

            return Future <Void, Error> { [weak self] promise in
                guard let self = self else { return }
                
                self.reference.child(self.rootChildID).child(uid).child(childId).setValue(jsonData) { error, reference in
                    if let error = error {
                        promise(.failure(error))
                    }
                    
                    promise(.success(()))
                }
            }.eraseToAnyPublisher()
    }
    
    func readAllValue(uid: String) -> AnyPublisher<[Entity], FirebaseError> {
        return Future<[Entity], FirebaseError> { [weak self] promise in
            guard let self = self else { return }
            
            self.reference.child(self.rootChildID).child(uid).observeSingleEvent(of: .value, with: { [weak self] snapshot in
                guard let self = self else { return }
                
                let dictionary = self.convertDataSnapshot(snapshot)
                let jsondata = self.convertJSONSerialization(with: dictionary)
                let data = self.decode(with: jsondata)
                
                switch data {
                case .success(let model):
                    promise(.success(model))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    func deleteValue(uid: String, childId: String) -> AnyPublisher<Void, Error> {
        Future <Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            self.reference.child(self.rootChildID).child(uid).child(childId).removeValue { error, reference in
                if let error = error {
                    promise(.failure(error))
                }
                
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    private func decode(with data: Result<Data, FirebaseError>) -> Result<[Entity], FirebaseError> {
        switch data {
        case .success(let jsonData):
            guard let decodedData = try? JSONDecoder().decode([Entity].self, from: jsonData)
            else { return .failure(.decoding) }
            
            return .success(decodedData)
        case.failure(let error):
            return .failure(error)
        }
    }
    
    private func convertDataSnapshot(_ snapshot: DataSnapshot) -> Result<[String: Any], FirebaseError> {
        guard let dictionary = snapshot.value as? [String: Any]
        else { return .failure(.dataSnapshot) }
        
        return .success(dictionary)
    }
    
    private func convertJSONSerialization(with dictionary: Result<[String: Any], FirebaseError>)
    -> Result<Data, FirebaseError> {
        switch dictionary {
        case .success(let data):
            let values = data.map {
                $0.value
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: values)
            else { return .failure(.JSONSerialization) }
            
            return .success(jsonData)
        case .failure(let error):
            return .failure(error)
        }
    }
}
