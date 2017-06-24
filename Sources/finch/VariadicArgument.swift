//
//  VariadicArgumentOperator.swift
//  todo
//
//  Created by Michael Bates on 6/22/17.
//

import Commandant
import Result

infix operator <|* : MultiplicationPrecedence

func <|* <ClientError>(mode: CommandMode, argument: Argument<String>) -> Result<String, CommandantError<ClientError>> {
  let variadArgument = Argument<[String]>(defaultValue: [], usage: argument.usage)
  let result: Result<[String], CommandantError<ClientError>> = mode <| variadArgument

  switch result {
  case let .success(values):
    return .success(values.joined(separator: " "))
  case let .failure(error):
    return .failure(error)
  }
}
